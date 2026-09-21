package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path"
	"runtime"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"unsafe"

	"github.com/rclone/rclone/fs"
	"github.com/rclone/rclone/fs/accounting"
	"github.com/rclone/rclone/fs/config"
	"github.com/rclone/rclone/fs/config/configfile"
	"github.com/rclone/rclone/fs/operations"
	rclonesync "github.com/rclone/rclone/fs/sync"

	// Selected Backends for size optimization & required cloud support
	_ "github.com/rclone/rclone/backend/drive"
	_ "github.com/rclone/rclone/backend/dropbox"
	_ "github.com/rclone/rclone/backend/local"
	_ "github.com/rclone/rclone/backend/onedrive"
	_ "github.com/rclone/rclone/backend/s3"
	_ "github.com/rclone/rclone/backend/sftp"
	_ "github.com/rclone/rclone/backend/webdav"
)

// Response represents a standard JSON response wrapper for FFI calls.
type Response struct {
	Success bool        `json:"success"`
	Error   string      `json:"error,omitempty"`
	Data    interface{} `json:"data,omitempty"`
}

func ResponseError(err error) Response {
	return Response{
		Success: false,
		Error:   err.Error(),
	}
}

func ResponseSuccess(data interface{}) Response {
	return Response{
		Success: true,
		Data:    data,
	}
}

// RemoteInfo describes a configured cloud remote.
type RemoteInfo struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Description string `json:"description,omitempty"`
}

// FileItem describes a file or directory item returned by ListDirectory.
type FileItem struct {
	Name     string `json:"name"`
	Path     string `json:"path"`
	IsDir    bool   `json:"is_dir"`
	Size     int64  `json:"size"`
	ModTime  string `json:"mod_time"`
	MimeType string `json:"mime_type,omitempty"`
	ID       string `json:"id,omitempty"`
}

// MemoryStorage implements config.Storage entirely in RAM to avoid saving plaintext files on disk.
type MemoryStorage struct {
	mu       sync.RWMutex
	sections map[string]map[string]string
}

func newMemoryStorage() *MemoryStorage {
	return &MemoryStorage{
		sections: make(map[string]map[string]string),
	}
}

func (s *MemoryStorage) GetSectionList() []string {
	s.mu.RLock()
	defer s.mu.RUnlock()
	res := make([]string, 0, len(s.sections))
	for k := range s.sections {
		res = append(res, k)
	}
	return res
}

func (s *MemoryStorage) HasSection(section string) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	_, ok := s.sections[section]
	return ok
}

func (s *MemoryStorage) DeleteSection(section string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	delete(s.sections, section)
}

func (s *MemoryStorage) GetKeyList(section string) []string {
	s.mu.RLock()
	defer s.mu.RUnlock()
	sec, ok := s.sections[section]
	if !ok {
		return nil
	}
	res := make([]string, 0, len(sec))
	for k := range sec {
		res = append(res, k)
	}
	return res
}

func (s *MemoryStorage) GetValue(section, key string) (string, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	sec, ok := s.sections[section]
	if !ok {
		return "", false
	}
	v, ok := sec[key]
	return v, ok
}

func (s *MemoryStorage) SetValue(section, key, value string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	sec, ok := s.sections[section]
	if !ok {
		sec = make(map[string]string)
		s.sections[section] = sec
	}
	sec[key] = value
}

func (s *MemoryStorage) DeleteKey(section, key string) bool {
	s.mu.Lock()
	defer s.mu.Unlock()
	sec, ok := s.sections[section]
	if !ok {
		return false
	}
	if _, ok := sec[key]; !ok {
		return false
	}
	delete(sec, key)
	return true
}

func (s *MemoryStorage) Load() error {
	return nil
}

func (s *MemoryStorage) Save() error {
	return nil
}

func (s *MemoryStorage) Serialize() (string, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	var sb strings.Builder
	for secName, secKeys := range s.sections {
		sb.WriteString(fmt.Sprintf("[%s]\n", secName))
		for k, v := range secKeys {
			sb.WriteString(fmt.Sprintf("%s = %s\n", k, v))
		}
		sb.WriteString("\n")
	}
	return sb.String(), nil
}

func init() {
	_ = os.Setenv("RCLONE_LOCAL_COPY_LINKS", "true")
	_ = os.Setenv("RCLONE_COPY_LINKS", "true")
	_ = os.Setenv("RCLONE_LOCAL_SKIP_LINKS", "true")
	_ = os.Setenv("RCLONE_SKIP_LINKS", "true")
}

func (s *MemoryStorage) LoadFromIni(content string) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.sections = make(map[string]map[string]string)

	currentSection := ""
	lines := strings.Split(content, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") || strings.HasPrefix(line, ";") {
			continue
		}
		if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
			currentSection = strings.TrimSpace(line[1 : len(line)-1])
			if currentSection != "" && s.sections[currentSection] == nil {
				s.sections[currentSection] = make(map[string]string)
			}
			continue
		}
		if currentSection != "" {
			parts := strings.SplitN(line, "=", 2)
			if len(parts) == 2 {
				k := strings.TrimSpace(parts[0])
				v := strings.TrimSpace(parts[1])
				s.sections[currentSection][k] = v
			}
		}
	}

	// Ensure any local remote in loaded config has copy_links and skip_links
	for _, sec := range s.sections {
		if strings.EqualFold(sec["type"], "local") {
			if _, ok := sec["copy_links"]; !ok {
				sec["copy_links"] = "true"
			}
			if _, ok := sec["skip_links"]; !ok {
				sec["skip_links"] = "true"
			}
		}
	}

	return nil
}

var currentMemStorage *MemoryStorage

func cJsonString(v interface{}) *C.char {
	b, err := json.Marshal(v)
	if err != nil {
		return C.CString(fmt.Sprintf(`{"success":false,"error":%q}`, err.Error()))
	}
	return C.CString(string(b))
}

func cResponse(resp Response) *C.char {
	return cJsonString(resp)
}

func isLocalRemote(remote string) bool {
	remote = strings.TrimSpace(remote)
	if strings.EqualFold(remote, "local") {
		return true
	}
	if currentMemStorage != nil {
		t, ok := currentMemStorage.GetValue(remote, "type")
		if ok && strings.EqualFold(strings.TrimSpace(t), "local") {
			return true
		}
	}
	return false
}

func isAndroid() bool {
	return runtime.GOOS == "android" || os.Getenv("ANDROID_DATA") != "" || os.Getenv("ANDROID_ROOT") != ""
}

func getLocalBaseDir(remote string) string {
	if currentMemStorage != nil && remote != "" {
		if customRoot, ok := currentMemStorage.GetValue(remote, "root"); ok && strings.TrimSpace(customRoot) != "" {
			return strings.TrimSpace(customRoot)
		}
	}
	if isAndroid() {
		for _, candidate := range []string{"/storage/emulated/0", "/sdcard"} {
			if _, err := os.Stat(candidate); err == nil {
				return candidate
			}
		}
		return "/storage/emulated/0"
	}
	return "/"
}

func makeFsTarget(remote, p string) string {
	remote = strings.TrimSpace(remote)
	raw := strings.TrimSpace(p)

	if remote == "" {
		if raw == "" || raw == "." {
			return "."
		}
		return raw
	}

	cleanPath := strings.Trim(raw, "/")

	if isLocalRemote(remote) {
		base := getLocalBaseDir(remote)
		if cleanPath == "" {
			if base == "/" {
				return remote + ":/"
			}
			return remote + ":" + base
		}
		if base != "/" && (strings.HasPrefix(raw, base) || strings.HasPrefix(raw, "/storage") || strings.HasPrefix(raw, "/data") || strings.HasPrefix(raw, "/mnt")) {
			return remote + ":" + raw
		}
		if base == "/" {
			return remote + ":/" + cleanPath
		}
		return remote + ":" + strings.TrimSuffix(base, "/") + "/" + cleanPath
	}

	if strings.HasSuffix(remote, ":") {
		return remote + cleanPath
	}

	if strings.Contains(remote, ":") {
		if cleanPath == "" {
			return remote
		}
		return strings.TrimSuffix(remote, "/") + "/" + cleanPath
	}

	if cleanPath == "" {
		return remote + ":"
	}
	return remote + ":" + cleanPath
}

// --- Pure Go Internal Implementations ---

func InitRcloneInternal(configPath string) Response {
	// Enable following symlinks on local filesystem by default.
	// This prevents "NOTICE: <dir>: Can't follow symlink without -L/--copy-links"
	// and allows proper browsing/copying of symlinked directories (e.g. /bin -> /usr/bin, /lib -> /usr/lib on Linux).
	_ = os.Setenv("RCLONE_LOCAL_COPY_LINKS", "true")
	_ = os.Setenv("RCLONE_COPY_LINKS", "true")
	_ = os.Setenv("RCLONE_LOCAL_SKIP_LINKS", "true")
	_ = os.Setenv("RCLONE_SKIP_LINKS", "true")

	cfg := strings.TrimSpace(configPath)
	if cfg != "" {
		config.SetConfigPath(cfg)
		configfile.Install()
		return ResponseSuccess(map[string]string{
			"config_path": config.GetConfigPath(),
			"mode":        "file",
		})
	}

	if currentMemStorage == nil {
		currentMemStorage = newMemoryStorage()
	}
	config.SetData(currentMemStorage)

	return ResponseSuccess(map[string]string{
		"config_path": config.GetConfigPath(),
		"mode":        "memory",
	})
}

func LoadConfigInMemoryInternal(content string) Response {
	if currentMemStorage == nil {
		currentMemStorage = newMemoryStorage()
	}
	err := currentMemStorage.LoadFromIni(content)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to parse INI config: %w", err))
	}
	config.SetData(currentMemStorage)

	return ResponseSuccess(map[string]interface{}{
		"message": "Config loaded into memory successfully",
		"remotes": currentMemStorage.GetSectionList(),
	})
}

func ExportConfigInMemoryInternal() Response {
	if currentMemStorage == nil {
		return ResponseSuccess("")
	}
	iniStr, err := currentMemStorage.Serialize()
	if err != nil {
		return ResponseError(fmt.Errorf("failed to serialize config: %w", err))
	}
	return ResponseSuccess(iniStr)
}

func SetRemoteConfigInternal(remoteName, remoteType, optionsJson string) Response {
	rName := strings.TrimSpace(remoteName)
	rType := strings.TrimSpace(remoteType)
	if rName == "" || rType == "" {
		return ResponseError(fmt.Errorf("remoteName and remoteType cannot be empty"))
	}

	opts := make(map[string]string)
	oJson := strings.TrimSpace(optionsJson)
	if oJson != "" {
		var rawMap map[string]interface{}
		if err := json.Unmarshal([]byte(oJson), &rawMap); err != nil {
			return ResponseError(fmt.Errorf("invalid options JSON: %w", err))
		}
		for k, v := range rawMap {
			opts[k] = fmt.Sprintf("%v", v)
		}
	}

	if strings.EqualFold(rType, "local") {
		if _, ok := opts["copy_links"]; !ok {
			opts["copy_links"] = "true"
		}
		if _, ok := opts["skip_links"]; !ok {
			opts["skip_links"] = "true"
		}
	}

	if currentMemStorage == nil {
		currentMemStorage = newMemoryStorage()
	}
	config.SetData(currentMemStorage)

	currentMemStorage.SetValue(rName, "type", rType)
	for k, v := range opts {
		currentMemStorage.SetValue(rName, k, v)
	}

	return ResponseSuccess(map[string]string{
		"message": "Remote configured successfully",
		"remote":  rName,
		"type":    rType,
	})
}

func DeleteRemoteInternal(remoteName string) Response {
	rName := strings.TrimSpace(remoteName)
	if rName == "" {
		return ResponseError(fmt.Errorf("remoteName cannot be empty"))
	}
	if currentMemStorage != nil {
		currentMemStorage.DeleteSection(rName)
	}
	return ResponseSuccess(map[string]string{
		"message": "Remote deleted from config",
		"remote":  rName,
	})
}

func ListRemotesInternal() Response {
	remotes := config.GetRemotes()
	list := make([]RemoteInfo, 0, len(remotes))
	for _, r := range remotes {
		list = append(list, RemoteInfo{
			Name:        r.Name,
			Type:        r.Type,
			Description: r.Description,
		})
	}
	return ResponseSuccess(list)
}

// AboutInfo describes storage usage (total, used, free in bytes).
type AboutInfo struct {
	Total int64 `json:"total"`
	Used  int64 `json:"used"`
	Free  int64 `json:"free"`
}

func GetRemoteAboutInternal(remote string) Response {
	target := makeFsTarget(remote, "")
	ctx := context.Background()

	f, err := fs.NewFs(ctx, target)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to open remote %q: %w", target, err))
	}

	info := AboutInfo{
		Total: -1,
		Used:  -1,
		Free:  -1,
	}

	doAbout := f.Features().About
	if doAbout != nil {
		u, err := doAbout(ctx)
		if err == nil && u != nil {
			if u.Total != nil {
				info.Total = *u.Total
			}
			if u.Used != nil {
				info.Used = *u.Used
			}
			if u.Free != nil {
				info.Free = *u.Free
			} else if u.Total != nil && u.Used != nil {
				info.Free = *u.Total - *u.Used
			}
			if info.Used == -1 && u.Total != nil && u.Free != nil {
				info.Used = *u.Total - *u.Free
			}
		}
	}

	return ResponseSuccess(info)
}

func ListDirectoryInternal(remote, dirPath string) Response {
	target := makeFsTarget(remote, dirPath)
	ctx := context.Background()

	f, err := fs.NewFs(ctx, target)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to access remote %q: %w", target, err))
	}

	items := make([]FileItem, 0)
	opt := &operations.ListJSONOpt{
		Recurse:    false,
		NoMimeType: false,
	}

	cleanDir := strings.Trim(dirPath, "/")

	err = operations.ListJSON(ctx, f, "", opt, func(item *operations.ListJSONItem) error {
		modTime := ""
		if !item.ModTime.When.IsZero() {
			modTime = item.ModTime.When.Format("2006-01-02T15:04:05Z07:00")
		}
		itemPath := item.Path
		if cleanDir != "" && !strings.HasPrefix(itemPath, cleanDir+"/") && itemPath != cleanDir {
			itemPath = cleanDir + "/" + item.Path
		}
		items = append(items, FileItem{
			Name:     item.Name,
			Path:     itemPath,
			IsDir:    item.IsDir,
			Size:     item.Size,
			ModTime:  modTime,
			MimeType: item.MimeType,
			ID:       item.ID,
		})
		return nil
	})

	if err != nil {
		return ResponseError(fmt.Errorf("failed to list directory %q: %w", target, err))
	}

	return ResponseSuccess(items)
}

func CopyFileInternal(srcRemote, srcPath, dstRemote, dstPath string) Response {
	ctx := context.Background()

	trimmedSrc := strings.TrimSpace(srcPath)
	isAbsSrc := strings.HasPrefix(trimmedSrc, "/")
	srcDir, srcFileName := path.Split(strings.Trim(trimmedSrc, "/"))
	if isAbsSrc {
		srcDir = "/" + srcDir
	}
	if srcFileName == "" {
		return ResponseError(fmt.Errorf("invalid srcPath: must specify a file name"))
	}

	trimmedDst := strings.TrimSpace(dstPath)
	isAbsDst := strings.HasPrefix(trimmedDst, "/")
	var dstDir, dstFileName string
	isLocalDstDir := false
	if dstRemote == "" && trimmedDst != "" {
		if fi, err := os.Stat(trimmedDst); err == nil && fi.IsDir() {
			isLocalDstDir = true
		}
	}

	if isLocalDstDir || strings.HasSuffix(trimmedDst, "/") {
		dstDir = strings.Trim(trimmedDst, "/")
		if isAbsDst && !strings.HasPrefix(dstDir, "/") {
			dstDir = "/" + dstDir
		}
		dstFileName = srcFileName
	} else {
		dir, file := path.Split(strings.Trim(trimmedDst, "/"))
		dstDir = dir
		if isAbsDst && !strings.HasPrefix(dstDir, "/") {
			dstDir = "/" + dstDir
		}
		dstFileName = file
		if dstFileName == "" {
			dstFileName = srcFileName
		}
	}

	srcTarget := makeFsTarget(srcRemote, srcDir)
	dstTarget := makeFsTarget(dstRemote, dstDir)

	fsrc, err := fs.NewFs(ctx, srcTarget)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to open source %q: %w", srcTarget, err))
	}

	fdst, err := fs.NewFs(ctx, dstTarget)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to open destination %q: %w", dstTarget, err))
	}

	err = operations.CopyFile(ctx, fdst, fsrc, dstFileName, srcFileName)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to copy file: %w", err))
	}

	return ResponseSuccess(map[string]string{
		"message": "File copied successfully",
		"src":     srcTarget + "/" + srcFileName,
		"dst":     dstTarget + "/" + dstFileName,
	})
}

func DeleteFileInternal(remote, filePath string) Response {
	ctx := context.Background()
	trimmed := strings.TrimSpace(filePath)
	isAbs := strings.HasPrefix(trimmed, "/")
	dir, fileName := path.Split(strings.Trim(trimmed, "/"))
	if isAbs {
		dir = "/" + dir
	}
	target := makeFsTarget(remote, dir)

	f, err := fs.NewFs(ctx, target)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to open remote %q: %w", target, err))
	}

	obj, err := f.NewObject(ctx, fileName)
	if err != nil {
		if err == fs.ErrorIsDir {
			pErr := operations.Purge(ctx, f, fileName)
			if pErr != nil {
				return ResponseError(fmt.Errorf("failed to purge directory %q: %w", fileName, pErr))
			}
			return ResponseSuccess(map[string]string{
				"message": "Directory deleted successfully",
			})
		}
		return ResponseError(fmt.Errorf("file not found %q: %w", fileName, err))
	}

	err = operations.DeleteFile(ctx, obj)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to delete file %q: %w", fileName, err))
	}

	return ResponseSuccess(map[string]string{
		"message": "File deleted successfully",
	})
}

func MakeDirInternal(remote, dirPath string) Response {
	ctx := context.Background()
	trimmed := strings.TrimSpace(dirPath)
	isAbs := strings.HasPrefix(trimmed, "/")
	parentDir, newDir := path.Split(strings.Trim(trimmed, "/"))
	if isAbs {
		parentDir = "/" + parentDir
	}
	target := makeFsTarget(remote, parentDir)

	f, err := fs.NewFs(ctx, target)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to open remote %q: %w", target, err))
	}

	err = operations.Mkdir(ctx, f, newDir)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to create directory %q: %w", newDir, err))
	}

	return ResponseSuccess(map[string]string{
		"message": "Directory created successfully",
		"dir":     dirPath,
	})
}

// CreatePublicLinkInternal generates or removes a public shareable link for a file or directory.
func CreatePublicLinkInternal(remote, filePath string, unlink bool) Response {
	ctx := context.Background()
	trimmedRemote := strings.TrimSpace(remote)
	trimmedPath := strings.TrimSpace(filePath)

	if trimmedRemote == "" {
		return ResponseError(fmt.Errorf("remote is required for creating a public link"))
	}

	cleanPath := strings.Trim(trimmedPath, "/")
	target := makeFsTarget(trimmedRemote, "")
	f, err := fs.NewFs(ctx, target)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to open remote %q: %w", target, err))
	}

	link, err := operations.PublicLink(ctx, f, cleanPath, fs.DurationOff, unlink)
	if err != nil {
		return ResponseError(fmt.Errorf("failed to create public link: %w", err))
	}

	return ResponseSuccess(map[string]string{
		"link": link,
	})
}

// TransferJob represents an active or past file transfer operation.
type TransferJob struct {
	ID         string             `json:"id"`
	SrcRemote  string             `json:"src_remote"`
	SrcPath    string             `json:"src_path"`
	DstRemote  string             `json:"dst_remote"`
	DstPath    string             `json:"dst_path"`
	IsMove     bool               `json:"is_move"`
	Status     string             `json:"status"` // "queued", "running", "completed", "failed", "cancelled"
	Bytes      int64              `json:"bytes"`
	TotalBytes int64              `json:"total_bytes"`
	Percentage int                `json:"percentage"`
	Speed      float64            `json:"speed"` // bytes/sec
	ETA        int64              `json:"eta"`   // seconds
	Error      string             `json:"error,omitempty"`
	StartTime  string             `json:"start_time"`
	EndTime    string             `json:"end_time,omitempty"`
	cancel     context.CancelFunc `json:"-"`
}

// TransferManager keeps track of all initiated transfers thread-safely.
type TransferManager struct {
	mu      sync.RWMutex
	jobs    map[string]*TransferJob
	jobList []string
	counter int64
}

var globalTransferManager = &TransferManager{
	jobs: make(map[string]*TransferJob),
}

func StartTransferInternal(srcRemote, srcPath, dstRemote, dstPath string, isMove bool) Response {
	trimmedSrc := strings.Trim(srcPath, "/")
	if trimmedSrc == "" {
		return ResponseError(fmt.Errorf("invalid srcPath: must specify a file path"))
	}
	_, srcFileName := path.Split(trimmedSrc)
	if srcFileName == "" {
		return ResponseError(fmt.Errorf("invalid srcPath: must specify a file name"))
	}

	jobID := fmt.Sprintf("job_%d_%d", time.Now().UnixMilli(), atomic.AddInt64(&globalTransferManager.counter, 1))
	ctx, cancel := context.WithCancel(context.Background())

	job := &TransferJob{
		ID:        jobID,
		SrcRemote: srcRemote,
		SrcPath:   srcPath,
		DstRemote: dstRemote,
		DstPath:   dstPath,
		IsMove:    isMove,
		Status:    "queued",
		StartTime: time.Now().Format(time.RFC3339),
		cancel:    cancel,
	}

	globalTransferManager.mu.Lock()
	globalTransferManager.jobs[jobID] = job
	globalTransferManager.jobList = append(globalTransferManager.jobList, jobID)
	globalTransferManager.mu.Unlock()

	go func() {
		defer func() {
			if r := recover(); r != nil {
				globalTransferManager.mu.Lock()
				job.Status = "failed"
				job.Error = fmt.Sprintf("panic: %v", r)
				job.EndTime = time.Now().Format(time.RFC3339)
				globalTransferManager.mu.Unlock()
			}
		}()

		globalTransferManager.mu.Lock()
		job.Status = "running"
		globalTransferManager.mu.Unlock()

		isAbsSrc := strings.HasPrefix(strings.TrimSpace(srcPath), "/")
		srcDir, sFileName := path.Split(strings.Trim(srcPath, "/"))
		if isAbsSrc {
			srcDir = "/" + srcDir
		}

		isAbsDst := strings.HasPrefix(strings.TrimSpace(dstPath), "/")
		var dDir, dFileName string
		trimmedDst := strings.Trim(dstPath, "/")

		isLocalDstDir := false
		if dstRemote == "" && trimmedDst != "" {
			if fi, err := os.Stat(dstPath); err == nil && fi.IsDir() {
				isLocalDstDir = true
			}
		}

		if trimmedDst == "" {
			dDir = ""
			if isAbsDst {
				dDir = "/"
			}
			dFileName = sFileName
		} else if isLocalDstDir || strings.HasSuffix(dstPath, "/") {
			dDir = trimmedDst
			if isAbsDst && !strings.HasPrefix(dDir, "/") {
				dDir = "/" + dDir
			}
			dFileName = sFileName
		} else {
			dir, file := path.Split(trimmedDst)
			dDir = dir
			if isAbsDst && !strings.HasPrefix(dDir, "/") {
				dDir = "/" + dDir
			}
			dFileName = file
			if dFileName == "" {
				dFileName = sFileName
			}
		}

		srcTarget := makeFsTarget(srcRemote, srcDir)
		dstTarget := makeFsTarget(dstRemote, dDir)

		jobCtx := accounting.WithStatsGroup(ctx, jobID)

		fsrc, err := fs.NewFs(jobCtx, srcTarget)
		if err != nil {
			globalTransferManager.mu.Lock()
			job.Status = "failed"
			job.Error = fmt.Sprintf("failed to open source %q: %v", srcTarget, err)
			job.EndTime = time.Now().Format(time.RFC3339)
			globalTransferManager.mu.Unlock()
			return
		}

		fdst, err := fs.NewFs(jobCtx, dstTarget)
		if err != nil {
			globalTransferManager.mu.Lock()
			job.Status = "failed"
			job.Error = fmt.Sprintf("failed to open destination %q: %v", dstTarget, err)
			job.EndTime = time.Now().Format(time.RFC3339)
			globalTransferManager.mu.Unlock()
			return
		}

		srcObj, err := fsrc.NewObject(jobCtx, sFileName)
		if err == nil && srcObj != nil {
			globalTransferManager.mu.Lock()
			job.TotalBytes = srcObj.Size()
			globalTransferManager.mu.Unlock()
		}

		var opErr error
		if isMove {
			opErr = operations.MoveFile(jobCtx, fdst, fsrc, dFileName, sFileName)
		} else {
			opErr = operations.CopyFile(jobCtx, fdst, fsrc, dFileName, sFileName)
		}

		globalTransferManager.mu.Lock()
		defer globalTransferManager.mu.Unlock()
		job.EndTime = time.Now().Format(time.RFC3339)

		if opErr != nil {
			if jobCtx.Err() == context.Canceled {
				job.Status = "cancelled"
				job.Error = "Transfer cancelled by user"
			} else {
				job.Status = "failed"
				job.Error = opErr.Error()
			}
		} else {
			job.Status = "completed"
			if job.TotalBytes > 0 {
				job.Bytes = job.TotalBytes
			}
			job.Percentage = 100
		}
	}()

	return ResponseSuccess(job)
}

func StartSyncInternal(srcRemote, srcPath, dstRemote, dstPath, syncMode string) Response {
	jobID := fmt.Sprintf("sync_%d_%d", time.Now().UnixMilli(), atomic.AddInt64(&globalTransferManager.counter, 1))
	ctx, cancel := context.WithCancel(context.Background())

	normalizedMode := strings.ToLower(strings.TrimSpace(syncMode))
	if normalizedMode != "copy" && normalizedMode != "sync" {
		normalizedMode = "sync"
	}

	job := &TransferJob{
		ID:        jobID,
		SrcRemote: srcRemote,
		SrcPath:   srcPath,
		DstRemote: dstRemote,
		DstPath:   dstPath,
		IsMove:    false,
		Status:    "queued",
		StartTime: time.Now().Format(time.RFC3339),
		cancel:    cancel,
	}

	globalTransferManager.mu.Lock()
	globalTransferManager.jobs[jobID] = job
	globalTransferManager.jobList = append(globalTransferManager.jobList, jobID)
	globalTransferManager.mu.Unlock()

	go func() {
		defer func() {
			if r := recover(); r != nil {
				globalTransferManager.mu.Lock()
				job.Status = "failed"
				job.Error = fmt.Sprintf("panic: %v", r)
				job.EndTime = time.Now().Format(time.RFC3339)
				globalTransferManager.mu.Unlock()
			}
		}()

		globalTransferManager.mu.Lock()
		job.Status = "running"
		globalTransferManager.mu.Unlock()

		srcTarget := makeFsTarget(srcRemote, srcPath)
		dstTarget := makeFsTarget(dstRemote, dstPath)

		jobCtx := accounting.WithStatsGroup(ctx, jobID)

		fsrc, err := fs.NewFs(jobCtx, srcTarget)
		if err != nil {
			globalTransferManager.mu.Lock()
			job.Status = "failed"
			job.Error = fmt.Sprintf("failed to open source directory %q: %v", srcTarget, err)
			job.EndTime = time.Now().Format(time.RFC3339)
			globalTransferManager.mu.Unlock()
			return
		}

		fdst, err := fs.NewFs(jobCtx, dstTarget)
		if err != nil {
			globalTransferManager.mu.Lock()
			job.Status = "failed"
			job.Error = fmt.Sprintf("failed to open destination directory %q: %v", dstTarget, err)
			job.EndTime = time.Now().Format(time.RFC3339)
			globalTransferManager.mu.Unlock()
			return
		}

		var opErr error
		if normalizedMode == "copy" {
			opErr = rclonesync.CopyDir(jobCtx, fdst, fsrc, false)
		} else {
			opErr = rclonesync.Sync(jobCtx, fdst, fsrc, false)
		}

		globalTransferManager.mu.Lock()
		defer globalTransferManager.mu.Unlock()
		job.EndTime = time.Now().Format(time.RFC3339)

		if opErr != nil {
			if jobCtx.Err() == context.Canceled {
				job.Status = "cancelled"
				job.Error = "Sync cancelled by user"
			} else {
				job.Status = "failed"
				job.Error = opErr.Error()
			}
		} else {
			job.Status = "completed"
			if job.TotalBytes > 0 {
				job.Bytes = job.TotalBytes
			}
			job.Percentage = 100
		}
	}()

	return ResponseSuccess(job)
}

func GetTransferProgressInternal(jobId string) Response {
	targetID := strings.TrimSpace(jobId)

	globalTransferManager.mu.RLock()
	defer globalTransferManager.mu.RUnlock()

	refreshJobStats := func(j *TransferJob) {
		if j.Status == "running" {
			stats := accounting.StatsGroup(context.Background(), j.ID)
			if stats != nil {
				rcStats, err := stats.RemoteStats(false)
				if err == nil && rcStats != nil {
					if b, ok := rcStats["bytes"].(int64); ok && b > j.Bytes {
						j.Bytes = b
					}
					if tb, ok := rcStats["totalBytes"].(int64); ok && tb > 0 {
						j.TotalBytes = tb
					}
					if sp, ok := rcStats["speed"].(float64); ok {
						j.Speed = sp
					}
					if eta, ok := rcStats["eta"].(int64); ok {
						j.ETA = eta
					}
					if j.TotalBytes > 0 {
						j.Percentage = int((j.Bytes * 100) / j.TotalBytes)
						if j.Percentage > 100 {
							j.Percentage = 100
						}
					}
				}
			}
		}
	}

	if targetID != "" {
		job, ok := globalTransferManager.jobs[targetID]
		if !ok {
			return ResponseError(fmt.Errorf("job %q not found", targetID))
		}
		refreshJobStats(job)
		return ResponseSuccess(job)
	}

	list := make([]*TransferJob, 0, len(globalTransferManager.jobList))
	for _, id := range globalTransferManager.jobList {
		if j, ok := globalTransferManager.jobs[id]; ok {
			refreshJobStats(j)
			list = append(list, j)
		}
	}
	return ResponseSuccess(list)
}

func CancelTransferInternal(jobId string) Response {
	id := strings.TrimSpace(jobId)
	if id == "" {
		return ResponseError(fmt.Errorf("jobId must not be empty"))
	}

	globalTransferManager.mu.Lock()
	defer globalTransferManager.mu.Unlock()

	job, ok := globalTransferManager.jobs[id]
	if !ok {
		return ResponseError(fmt.Errorf("job %q not found", id))
	}

	if job.Status == "running" || job.Status == "queued" {
		if job.cancel != nil {
			job.cancel()
		}
		job.Status = "cancelled"
		job.Error = "Transfer cancelled by user"
		job.EndTime = time.Now().Format(time.RFC3339)
	}

	return ResponseSuccess(map[string]interface{}{
		"id":      id,
		"status":  job.Status,
		"message": "Transfer cancelled successfully",
	})
}

func ClearCompletedTransfersInternal() Response {
	globalTransferManager.mu.Lock()
	defer globalTransferManager.mu.Unlock()

	remainingList := make([]string, 0)
	for _, id := range globalTransferManager.jobList {
		job, ok := globalTransferManager.jobs[id]
		if ok && (job.Status == "running" || job.Status == "queued") {
			remainingList = append(remainingList, id)
		} else {
			delete(globalTransferManager.jobs, id)
		}
	}
	globalTransferManager.jobList = remainingList

	return ResponseSuccess(map[string]interface{}{
		"message":      "Completed transfers cleared",
		"active_count": len(remainingList),
	})
}

// --- CGO Exported Interface ---

//export FreeString
func FreeString(str *C.char) {
	if str != nil {
		C.free(unsafe.Pointer(str))
	}
}

//export InitRclone
func InitRclone(configPath *C.char) *C.char {
	cfg := ""
	if configPath != nil {
		cfg = C.GoString(configPath)
	}
	return cResponse(InitRcloneInternal(cfg))
}

//export LoadConfigInMemory
func LoadConfigInMemory(configContent *C.char) *C.char {
	content := ""
	if configContent != nil {
		content = C.GoString(configContent)
	}
	return cResponse(LoadConfigInMemoryInternal(content))
}

//export ExportConfigInMemory
func ExportConfigInMemory() *C.char {
	return cResponse(ExportConfigInMemoryInternal())
}

//export SetRemoteConfig
func SetRemoteConfig(remoteName *C.char, remoteType *C.char, optionsJson *C.char) *C.char {
	if remoteName == nil || remoteType == nil {
		return cResponse(ResponseError(fmt.Errorf("remoteName and remoteType cannot be null")))
	}
	rName := C.GoString(remoteName)
	rType := C.GoString(remoteType)
	oJson := ""
	if optionsJson != nil {
		oJson = C.GoString(optionsJson)
	}
	return cResponse(SetRemoteConfigInternal(rName, rType, oJson))
}

//export DeleteRemote
func DeleteRemote(remoteName *C.char) *C.char {
	if remoteName == nil {
		return cResponse(ResponseError(fmt.Errorf("remoteName cannot be null")))
	}
	return cResponse(DeleteRemoteInternal(C.GoString(remoteName)))
}

//export ListRemotes
func ListRemotes() *C.char {
	return cResponse(ListRemotesInternal())
}

//export GetRemoteAbout
func GetRemoteAbout(remote *C.char) *C.char {
	rem := ""
	if remote != nil {
		rem = C.GoString(remote)
	}
	return cResponse(GetRemoteAboutInternal(rem))
}


//export ListDirectory
func ListDirectory(remote *C.char, dirPath *C.char) *C.char {
	rem := ""
	if remote != nil {
		rem = C.GoString(remote)
	}
	dp := ""
	if dirPath != nil {
		dp = C.GoString(dirPath)
	}
	return cResponse(ListDirectoryInternal(rem, dp))
}

//export CopyFile
func CopyFile(srcRemote *C.char, srcPath *C.char, dstRemote *C.char, dstPath *C.char) *C.char {
	sRem := ""
	if srcRemote != nil {
		sRem = C.GoString(srcRemote)
	}
	sPath := ""
	if srcPath != nil {
		sPath = C.GoString(srcPath)
	}
	dRem := ""
	if dstRemote != nil {
		dRem = C.GoString(dstRemote)
	}
	dPath := ""
	if dstPath != nil {
		dPath = C.GoString(dstPath)
	}
	return cResponse(CopyFileInternal(sRem, sPath, dRem, dPath))
}

//export DeleteFile
func DeleteFile(remote *C.char, filePath *C.char) *C.char {
	rem := ""
	if remote != nil {
		rem = C.GoString(remote)
	}
	fp := ""
	if filePath != nil {
		fp = C.GoString(filePath)
	}
	return cResponse(DeleteFileInternal(rem, fp))
}

//export MakeDir
func MakeDir(remote *C.char, dirPath *C.char) *C.char {
	rem := ""
	if remote != nil {
		rem = C.GoString(remote)
	}
	dp := ""
	if dirPath != nil {
		dp = C.GoString(dirPath)
	}
	return cResponse(MakeDirInternal(rem, dp))
}

//export StartTransfer
func StartTransfer(srcRemote *C.char, srcPath *C.char, dstRemote *C.char, dstPath *C.char, isMove C.int) *C.char {
	sRem := ""
	if srcRemote != nil {
		sRem = C.GoString(srcRemote)
	}
	sPath := ""
	if srcPath != nil {
		sPath = C.GoString(srcPath)
	}
	dRem := ""
	if dstRemote != nil {
		dRem = C.GoString(dstRemote)
	}
	dPath := ""
	if dstPath != nil {
		dPath = C.GoString(dstPath)
	}
	return cResponse(StartTransferInternal(sRem, sPath, dRem, dPath, isMove != 0))
}

//export GetTransferProgress
func GetTransferProgress(jobId *C.char) *C.char {
	targetID := ""
	if jobId != nil {
		targetID = C.GoString(jobId)
	}
	return cResponse(GetTransferProgressInternal(targetID))
}

//export CancelTransfer
func CancelTransfer(jobId *C.char) *C.char {
	if jobId == nil {
		return cResponse(ResponseError(fmt.Errorf("jobId must not be null")))
	}
	return cResponse(CancelTransferInternal(C.GoString(jobId)))
}

//export ClearCompletedTransfers
func ClearCompletedTransfers() *C.char {
	return cResponse(ClearCompletedTransfersInternal())
}

//export CreatePublicLink
func CreatePublicLink(remote *C.char, filePath *C.char, unlink C.int) *C.char {
	rem := ""
	if remote != nil {
		rem = C.GoString(remote)
	}
	fp := ""
	if filePath != nil {
		fp = C.GoString(filePath)
	}
	isUnlink := (unlink != 0)
	return cResponse(CreatePublicLinkInternal(rem, fp, isUnlink))
}

//export StartSync
func StartSync(srcRemote *C.char, srcPath *C.char, dstRemote *C.char, dstPath *C.char, syncMode *C.char) *C.char {
	sRem := ""
	if srcRemote != nil {
		sRem = C.GoString(srcRemote)
	}
	sPath := ""
	if srcPath != nil {
		sPath = C.GoString(srcPath)
	}
	dRem := ""
	if dstRemote != nil {
		dRem = C.GoString(dstRemote)
	}
	dPath := ""
	if dstPath != nil {
		dPath = C.GoString(dstPath)
	}
	mode := "sync"
	if syncMode != nil {
		mode = C.GoString(syncMode)
	}
	return cResponse(StartSyncInternal(sRem, sPath, dRem, dPath, mode))
}

func main() {}

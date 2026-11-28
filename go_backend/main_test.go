package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestMemoryStorage_BasicOps(t *testing.T) {
	mem := newMemoryStorage()

	// Initially empty
	if len(mem.GetSectionList()) != 0 {
		t.Errorf("Expected 0 sections, got %d", len(mem.GetSectionList()))
	}
	if mem.HasSection("drive") {
		t.Error("Expected HasSection('drive') to be false")
	}

	// Set values
	mem.SetValue("drive", "type", "drive")
	mem.SetValue("drive", "client_id", "my-client-id")
	mem.SetValue("dropbox", "type", "dropbox")

	if !mem.HasSection("drive") {
		t.Error("Expected HasSection('drive') to be true")
	}
	if len(mem.GetSectionList()) != 2 {
		t.Errorf("Expected 2 sections, got %d", len(mem.GetSectionList()))
	}

	// Get value
	val, ok := mem.GetValue("drive", "client_id")
	if !ok || val != "my-client-id" {
		t.Errorf("Expected 'my-client-id', got %q (ok=%v)", val, ok)
	}

	// Non-existent key
	_, ok = mem.GetValue("drive", "non_existent")
	if ok {
		t.Error("Expected non-existent key to return ok=false")
	}

	// Key list
	keys := mem.GetKeyList("drive")
	if len(keys) != 2 {
		t.Errorf("Expected 2 keys in 'drive', got %d", len(keys))
	}

	// Delete key
	if !mem.DeleteKey("drive", "client_id") {
		t.Error("Expected DeleteKey to return true")
	}
	if mem.DeleteKey("drive", "client_id") {
		t.Error("Expected second DeleteKey to return false")
	}

	// Delete section
	mem.DeleteSection("drive")
	if mem.HasSection("drive") {
		t.Error("Expected HasSection('drive') to be false after DeleteSection")
	}
}

func TestMemoryStorage_SerializeAndLoadIni(t *testing.T) {
	mem := newMemoryStorage()
	mem.SetValue("myremote", "type", "s3")
	mem.SetValue("myremote", "endpoint", "https://s3.example.com")
	mem.SetValue("myremote", "access_key", "ACCESS123")

	serialized, err := mem.Serialize()
	if err != nil {
		t.Fatalf("Serialize failed: %v", err)
	}

	if !strings.Contains(serialized, "[myremote]") {
		t.Error("Expected serialized INI to contain '[myremote]'")
	}
	if !strings.Contains(serialized, "type = s3") {
		t.Error("Expected serialized INI to contain 'type = s3'")
	}

	// Load into a new MemoryStorage
	mem2 := newMemoryStorage()
	iniInput := `
# Comment line
; Another comment
[gdrive]
type = drive
client_id = test-id

[sftp_remote]
type = sftp
host = ssh.example.com
`
	if err := mem2.LoadFromIni(iniInput); err != nil {
		t.Fatalf("LoadFromIni failed: %v", err)
	}

	if !mem2.HasSection("gdrive") || !mem2.HasSection("sftp_remote") {
		t.Error("Expected both sections to be loaded")
	}
	val, ok := mem2.GetValue("sftp_remote", "host")
	if !ok || val != "ssh.example.com" {
		t.Errorf("Expected ssh.example.com, got %q", val)
	}
}

func TestMakeFsTarget(t *testing.T) {
	tests := []struct {
		remote   string
		path     string
		expected string
	}{
		{"", "", "."},
		{"", "folder/sub", "folder/sub"},
		{"", "/absolute/path", "/absolute/path"},
		{"mydrive", "", "mydrive:"},
		{"mydrive", "folder", "mydrive:folder"},
		{"mydrive:", "folder/sub", "mydrive:folder/sub"},
		{"sftp:sub", "file.txt", "sftp:sub/file.txt"},
	}

	for _, tt := range tests {
		got := makeFsTarget(tt.remote, tt.path)
		if got != tt.expected {
			t.Errorf("makeFsTarget(%q, %q) = %q; want %q", tt.remote, tt.path, got, tt.expected)
		}
	}
}

func TestInitRcloneInternal(t *testing.T) {
	// Test memory mode (empty argument)
	resp := InitRcloneInternal("")
	if !resp.Success {
		t.Fatalf("InitRcloneInternal('') failed: %s", resp.Error)
	}
	data, ok := resp.Data.(map[string]string)
	if !ok {
		t.Fatalf("Expected map[string]string data, got %T", resp.Data)
	}
	if data["mode"] != "memory" {
		t.Errorf("Expected mode 'memory', got %v", data["mode"])
	}

	// Test custom file path
	tmpDir := t.TempDir()
	confPath := filepath.Join(tmpDir, "test_rclone.conf")

	resp2 := InitRcloneInternal(confPath)
	if !resp2.Success {
		t.Fatalf("InitRcloneInternal(confPath) failed: %s", resp2.Error)
	}
	data2 := resp2.Data.(map[string]string)
	if data2["mode"] != "file" {
		t.Errorf("Expected mode 'file', got %v", data2["mode"])
	}

	// Reset back to memory mode
	InitRcloneInternal("")
}

func TestConfigManagementInternal(t *testing.T) {
	InitRcloneInternal("")

	// Set remote config
	resp := SetRemoteConfigInternal("test_dropbox", "dropbox", `{"token":"secret_token_123"}`)
	if !resp.Success {
		t.Fatalf("SetRemoteConfigInternal failed: %s", resp.Error)
	}

	// List remotes
	listResp := ListRemotesInternal()
	if !listResp.Success {
		t.Fatalf("ListRemotesInternal failed: %s", listResp.Error)
	}
	remotes, ok := listResp.Data.([]RemoteInfo)
	if !ok {
		t.Fatalf("Expected slice of RemoteInfo, got %T", listResp.Data)
	}
	found := false
	for _, r := range remotes {
		if r.Name == "test_dropbox" {
			found = true
			break
		}
	}
	if !found {
		t.Error("Expected test_dropbox to be listed in remotes")
	}

	// Export config in memory
	exportResp := ExportConfigInMemoryInternal()
	if !exportResp.Success {
		t.Fatalf("ExportConfigInMemoryInternal failed: %s", exportResp.Error)
	}
	iniStr := exportResp.Data.(string)
	if !strings.Contains(iniStr, "[test_dropbox]") {
		t.Errorf("Exported INI missing [test_dropbox]: %s", iniStr)
	}

	// Delete remote
	delResp := DeleteRemoteInternal("test_dropbox")
	if !delResp.Success {
		t.Fatalf("DeleteRemoteInternal failed: %s", delResp.Error)
	}
}

func TestLocalCRUDOperationsInternal(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	newDir := filepath.Join(tmpDir, "new_folder")

	// 1. MakeDir
	mkResp := MakeDirInternal("", newDir)
	if !mkResp.Success {
		t.Fatalf("MakeDirInternal failed: %s", mkResp.Error)
	}

	// 2. Create a test file
	srcFile := filepath.Join(tmpDir, "sample.txt")
	if err := os.WriteFile(srcFile, []byte("Hello UnifyCloud!"), 0644); err != nil {
		t.Fatalf("Failed to create sample file: %v", err)
	}

	// 3. ListDirectory
	listResp := ListDirectoryInternal("", tmpDir)
	if !listResp.Success {
		t.Fatalf("ListDirectoryInternal failed: %s", listResp.Error)
	}
	items := listResp.Data.([]FileItem)
	if len(items) < 2 {
		t.Errorf("Expected at least 2 items in directory, got %d", len(items))
	}

	// 4. CopyFile
	dstFile := filepath.Join(tmpDir, "new_folder", "copied.txt")
	copyResp := CopyFileInternal("", srcFile, "", dstFile)
	if !copyResp.Success {
		t.Fatalf("CopyFileInternal failed: %s", copyResp.Error)
	}

	if _, err := os.Stat(dstFile); os.IsNotExist(err) {
		t.Errorf("Copied file does not exist at %s", dstFile)
	}

	// 5. DeleteFile
	delResp := DeleteFileInternal("", dstFile)
	if !delResp.Success {
		t.Fatalf("DeleteFileInternal failed: %s", delResp.Error)
	}
}

func TestTransferManagerInternal_Lifecycle(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	srcPath := filepath.Join(tmpDir, "transfer_src.bin")
	dstPath := filepath.Join(tmpDir, "transfer_dst.bin")
	payload := make([]byte, 1024*100) // 100 KB
	if err := os.WriteFile(srcPath, payload, 0644); err != nil {
		t.Fatalf("Failed to create transfer src: %v", err)
	}

	// StartTransfer
	startResp := StartTransferInternal("", srcPath, "", dstPath, false)
	if !startResp.Success {
		t.Fatalf("StartTransferInternal failed: %s", startResp.Error)
	}
	job, ok := startResp.Data.(*TransferJob)
	if !ok || job.ID == "" {
		t.Fatalf("Expected valid job pointer, got %v", startResp.Data)
	}

	// Poll progress
	time.Sleep(100 * time.Millisecond)

	progResp := GetTransferProgressInternal(job.ID)
	if !progResp.Success {
		t.Fatalf("GetTransferProgressInternal failed: %s", progResp.Error)
	}

	// Get all transfers
	allResp := GetTransferProgressInternal("")
	if !allResp.Success {
		t.Fatalf("GetAllTransfers failed: %s", allResp.Error)
	}

	// Cancel transfer
	_ = CancelTransferInternal(job.ID)

	// Clear completed
	clearResp := ClearCompletedTransfersInternal()
	if !clearResp.Success {
		t.Fatalf("ClearCompletedTransfersInternal failed: %s", clearResp.Error)
	}
}

func TestErrorHandlingInternal(t *testing.T) {
	InitRcloneInternal("")

	// SetRemoteConfig with empty args
	resp := SetRemoteConfigInternal("", "", "")
	if resp.Success {
		t.Error("Expected SetRemoteConfigInternal('', '', '') to fail")
	}

	// DeleteRemote with empty arg
	resp = DeleteRemoteInternal("")
	if resp.Success {
		t.Error("Expected DeleteRemoteInternal('') to fail")
	}

	// CancelTransfer with empty arg
	resp = CancelTransferInternal("")
	if resp.Success {
		t.Error("Expected CancelTransferInternal('') to fail")
	}

	// ListDirectory on non-existent remote target
	resp = ListDirectoryInternal("non_existent_remote", "")
	if resp.Success {
		t.Error("Expected ListDirectory on non-existent remote to fail")
	}

	// CopyFile with empty path
	resp = CopyFileInternal("", "", "", "")
	if resp.Success {
		t.Error("Expected CopyFile with empty paths to fail")
	}
}

func TestCreatePublicLinkInternal(t *testing.T) {
	// 1. Empty remote should fail
	resp := CreatePublicLinkInternal("", "file.txt", false)
	if resp.Success {
		t.Error("Expected CreatePublicLink with empty remote to fail")
	}

	// 2. Non-existent remote should fail
	resp = CreatePublicLinkInternal("invalid_fake_remote_123", "file.txt", false)
	if resp.Success {
		t.Error("Expected CreatePublicLink with non-existent remote to fail")
	}

	// 3. Local remote does not support public links
	tmpDir, err := os.MkdirTemp("", "unify_link_test_*")
	if err != nil {
		t.Fatalf("Failed to create temp dir: %v", err)
	}
	defer os.RemoveAll(tmpDir)

	testFile := filepath.Join(tmpDir, "sample.txt")
	_ = os.WriteFile(testFile, []byte("sample"), 0644)

	resp = CreatePublicLinkInternal("local", testFile, false)
	if resp.Success {
		t.Error("Expected CreatePublicLink on local remote to fail as unsupported")
	}
}

func TestStartSyncInternal_LocalToLocal(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	srcDir := filepath.Join(tmpDir, "sync_src")
	dstDir := filepath.Join(tmpDir, "sync_dst")
	_ = os.MkdirAll(srcDir, 0755)
	_ = os.MkdirAll(dstDir, 0755)

	file1 := filepath.Join(srcDir, "doc1.txt")
	file2 := filepath.Join(srcDir, "photo.jpg")
	_ = os.WriteFile(file1, []byte("Content of document 1"), 0644)
	_ = os.WriteFile(file2, []byte("Binary photo data"), 0644)

	// Test 1: StartSyncInternal with "copy" mode (backup)
	copyResp := StartSyncInternal("", srcDir, "", dstDir, "copy")
	if !copyResp.Success {
		t.Fatalf("StartSyncInternal (copy) failed: %s", copyResp.Error)
	}
	job, ok := copyResp.Data.(*TransferJob)
	if !ok || job.ID == "" {
		t.Fatalf("Expected valid sync job, got %v", copyResp.Data)
	}

	dstFile1 := filepath.Join(dstDir, "doc1.txt")
	dstFile2 := filepath.Join(dstDir, "photo.jpg")
	for i := 0; i < 30; i++ {
		time.Sleep(100 * time.Millisecond)
		if _, err := os.Stat(dstFile1); err == nil {
			if _, err2 := os.Stat(dstFile2); err2 == nil {
				break
			}
		}
	}

	if _, err := os.Stat(dstFile1); err != nil {
		t.Errorf("Expected %s to exist after copy sync", dstFile1)
	}
	if _, err := os.Stat(dstFile2); err != nil {
		t.Errorf("Expected %s to exist after copy sync", dstFile2)
	}

	// Test 2: StartSyncInternal with "sync" (mirror) mode
	extraFile := filepath.Join(dstDir, "extra_to_delete.txt")
	_ = os.WriteFile(extraFile, []byte("This should be deleted by mirror sync"), 0644)

	syncResp := StartSyncInternal("", srcDir, "", dstDir, "sync")
	if !syncResp.Success {
		t.Fatalf("StartSyncInternal (sync) failed: %s", syncResp.Error)
	}

	for i := 0; i < 30; i++ {
		time.Sleep(100 * time.Millisecond)
		if _, err := os.Stat(extraFile); os.IsNotExist(err) {
			break
		}
	}

	if _, err := os.Stat(extraFile); !os.IsNotExist(err) {
		t.Errorf("Expected %s to be deleted by mirror sync", extraFile)
	}
}

func TestListDirectoryInternal_Symlinks(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	realSubDir := filepath.Join(tmpDir, "real_dir")
	_ = os.MkdirAll(realSubDir, 0755)
	realFile := filepath.Join(realSubDir, "hello.txt")
	_ = os.WriteFile(realFile, []byte("world"), 0644)

	symlinkDir := filepath.Join(tmpDir, "symlink_dir")
	if err := os.Symlink(realSubDir, symlinkDir); err != nil {
		t.Skipf("Skipping symlink test: symlinks not supported on this platform/filesystem: %v", err)
	}

	symlinkFile := filepath.Join(tmpDir, "symlink_file.txt")
	if err := os.Symlink(realFile, symlinkFile); err != nil {
		t.Skipf("Skipping symlink test: symlinks not supported on this platform/filesystem: %v", err)
	}

	// Test listing tmpDir via local path
	resp := ListDirectoryInternal("", tmpDir)
	if !resp.Success {
		t.Fatalf("ListDirectoryInternal failed: %s", resp.Error)
	}

	items, ok := resp.Data.([]FileItem)
	if !ok {
		t.Fatalf("Expected []FileItem, got %T", resp.Data)
	}

	foundSymlinkDir := false
	foundSymlinkFile := false
	for _, it := range items {
		if it.Name == "symlink_dir" {
			foundSymlinkDir = true
			if !it.IsDir {
				t.Errorf("Expected symlink_dir to be reported as IsDir=true, got false")
			}
		}
		if it.Name == "symlink_file.txt" {
			foundSymlinkFile = true
			if it.IsDir {
				t.Errorf("Expected symlink_file.txt to be reported as IsDir=false, got true")
			}
		}
	}

	if !foundSymlinkDir {
		t.Errorf("symlink_dir was not found in directory listing (was it skipped due to lack of copy_links?)")
	}
	if !foundSymlinkFile {
		t.Errorf("symlink_file.txt was not found in directory listing")
	}
}

func TestListDirectoryInternal_DanglingSymlink(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	// Create a dangling symlink (pointing to a nonexistent target, like ~/.steampath)
	brokenSymlink := filepath.Join(tmpDir, ".steampath")
	if err := os.Symlink("/nonexistent/target/path", brokenSymlink); err != nil {
		t.Skipf("Skipping symlink test: %v", err)
	}

	resp := ListDirectoryInternal("", tmpDir)
	if !resp.Success {
		t.Fatalf("ListDirectoryInternal failed on directory with dangling symlink: %s", resp.Error)
	}
}

func TestCryptBackend(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	// 1. Configure local backend pointing to tmpDir
	respLocal := SetRemoteConfigInternal("test_local", "local", "{}")
	if !respLocal.Success {
		t.Fatalf("Failed to configure test_local: %s", respLocal.Error)
	}

	// 2. Configure crypt backend wrapping test_local:vault
	vaultSubdir := filepath.Join(tmpDir, "vault")
	cryptOpts := map[string]string{
		"remote":                    "test_local:" + vaultSubdir,
		"password":                  "mySuperSecretPassword123",
		"filename_encryption":       "standard",
		"directory_name_encryption": "true",
	}
	optsBytes, _ := json.Marshal(cryptOpts)
	respCrypt := SetRemoteConfigInternal("test_crypt", "crypt", string(optsBytes))
	if !respCrypt.Success {
		t.Fatalf("Failed to configure test_crypt: %s", respCrypt.Error)
	}

	// 3. Verify ListRemotesInternal contains test_crypt with correct remote
	remotesResp := ListRemotesInternal()
	if !remotesResp.Success {
		t.Fatalf("ListRemotesInternal failed: %s", remotesResp.Error)
	}
	remotesList, ok := remotesResp.Data.([]RemoteInfo)
	if !ok {
		t.Fatalf("Expected []RemoteInfo, got %T", remotesResp.Data)
	}
	foundCrypt := false
	for _, r := range remotesList {
		if r.Name == "test_crypt" {
			foundCrypt = true
			if r.Type != "crypt" {
				t.Errorf("Expected type 'crypt', got %q", r.Type)
			}
			if !strings.Contains(r.Remote, "test_local:") {
				t.Errorf("Expected remote to contain 'test_local:', got %q", r.Remote)
			}
		}
	}
	if !foundCrypt {
		t.Fatalf("test_crypt not found in ListRemotes")
	}

	// 4. Create a test file and upload it to test_crypt
	plainContent := "SuperSecretConfidentialData-UnifyCloud-2026"
	srcFile := filepath.Join(tmpDir, "original.txt")
	if err := os.WriteFile(srcFile, []byte(plainContent), 0644); err != nil {
		t.Fatalf("Failed to create src file: %v", err)
	}

	uploadResp := CopyFileInternal("", srcFile, "test_crypt", "secret_report.txt")
	if !uploadResp.Success {
		t.Fatalf("Upload to test_crypt failed: %s", uploadResp.Error)
	}

	// 5. List directory through test_crypt -> should see decrypted "secret_report.txt"
	listResp := ListDirectoryInternal("test_crypt", "")
	if !listResp.Success {
		t.Fatalf("ListDirectory on test_crypt failed: %s", listResp.Error)
	}
	items, ok := listResp.Data.([]FileItem)
	if !ok {
		t.Fatalf("Expected []FileItem, got %T", listResp.Data)
	}
	foundDecrypted := false
	for _, it := range items {
		if it.Name == "secret_report.txt" {
			foundDecrypted = true
			break
		}
	}
	if !foundDecrypted {
		t.Errorf("secret_report.txt not found in test_crypt directory listing")
	}

	// 6. Verify that raw storage in vaultSubdir is encrypted (ciphertext, no plaintext)
	rawEntries, err := os.ReadDir(vaultSubdir)
	if err != nil {
		t.Fatalf("Failed to read raw vault dir: %v", err)
	}
	if len(rawEntries) == 0 {
		t.Fatalf("Expected encrypted file in raw vault dir, found 0 items")
	}
	for _, entry := range rawEntries {
		if entry.Name() == "secret_report.txt" {
			t.Errorf("Filename was NOT encrypted on disk!")
		}
		rawBytes, err := os.ReadFile(filepath.Join(vaultSubdir, entry.Name()))
		if err == nil {
			if strings.Contains(string(rawBytes), plainContent) {
				t.Errorf("Plaintext was found unencrypted inside ciphertext file!")
			}
		}
	}

	// 7. Download file from test_crypt and verify decrypted content matches exactly
	downloadDest := filepath.Join(tmpDir, "downloaded.txt")
	downResp := CopyFileInternal("test_crypt", "secret_report.txt", "", downloadDest)
	if !downResp.Success {
		t.Fatalf("Download from test_crypt failed: %s", downResp.Error)
	}
	readBytes, err := os.ReadFile(downloadDest)
	if err != nil {
		t.Fatalf("Failed to read downloaded file: %v", err)
	}
	if string(readBytes) != plainContent {
		t.Errorf("Downloaded decrypted content mismatch: expected %q, got %q", plainContent, string(readBytes))
	}
}

func TestSecurity_IniInjectionAndPasswordObscure(t *testing.T) {
	InitRcloneInternal("")

	// 1. Reject invalid remote names (INI section injection)
	badNames := []string{
		"bad]name",
		"bad[name",
		"bad\n[evil]\ntype=local",
		"bad:name",
		"bad name",
	}
	for _, name := range badNames {
		resp := SetRemoteConfigInternal(name, "s3", `{}`)
		if resp.Success {
			t.Errorf("Expected SetRemoteConfigInternal to reject remote name %q", name)
		}
	}

	// 2. Reject newline injection in option values
	resp := SetRemoteConfigInternal("valid_s3", "s3", `{"endpoint":"https://example.com\n[injected]\ntype = local"}`)
	if resp.Success {
		t.Error("Expected SetRemoteConfigInternal to reject newline in option value")
	}

	// 3. Obscure password for webdav and sftp
	respWebdav := SetRemoteConfigInternal("my_webdav", "webdav", `{"url":"https://cloud.example.com","user":"alice","pass":"SuperPlainPass"}`)
	if !respWebdav.Success {
		t.Fatalf("SetRemoteConfigInternal webdav failed: %s", respWebdav.Error)
	}
	exported := ExportConfigInMemoryInternal()
	if !exported.Success {
		t.Fatalf("ExportConfigInMemoryInternal failed: %s", exported.Error)
	}
	if strings.Contains(exported.Data.(string), "SuperPlainPass") {
		t.Error("Expected webdav pass to be obscured in exported INI, found plaintext")
	}
}

func waitForSearchCompletion(t *testing.T, jobID string) SearchJobSnapshot {
	t.Helper()
	deadline := time.Now().Add(10 * time.Second)
	for time.Now().Before(deadline) {
		resp := GetSearchStatusInternal(jobID)
		if !resp.Success {
			t.Fatalf("GetSearchStatusInternal(%s) failed: %s", jobID, resp.Error)
		}
		snap, ok := resp.Data.(SearchJobSnapshot)
		if !ok {
			t.Fatalf("Expected SearchJobSnapshot, got %T", resp.Data)
		}
		if snap.Status != "running" {
			return snap
		}
		time.Sleep(20 * time.Millisecond)
	}
	t.Fatalf("Search job %s timed out waiting for completion", jobID)
	return SearchJobSnapshot{}
}

func TestGlobalSearchInternal_FiltersAndDepth(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	// Create directory tree:
	// root:
	//   top_report.pdf (200 bytes)
	//   notes.txt (10 bytes)
	//   level1/
	//     sub_report.PDF (500 bytes)
	//     photo.png (300 bytes)
	//     level2/
	//       deep_report.pdf (1000 bytes)
	//       level3/
	//         abyss_report.pdf (50 bytes)
	_ = os.MkdirAll(filepath.Join(tmpDir, "level1", "level2", "level3"), 0755)
	_ = os.WriteFile(filepath.Join(tmpDir, "top_report.pdf"), make([]byte, 200), 0644)
	_ = os.WriteFile(filepath.Join(tmpDir, "notes.txt"), make([]byte, 10), 0644)
	_ = os.WriteFile(filepath.Join(tmpDir, "level1", "sub_report.PDF"), make([]byte, 500), 0644)
	_ = os.WriteFile(filepath.Join(tmpDir, "level1", "photo.png"), make([]byte, 300), 0644)
	_ = os.WriteFile(filepath.Join(tmpDir, "level1", "level2", "deep_report.pdf"), make([]byte, 1000), 0644)
	_ = os.WriteFile(filepath.Join(tmpDir, "level1", "level2", "level3", "abyss_report.pdf"), make([]byte, 50), 0644)

	rootOpts, _ := json.Marshal(map[string]string{"root": tmpDir})
	if resp := SetRemoteConfigInternal("search_local", "local", string(rootOpts)); !resp.Success {
		t.Fatalf("Failed to configure search_local: %s", resp.Error)
	}
	defer DeleteRemoteInternal("search_local")

	// 1. Substring query + recursive match across all depths
	req1, _ := json.Marshal(map[string]interface{}{
		"remotes":      []string{"search_local"},
		"query":        "REPORT",
		"include_dirs": false,
	})
	start1 := StartSearchInternal(string(req1))
	if !start1.Success {
		t.Fatalf("StartSearchInternal failed: %s", start1.Error)
	}
	startData1 := start1.Data.(SearchStartResponse)
	snap1 := waitForSearchCompletion(t, startData1.JobID)
	if snap1.Status != "completed" {
		t.Fatalf("Expected completed, got %s (err=%s)", snap1.Status, snap1.Error)
	}
	if len(snap1.Results) != 4 {
		t.Fatalf("Expected 4 report files, got %d: %+v", len(snap1.Results), snap1.Results)
	}
	for _, it := range snap1.Results {
		if it.Remote != "search_local" {
			t.Errorf("Expected Remote 'search_local', got %q", it.Remote)
		}
	}
	_ = ClearSearchInternal(startData1.JobID)

	// 2. Glob query + extensions + min_size + max_size
	req2, _ := json.Marshal(map[string]interface{}{
		"remotes":      []string{"search_local"},
		"query":        "*report*",
		"extensions":   []string{".pdf"},
		"min_size":     200,
		"max_size":     600,
		"include_dirs": false,
	})
	start2 := StartSearchInternal(string(req2))
	if !start2.Success {
		t.Fatalf("StartSearchInternal 2 failed: %s", start2.Error)
	}
	snap2 := waitForSearchCompletion(t, start2.Data.(SearchStartResponse).JobID)
	if len(snap2.Results) != 2 {
		t.Fatalf("Expected 2 matching PDFs in [200, 600], got %d: %+v", len(snap2.Results), snap2.Results)
	}
	_ = ClearSearchInternal(snap2.JobID)

	// 3. max_depth = 1 (0 slashes or 1 slash in item.Path)
	req3, _ := json.Marshal(map[string]interface{}{
		"remotes":      []string{"search_local"},
		"query":        "report",
		"max_depth":    1,
		"include_dirs": false,
	})
	start3 := StartSearchInternal(string(req3))
	if !start3.Success {
		t.Fatalf("StartSearchInternal 3 failed: %s", start3.Error)
	}
	snap3 := waitForSearchCompletion(t, start3.Data.(SearchStartResponse).JobID)
	if len(snap3.Results) != 2 {
		t.Fatalf("Expected 2 results with max_depth=1 (top_report.pdf and level1/sub_report.PDF), got %d: %+v", len(snap3.Results), snap3.Results)
	}
	_ = ClearSearchInternal(snap3.JobID)

	// 4. include_dirs = true
	req4, _ := json.Marshal(map[string]interface{}{
		"remotes":      []string{"search_local"},
		"query":        "level2",
		"include_dirs": true,
	})
	start4 := StartSearchInternal(string(req4))
	if !start4.Success {
		t.Fatalf("StartSearchInternal 4 failed: %s", start4.Error)
	}
	snap4 := waitForSearchCompletion(t, start4.Data.(SearchStartResponse).JobID)
	foundDir := false
	for _, it := range snap4.Results {
		if it.IsDir && it.Name == "level2" {
			foundDir = true
		}
	}
	if !foundDir {
		t.Errorf("Expected level2 dir in results when include_dirs=true, got %+v", snap4.Results)
	}
	_ = ClearSearchInternal(snap4.JobID)

	// 5. Files inside a folder matching the keyword must NOT match unless their own name matches
	_ = os.MkdirAll(filepath.Join(tmpDir, "budget_folder"), 0755)
	_ = os.WriteFile(filepath.Join(tmpDir, "budget_folder", "unrelated.txt"), []byte("nope"), 0644)
	_ = os.WriteFile(filepath.Join(tmpDir, "budget_folder", "budget_2026.txt"), []byte("yes"), 0644)

	req5, _ := json.Marshal(map[string]interface{}{
		"remotes":      []string{"search_local"},
		"query":        "budget",
		"include_dirs": false,
	})
	start5 := StartSearchInternal(string(req5))
	if !start5.Success {
		t.Fatalf("StartSearchInternal 5 failed: %s", start5.Error)
	}
	snap5 := waitForSearchCompletion(t, start5.Data.(SearchStartResponse).JobID)
	if len(snap5.Results) != 1 || snap5.Results[0].Name != "budget_2026.txt" {
		t.Fatalf("Expected only budget_2026.txt (not budget_folder/unrelated.txt), got %+v", snap5.Results)
	}
	_ = ClearSearchInternal(snap5.JobID)

	// Explicit path query containing '/' should still match full path
	req6, _ := json.Marshal(map[string]interface{}{
		"remotes":      []string{"search_local"},
		"query":        "budget_folder/unrel",
		"include_dirs": false,
	})
	start6 := StartSearchInternal(string(req6))
	if !start6.Success {
		t.Fatalf("StartSearchInternal 6 failed: %s", start6.Error)
	}
	snap6 := waitForSearchCompletion(t, start6.Data.(SearchStartResponse).JobID)
	if len(snap6.Results) != 1 || snap6.Results[0].Name != "unrelated.txt" {
		t.Fatalf("Expected path query 'budget_folder/unrel' to match unrelated.txt, got %+v", snap6.Results)
	}
	_ = ClearSearchInternal(snap6.JobID)
}

func TestGlobalSearchInternal_TruncationMultiRemoteAndCrypt(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	dirA := filepath.Join(tmpDir, "cloudA")
	dirB := filepath.Join(tmpDir, "cloudB")
	_ = os.MkdirAll(dirA, 0755)
	_ = os.MkdirAll(dirB, 0755)

	for i := 0; i < 6; i++ {
		_ = os.WriteFile(filepath.Join(dirA, "match_"+string(rune('a'+i))+".txt"), []byte("data"), 0644)
	}
	_ = os.WriteFile(filepath.Join(dirB, "match_b1.txt"), []byte("data"), 0644)

	optsA, _ := json.Marshal(map[string]string{"root": dirA})
	optsB, _ := json.Marshal(map[string]string{"root": dirB})
	SetRemoteConfigInternal("cloud_a", "local", string(optsA))
	SetRemoteConfigInternal("cloud_b", "local", string(optsB))
	defer DeleteRemoteInternal("cloud_a")
	defer DeleteRemoteInternal("cloud_b")

	// 1. MaxResults truncation across remotes
	reqTrunc, _ := json.Marshal(map[string]interface{}{
		"remotes":     []string{"cloud_a", "cloud_b"},
		"query":       "match_",
		"max_results": 3,
	})
	startTrunc := StartSearchInternal(string(reqTrunc))
	if !startTrunc.Success {
		t.Fatalf("StartSearchInternal trunc failed: %s", startTrunc.Error)
	}
	snapTrunc := waitForSearchCompletion(t, startTrunc.Data.(SearchStartResponse).JobID)
	if snapTrunc.Status != "completed" {
		t.Fatalf("Expected completed on truncation, got %s (err=%s)", snapTrunc.Status, snapTrunc.Error)
	}
	if !snapTrunc.Truncated {
		t.Errorf("Expected Truncated=true when max_results=3 and 7 files exist")
	}
	if len(snapTrunc.Results) != 3 {
		t.Errorf("Expected exactly 3 results, got %d", len(snapTrunc.Results))
	}
	_ = ClearSearchInternal(snapTrunc.JobID)

	// 2. Partial failure: one valid remote + one invalid remote -> completed with warning
	reqWarn, _ := json.Marshal(map[string]interface{}{
		"remotes": []string{"cloud_b", "non_existent_cloud_xyz"},
		"query":   "match_b1",
	})
	startWarn := StartSearchInternal(string(reqWarn))
	snapWarn := waitForSearchCompletion(t, startWarn.Data.(SearchStartResponse).JobID)
	if snapWarn.Status != "completed" {
		t.Fatalf("Expected completed when 1 of 2 remotes succeeds, got %s", snapWarn.Status)
	}
	if len(snapWarn.Results) != 1 || snapWarn.Results[0].Remote != "cloud_b" {
		t.Errorf("Expected 1 result from cloud_b, got %+v", snapWarn.Results)
	}
	if len(snapWarn.Warnings) == 0 {
		t.Errorf("Expected non-fatal warning for non_existent_cloud_xyz")
	}
	_ = ClearSearchInternal(snapWarn.JobID)

	// 3. Crypt remote transparent filename decryption during search
	vaultDir := filepath.Join(tmpDir, "vault")
	_ = os.MkdirAll(vaultDir, 0755)
	optsRoot, _ := json.Marshal(map[string]string{"root": tmpDir})
	SetRemoteConfigInternal("root_local", "local", string(optsRoot))
	defer DeleteRemoteInternal("root_local")
	cryptOpts, _ := json.Marshal(map[string]string{
		"remote":                    "root_local:" + vaultDir,
		"password":                  "secretPass123",
		"filename_encryption":       "standard",
		"directory_name_encryption": "true",
	})
	SetRemoteConfigInternal("vault_crypt", "crypt", string(cryptOpts))
	defer DeleteRemoteInternal("vault_crypt")

	plainSrc := filepath.Join(tmpDir, "plain_src.txt")
	_ = os.WriteFile(plainSrc, []byte("secret content"), 0644)
	if up := CopyFileInternal("", plainSrc, "vault_crypt", "nested/classified_budget.pdf"); !up.Success {
		t.Fatalf("Upload to vault_crypt failed: %s", up.Error)
	}

	reqCrypt, _ := json.Marshal(map[string]interface{}{
		"remotes": []string{"vault_crypt"},
		"query":   "classified_budget",
	})
	startCrypt := StartSearchInternal(string(reqCrypt))
	snapCrypt := waitForSearchCompletion(t, startCrypt.Data.(SearchStartResponse).JobID)
	if snapCrypt.Status != "completed" {
		t.Fatalf("Crypt search failed: %s (%s)", snapCrypt.Status, snapCrypt.Error)
	}
	if len(snapCrypt.Results) != 1 || snapCrypt.Results[0].Name != "classified_budget.pdf" {
		t.Fatalf("Expected decrypted classified_budget.pdf, got %+v", snapCrypt.Results)
	}
	_ = ClearSearchInternal(snapCrypt.JobID)
}

func TestGlobalSearchInternal_CancelAndClear(t *testing.T) {
	InitRcloneInternal("")
	tmpDir := t.TempDir()

	// Create many nested files so cancellation can run cleanly
	for d := 0; d < 10; d++ {
		sub := filepath.Join(tmpDir, "dir_"+string(rune('0'+d)))
		_ = os.MkdirAll(sub, 0755)
		for f := 0; f < 20; f++ {
			_ = os.WriteFile(filepath.Join(sub, "f_"+string(rune('a'+f))+".dat"), []byte("x"), 0644)
		}
	}

	opts, _ := json.Marshal(map[string]string{"root": tmpDir})
	SetRemoteConfigInternal("cancel_local", "local", string(opts))
	defer DeleteRemoteInternal("cancel_local")

	req, _ := json.Marshal(map[string]interface{}{
		"remotes": []string{"cancel_local"},
		"query":   "f_",
	})
	startResp := StartSearchInternal(string(req))
	if !startResp.Success {
		t.Fatalf("StartSearchInternal failed: %s", startResp.Error)
	}
	jobID := startResp.Data.(SearchStartResponse).JobID

	cancelResp := CancelSearchInternal(jobID)
	if !cancelResp.Success {
		t.Fatalf("CancelSearchInternal failed: %s", cancelResp.Error)
	}

	snap := waitForSearchCompletion(t, jobID)
	if snap.Status != "cancelled" && snap.Status != "completed" {
		t.Errorf("Expected cancelled or completed status, got %s", snap.Status)
	}

	clearResp := ClearSearchInternal(jobID)
	if !clearResp.Success {
		t.Fatalf("ClearSearchInternal failed: %s", clearResp.Error)
	}

	afterClear := GetSearchStatusInternal(jobID)
	if afterClear.Success {
		t.Errorf("Expected GetSearchStatusInternal after ClearSearch to fail")
	}
}






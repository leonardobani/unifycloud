package main

import (
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



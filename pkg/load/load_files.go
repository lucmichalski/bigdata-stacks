package load

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/pkg/errors"
	log "github.com/sirupsen/logrus"
)

// getFilesPath retrieve recursively all json and yml test files in a directory. Except excluded files
func getFilesPath(paths []string, exclude []string) ([]string, error) {

	validExtFile := map[string]bool{".json": true, ".yml": true, ".yaml": true}
	// Get all files
	okPaths, err := uniqueRecursiveFilesPath(paths, validExtFile)
	if err != nil {
		var empty []string
		return empty, err
	}
	// Return if no files have been found.
	if len(okPaths) == 0 {
		var empty []string
		return empty, nil
	}

	// If flag exclude: Fetch and Delete paths from okPaths List
	if len(exclude) > 1 {
		excludedPaths, _ := uniqueRecursiveFilesPath(exclude, validExtFile)

		// Delete excluded paths
		for key := range okPaths {
			if excludedPaths[key] {
				delete(okPaths, key)
			}
		}
	}

	var filePaths = make([]string, 0, len(okPaths))

	// Return a clean list of unique entries
	for k := range okPaths {
		filePaths = append(filePaths, k)
	}
	return filePaths, nil
}

// uniqueRecursiveFilesPath Returns map of unique files into folder by recursion
func uniqueRecursiveFilesPath(SrcPaths []string, extfile map[string]bool) (map[string]bool, error) {

	var filesPath = make(map[string]bool)

	for _, p := range SrcPaths {
		p = strings.TrimSpace(p)
		p = filepath.Clean(p)

		// Check if path exists
		if _, err := os.Stat(p); os.IsNotExist(err) {
			return nil, err
		}

		err := filepath.Walk(p, func(path string, info os.FileInfo, err error) error {
			if info.IsDir() {
				return nil
			}
			if _, match := extfile[filepath.Ext(info.Name())]; match {
				filesPath[path] = true
			}
			return nil
		})
		if err != nil {
			log.Errorf("Error reading files on path:%s :%s", SrcPaths, err)
			return nil, errors.Wrapf(err, "error reading files on path %q", SrcPaths)
		}
	}
	return filesPath, nil
}

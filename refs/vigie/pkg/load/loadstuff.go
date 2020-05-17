package load

import (
	"fmt"
)

//getAllFilesInsideDir deep search to find
func getAllFilesInsideDir(p []string, pathsExcluded []string, defaultpath string) ([]string, error) {

	/* importing files
	Path to each individual Step & Var file.
	*/

	// Clean list from args ( --test and all except flag)
	// Tests Path
	paths := importArgsPathShort(p)
	if len(paths) == 1 && paths[0] == "" {
		// If paths empty : Remplace [0] = "" by the default folder
		paths[0] = defaultpath
	}

	// Crée une Liste de fichier contenu dans un dossier (yml,yaml,json)
	// Tests Path
	files, err := getFilesPath(paths, pathsExcluded)
	if err != nil {
		return nil, fmt.Errorf("error during file import: %s", err)
	}

	return files, err
}

// importArgsPath: Create a clean list from arguments
func importArgsPathShort(testsPath []string) (uTestPath []string) {

	uTestPath = make([]string, 0, 0)

	if len(testsPath) == 0 {
		// If no Args Files Paths : Add ./tests
		uTestPath[0] = defaultTestSuitePath
		return uTestPath
	} else {
		// Add Unique entry to Map
		return unique(testsPath)
	}
}

func unique(intSlice []string) []string {
	keys := make(map[string]bool)
	list := []string{}
	for _, entry := range intSlice {
		if _, value := keys[entry]; !value {
			keys[entry] = true
			list = append(list, entry)
		}
	}
	return list
}

func sliceUniqMap(s []string) []string {
	seen := make(map[string]struct{}, len(s))
	j := 0
	for _, v := range s {
		if _, ok := seen[v]; ok {
			continue
		}
		seen[v] = struct{}{}
		s[j] = v
		j++
	}
	return s[:j]
}

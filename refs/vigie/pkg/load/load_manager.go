package load

import (
	"crypto/tls"
	"fmt"
	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/plumbing"
	"github.com/go-git/go-git/v5/plumbing/transport/client"
	githttp "github.com/go-git/go-git/v5/plumbing/transport/http"
	log "github.com/sirupsen/logrus"
	"github.com/vincoll/vigie/pkg/probe/probetable"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/utils"
	"github.com/vincoll/vigie/pkg/utils/timeutils"
	"net/http"
	"os"
	"time"
)

type ImportManager struct {
	Frequency time.Duration
	git       ConfGit
	testFiles ConfTestfiles
	variables ConfVariables
}

func InitImportManager(ci ConfImport) (ImportManager, error) {

	impMgr := ImportManager{}

	// Validator
	if ci.Testfiles.Included == nil || len(ci.Testfiles.Included) == 0 {
		return ImportManager{}, fmt.Errorf("import.testfiles.include is nill or empty")
	}

	if ci.Git.Clone {
		if ci.Git.Repo == "" {
			return ImportManager{}, fmt.Errorf("git clone is true, but no import.git.repo is empty")
		}
		if ci.Git.Path == "" {
			return ImportManager{}, fmt.Errorf("git clone is true, but no import.git.path is empty")
		}
	}

	if ci.Frequency != "" {
		// This func handle many duration format
		f, err := timeutils.ShortTimeStrToDuration(ci.Frequency)
		if err != nil {
			return ImportManager{}, err
		}
		impMgr.Frequency = f
	}
	impMgr.git = ci.Git
	impMgr.testFiles = ci.Testfiles
	impMgr.variables = ci.Variables

	return impMgr, nil
}
func (im *ImportManager) LoadTestSuites() (map[uint64]*teststruct.TestSuite, error) {

	utils.Log.WithFields(log.Fields{
		"package": "vigie", "type": "info",
	}).Debugf("Importing files and generate the tests")

	start := time.Now()

	testsFiles, varsFiles, err := im.importFileandVars()
	if err != nil {
		return nil, err
	} else {
		elapsed := time.Since(start)
		utils.Log.WithFields(log.Fields{
			"package": "load",
			"desc":    "list new tests",
			"type":    "perf_measurement",
			"value":   elapsed.Seconds(),
		}).Debugf("List new tests: %s", elapsed)
	}

	// Super important, TODO Comment visibility
	probeTable := probetable.AvailableProbes

	umt, err := NewUnMarshallTool(varsFiles, probeTable)
	if err != nil {
		return nil, err
	}
	newTSs := make(map[uint64]*teststruct.TestSuite, len(testsFiles))

	start = time.Now()
	// loop on each TestSuite files
	for _, f := range testsFiles {

		// importingFileToVigie each Tests Files as TestSuite
		ts, err := umt.ImportTestSuite(f)
		if err != nil {
			utils.Log.WithFields(log.Fields{
				"error": err.Error(),
				"type":  "info",
				"file":  f,
			}).Error("Cannot load this file.")
			return nil, fmt.Errorf("%s ", err.Error())

		} else {
			// After Validation : Append this Valid TestSuites to Vigie
			ts.SourceFile = f
			newTSs[ts.ID] = ts
			utils.Log.WithFields(log.Fields{"file": f, "type": "info"}).Debug("Has been loaded.")
		}
	}

	elapsed := time.Since(start)
	utils.Log.WithFields(log.Fields{
		"package": "load",
		"desc":    "file import and test generation",
		"type":    "perf_measurement",
		"value":   elapsed.Seconds(),
	}).Debugf("File import and test generation duration: %s", elapsed)

	return newTSs, nil
}

// importFileandVars Charge la config d'un fichier vigieConf dans une instance Vigie
// La fonction retourne tous les fichiers (test,vars) éligibles contenus dans les répertoires Tests et Vars
func (im *ImportManager) importFileandVars() (testsFiles []string, varsFiles []string, err error) {

	if im.git.Clone {
		errGit := im.cloneGitRepo(im.git)
		if errGit != nil {
			return nil, nil, fmt.Errorf("Failed to clone: %v", errGit)
		}
	}

	// importing Files
	// Path to each individual Step & Var file.

	// Add Step path for each file
	// TODO: Gérer l'erreur ?
	testsFiles, _ = getAllFilesInsideDir(im.testFiles.Included, im.testFiles.Excluded, defaultTestSuitePath)
	if len(testsFiles) == 0 {
		return nil, nil, fmt.Errorf("no files or path to import")
	}

	// Add Var path for each file
	varsFiles, _ = getAllFilesInsideDir(im.variables.Included, im.variables.Excluded, defaultVariablePath)

	return testsFiles, varsFiles, nil
}

// cloneGitRepo clone a git repo containing the tests and vars
func (im *ImportManager) cloneGitRepo(cg ConfGit) error {

	if _, err := os.Stat(cg.Path); !os.IsNotExist(err) {
		if err != nil {
			return fmt.Errorf("%s", err)
		}
		// If existing remove the content
		err = os.RemoveAll(cg.Path)
		if err != nil {
			return fmt.Errorf("%s", err)
		}
	}

	var customClient *http.Client

	if cg.AllowInsecure {
		customClient = &http.Client{
			// accept any certificate (might be useful for testing)
			Transport: &http.Transport{
				TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
			},
		}

		// Override http(s) default protocol to use our custom client
		client.InstallProtocol("https", githttp.NewClient(customClient))
	}

	if cg.Branch == "" {
		cg.Branch = "master"
	}

	r, err := git.PlainClone(cg.Path, false, &git.CloneOptions{
		URL:               cg.Repo,
		ReferenceName:     plumbing.ReferenceName(fmt.Sprintf("refs/heads/%s", cg.Branch)),
		RecurseSubmodules: git.DefaultSubmoduleRecursionDepth,
		SingleBranch:      true,
	})

	if err != nil {
		return fmt.Errorf("git clone of %s to %s failed : %s", cg.Repo, cg.Path, err)
	}

	// ... retrieving the branch being pointed by HEAD
	ref, err := r.Head()
	if err != nil {
		return err
	}
	// ... retrieving the commit object
	commit, err := r.CommitObject(ref.Hash())
	if err != nil {
		return err
	}

	utils.Log.WithFields(log.Fields{}).Infof("Commit %q (%s) from %s has been cloned into %s", commit.Message, commit.Hash.String()[:7], cg.Repo, cg.Path)

	return nil
}

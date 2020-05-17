package teststruct

import (
	"encoding/json"
	"fmt"
	"github.com/mitchellh/hashstructure"
	"sync"
	"time"

	"github.com/sirupsen/logrus"

	"github.com/vincoll/vigie/pkg/utils"
)

type JSONTestSuite struct {
	Config        configTestStructJson `json:"config"`
	Name          string               `json:"name"`
	JsonTestCases []JSONTestCase       `json:"testcases"`
	Vars          map[string][]string  `json:"vars"`
}

type TestSuite struct {
	Mutex      sync.RWMutex `hash:"ignore"`
	Name       string
	ID         uint64     `hash:"ignore"`
	Status     StepStatus `hash:"ignore"`
	TestCases  map[uint64]*TestCase
	LastChange time.Time `hash:"ignore"`
	SourceFile string    `hash:"ignore"` // Public
}

// UnmarshalJSON Interface for TestSuite_OLD struct
// This Go interface allow to **
// importing deeply TestSuites + TC + Tsteps
// This function is call by unmarshalTestSuiteFile in
// TC will also use a UnmarshalJSON Interface
// TStep

func (ts *TestSuite) UnmarshalJSON(data []byte) error {
	var jsonTS JSONTestSuite
	if errjs := json.Unmarshal(data, &jsonTS); errjs != nil {
		return errjs
	}

	var err error
	*ts, err = jsonTS.toTestSuite()
	if err != nil {
		utils.Log.WithFields(logrus.Fields{
			"testsuite": jsonTS.Name,
		}).Fatalf("A TestSuite is invalid: %s", err)

		return err
	}
	return nil
}

// toTestSuite convert JsonTestSuite into TestSuite after Validations
func (jts JSONTestSuite) toTestSuite() (TestSuite, error) {

	// TestSuite init
	var ts TestSuite

	if jts.Name == "" {
		return TestSuite{}, fmt.Errorf("name is missing or empty")
	}
	ts.Name = jts.Name

	if jts.JsonTestCases == nil {
		return TestSuite{}, fmt.Errorf("no testcase detected in %q testsuite", jts.Name)
	}

	// UnMarshall spécifique de la config avec conversion de strings type (1d,7m) en time.duration
	ctsTS, err := unmarshallConfigTestStruct(jts.Config)
	if err != nil {

		utils.Log.WithFields(logrus.Fields{
			"testsuite": ts.Name,
		}).Fatalf("config declaration : %s", err)

		return TestSuite{}, fmt.Errorf("config declaration: %s", err)
	}

	ts.TestCases = make(map[uint64]*TestCase, len(jts.JsonTestCases))

	mergeMapsTS := utils.MergeMaps(utils.ALLVARS, jts.Vars)

	// Apply config inheritance TestSuite => TC
	for _, jtc := range jts.JsonTestCases {

		testcase, jtcErr := jtc.toTestCase(&ctsTS, mergeMapsTS)
		if jtcErr != nil {

			utils.Log.WithFields(logrus.Fields{
				"testsuite": ts.Name,
			}).Fatalf("Cannot import : %s", jtcErr)

		}

		ts.addTestCase(&testcase)

	}

	// The TestSuite generation is now done: TestSuite.ID is a hash of this TestSuite
	// It will be easier to compare this TestSuite later if changes occurs in a TestSuite file.
	// NB: This hash is calculated on the TCs and the TSteps contained in this TestSuite.
	ts.ID, err = hashstructure.Hash(ts, nil)
	if err != nil {
		panic(err)
	}

	return ts, nil
}

// GetTestcaseByID get a TestCase by is ID in the current TestSuite.
func (ts *TestSuite) GetTestcaseByID(TCid uint64) (tc *TestCase) {

	ts.Mutex.RLock()
	tc = ts.TestCases[TCid]
	ts.Mutex.RUnlock()
	return tc

}

func (ts *TestSuite) WithoutTC() TestSuite {

	tsBis := *ts
	// Reset TestCase
	tsBis.TestCases = make(map[uint64]*TestCase, 1)
	tsBis.Mutex = sync.RWMutex{}
	return tsBis

}

// removeTestCase simply add a TestCase to this TestSuite, concurrency safe
func (ts *TestSuite) addTestCase(newTC *TestCase) {

	ts.Mutex.Lock()
	ts.TestCases[newTC.ID] = newTC
	ts.Mutex.Unlock()

}

// removeTestCase simply removes a TestCase from this TestSuite, concurrency safe
func (ts *TestSuite) removeTestCase(ID uint64) {

	ts.Mutex.Lock()
	delete(ts.TestCases, ID)
	ts.Mutex.Unlock()

}

// ImportAllTestCases will add new TCs, remove oldTC that are absent from the new TCs, keep common TCs
func (ts *TestSuite) ImportAllTestCases(newTCs map[uint64]*TestCase) {

	// Compilation to avoid multiples loops
	newStateTCs := make(map[string]uint64, 0)
	for _, ntc := range newTCs {
		newStateTCs[ntc.Name] = ntc.ID
	}

	// UPDATE or REMOVE
	for _, oTC := range ts.TestCases {
		// If old TC name is in newTCs
		if nTCid, alreadyExists := newStateTCs[oTC.Name]; alreadyExists {
			// Name exists, but have they the same ID(hash) ?
			if oTC.ID != nTCid {
				// Name is identical to an existing TC, but ID is different.
				// That means that the old import have changed. And so TSteps.
				// The full old TestCase state is keep, but we need to go deeper to update this TestCase.
				newTCs[nTCid].ImportTestSteps(oTC.TestSteps)
			} else {
				newTCs[nTCid] = oTC
			}
		}
	}
	ts.TestCases = newTCs
}

// ImportAllTestCases will add new TCs, remove oldTC that are absent from the new TCs, keep common TCs
func (ts *TestSuite) _ImportAllTestCases(newTCs map[uint64]*TestCase) {

	// Compilation to avoid multiples loops
	newStateTCs := make(map[string]uint64, 0)
	for _, ntc := range newTCs {
		newStateTCs[ntc.Name] = ntc.ID
	}

	// UPDATE or REMOVE
	for _, oTC := range ts.TestCases {
		// If old TC name is in newTCs
		if nTCid, alreadyExists := newStateTCs[oTC.Name]; alreadyExists {
			// Name exists, but have they the same ID(hash) ?
			if oTC.ID == nTCid {
				// Delete TC that is already present
				delete(newTCs, newTCs[oTC.ID].ID)
				// This TS already exist and has not been modified since the last (re)import
				// No changes to do, Skip this oldTestSuite
				continue
			} else {
				// Name is identical to an existing TC, but ID is different.
				// That means that the old import have changed. And so TSteps.
				// The full old TestCase state is keep, but we need to go deeper to update this TestCase.
				oTC.ImportTestSteps(newTCs[nTCid].TestSteps)
			}
		} else {
			// If a old TStep name is not in newTCs => delete the Old TS
			// Delete Old Testsuites First
			ts.removeTestCase(oTC.ID)
		}
	}

	// ADD new ones

	for _, nTC := range newTCs {
		if _, alreadyExists := ts.TestCases[nTC.ID]; alreadyExists {
			continue
		} else {
			// Simply Add a new Testcase
			ts.addTestCase(nTC)
		}
	}
}

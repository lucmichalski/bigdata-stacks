package teststruct

import (
	"fmt"
	"github.com/mitchellh/hashstructure"
	"sync"
	"time"
)

type JSONTestCase struct {
	Name      string               `json:"name"`
	Config    configTestStructJson `json:"config"`
	Loop      []string             `json:"loop"`
	JsonSteps []JSONStep           `json:"steps"`
}

// toTestCase is a single test case with its result.
type TestCase struct {
	Name       string
	ID         uint64           `hash:"ignore"`
	Mutex      sync.RWMutex     `hash:"ignore"`
	Config     configTestStruct `hash:"ignore"`
	Status     StepStatus       `hash:"ignore"`
	LastChange time.Time        `hash:"ignore"`
	TestSteps  map[uint64]*TestStep
}

// importConfig allows configuration inheritance
// Only insert configs not present, in case of different config
// priority is given to the lowest entity.
func importConfig(cfgTS *configTestStruct, cfgTC configTestStruct) configTestStruct {

	for k, v := range cfgTS.Frequency {
		if _, present := cfgTC.Frequency[k]; !present {
			cfgTC.Frequency[k] = v
		}
	}
	for k, v := range cfgTS.Timeout {
		if _, present := cfgTC.Timeout[k]; !present {
			cfgTC.Timeout[k] = v
		}
	}
	for k, v := range cfgTS.Retrydelay {
		if _, present := cfgTC.Retrydelay[k]; !present {
			cfgTC.Retrydelay[k] = v
		}
	}
	if cfgTC.Retry == nil {
		cfgTC.Retry = map[string]int{}
	}
	for k, v := range cfgTS.Retry {
		if _, present := cfgTC.Retry[k]; !present {
			cfgTC.Retry[k] = v
		}
	}

	return cfgTC

}

// https://blog.gopheracademy.com/advent-2016/advanced-encoding-decoding/
func (jtc JSONTestCase) toTestCase(ctsTS *configTestStruct, tsVars map[string][]string) (TestCase, error) {

	var tc TestCase

	if jtc.Name == "" {
		return TestCase{}, fmt.Errorf("testcase name is missing")
	}
	tc.Name = jtc.Name

	if jtc.JsonSteps == nil {
		return TestCase{}, fmt.Errorf("no teststep detected in %q testcase", jtc.Name)
	}

	// UnMarshall spécifique de la config avec conversion de strings type (1d,7m) en time.duration
	ctcTC, err := unmarshallConfigTestStruct(jtc.Config)
	if err != nil {
		return TestCase{}, fmt.Errorf("config declaration: %s", err)
	}

	ctcTC = importConfig(ctsTS, ctcTC)

	// Add TestSteps
	tc.TestSteps = make(map[uint64]*TestStep, len(jtc.JsonSteps))

	for _, jStp := range jtc.JsonSteps {

		teststeps, err := jStp.toTestStep(&ctcTC, tsVars)
		if err != nil {
			return TestCase{}, fmt.Errorf("%s : Step is invalid: %s", tc.Name, err)
		}

		tc.addAllTestSteps(teststeps)
	}

	// The TestCase generation is now done: TestCase.ID is a hash of this TestCase
	// It will be easier to compare this TestCase later if changes occurs in a TestSuite file.
	// NB: This hash is calculated on the TSteps contained in this TestCase.

	tc.ID, err = hashstructure.Hash(tc, nil)
	if err != nil {
		panic(err)
	}
	return tc, nil
}

// addAllTestSteps Simply loops and add TestSteps into this TestCase, no checks concurency safe
func (tc *TestCase) addAllTestSteps(teststeps []TestStep) {

	for _, tstep := range teststeps {
		tstp2 := tstep
		tc.addTestStep(&tstp2)
	}
}

// addTestStep simply  add a TestStep into this TestCase, no checks concurency safe
func (tc *TestCase) addTestStep(newTStep *TestStep) {

	tc.Mutex.Lock()
	tc.TestSteps[newTStep.ID] = newTStep
	tc.Mutex.Unlock()

}

// remobeTestStep simply removes a TestStep from this TestCase, concurency safe
func (tc *TestCase) RemoveTestStep(ID uint64) {

	tc.Mutex.Lock()
	delete(tc.TestSteps, ID)
	tc.Mutex.Unlock()

}

// FailureCount returns the numbers of non success teststep
func (tc *TestCase) FailureCount() (failCount int) {
	tc.Mutex.RLock()
	for _, tstep := range tc.TestSteps {
		tstep.Mutex.RLock()
		failCount += len(tstep.Failures)
		tstep.Mutex.RUnlock()
	}
	tc.Mutex.RUnlock()

	return failCount
}

// GetStatus returns this TestCase Status
func (tc *TestCase) GetStatus() (ss StepStatus) {
	tc.Mutex.RLock()
	ss = tc.Status
	tc.Mutex.RUnlock()
	return ss
}

// SetStatus set this TestCase Status
func (tc *TestCase) SetStatus(newStatus StepStatus) {
	tc.Mutex.Lock()
	tc.Status = newStatus
	tc.Mutex.Unlock()
}

// Returns this Testcase without Teststeps
func (tc *TestCase) WithoutTStep() *TestCase {

	tcBis := *tc
	// Reset TestStep
	tcBis.Mutex = sync.RWMutex{}
	tcBis.TestSteps = make(map[uint64]*TestStep, 1)
	return &tcBis

}

// ImportTestSteps will add new TSteps to an empty or already populated TestCase,
// Import Rules : remove oldTSteps that are absent from the new TSteps, keep common TSteps, add new ones
func (tc *TestCase) _ImportTestSteps(newTSteps map[uint64]*TestStep) {

	oldStateTSteps := make([]uint64, len(tc.TestSteps))
	for _, oTstp := range tc.TestSteps {
		oldStateTSteps = append(oldStateTSteps, oTstp.ID)
	}

	// newTCs is considered as the new state, if a old TC are not present in newTCs
	// therefore the oldTC must be deleted.
	for _, oTstep := range tc.TestSteps {

		// If old TC name is in newTCs
		if _, alreadyExists := newTSteps[oTstep.ID]; alreadyExists {
			// Delete TStep that is already present
			delete(newTSteps, newTSteps[oTstep.ID].ID)
			continue
		} else {
			tc.RemoveTestStep(oTstep.ID)
		}
	}

	// Then add the new TestSteps left
	for _, ntstp := range newTSteps {
		if _, alreadyExists := tc.TestSteps[ntstp.ID]; alreadyExists {
			continue
		} else {
			// Simply Add a new Teststep
			tc.addTestStep(ntstp)
		}
	}
}

// ImportTestSteps will add new TSteps to an empty or already populated TestCase,
// Import Rules : remove oldTSteps that are absent from the new TSteps, keep common TSteps, add new ones
func (tc *TestCase) ImportTestSteps(newTSteps map[uint64]*TestStep) {

	// newTSteps is considered as the new base state,
	// but if a old TStep is present in newTStep
	// its value will be replaced to keep its former status.
	for _, oTstep := range tc.TestSteps {

		// If old TStep is in newTCs
		if _, exists := newTSteps[oTstep.ID]; exists {
			newTSteps[oTstep.ID] = oTstep

		}
	}
	tc.TestSteps = newTSteps
}

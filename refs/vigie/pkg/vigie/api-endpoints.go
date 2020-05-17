package vigie

import (
	"fmt"
	"github.com/vincoll/vigie/pkg/teststruct"
	"strconv"
	"strings"
)

// BY NAME

func (v *Vigie) GetTestSuiteByName(name string) (teststruct.TSDescribe, error) {
	for _, ts := range v.TestSuites {
		if ts.Name == name {
			return ts.ToJSON(), nil
		}
	}
	return teststruct.TSDescribe{}, fmt.Errorf("testsuite %q not found", name)
}

// One BY ID

func (v *Vigie) GetTestSuiteByID(tsID uint64) (teststruct.TSDescribe, error) {

	ts, found := v.TestSuites[tsID]
	if found {
		return ts.ToJSON(), nil
	} else {
		return teststruct.TSDescribe{}, fmt.Errorf("testsuite ID: %d not found", tsID)
	}

}

func (v *Vigie) GetTestCaseByID(tsID, tcID uint64) (teststruct.TCDescribe, error) {

	ts, tsfound := v.TestSuites[tsID]
	if tsfound {
		tc, tcfound := ts.TestCases[tcID]
		if tcfound {
			return tc.ToJSON(), nil
		} else {
			return teststruct.TCDescribe{}, fmt.Errorf("testcase ID %d in testsuite ID %d not found", tsID, tcID)
		}

	} else {
		return teststruct.TCDescribe{}, fmt.Errorf("testsuite ID: %d not found", tsID)
	}

}

func (v *Vigie) GetTestStepByID(tsID, tcID, tstpID uint64) (teststruct.TStepDescribe, error) {

	ts, tsfound := v.TestSuites[tsID]
	if tsfound {
		tc, tcfound := ts.TestCases[tcID]
		if tcfound {
			tstp, tstpfound := tc.TestSteps[tstpID]
			if tstpfound {
				return tstp.ToTestStepDescribe(), nil
			} else {
				return teststruct.TStepDescribe{}, fmt.Errorf("teststep ID %d not found in testcase ID %d in testsuite ID %d", tstpID, tcID, tsID)
			}

		} else {
			return teststruct.TStepDescribe{}, fmt.Errorf("testcase ID %d not found in testsuite ID %d", tcID, tsID)
		}

	} else {
		return teststruct.TStepDescribe{}, fmt.Errorf("testsuite ID %d not found", tsID)
	}

}

func (v *Vigie) GetTestByUID(uID string) (*teststruct.UIDTest, error) {

	idTS, idTC, idTStep, err := GetCleanUID(uID)
	if err != nil {
		return nil, err
	}
	splitUID := strings.Split(uID, "-")

	switch len(splitUID) {
	case 1:
		ts, found := v.TestSuites[idTS]
		if !found {
			return nil, fmt.Errorf("testsuite ID: %d not found", idTS)
		}
		return &teststruct.UIDTest{TestSuite: ts.ToHeader()}, nil

	case 2:
		ts, foundTS := v.TestSuites[idTS]
		if !foundTS {
			return nil, fmt.Errorf("testsuite ID: %d not found", idTS)
		}
		tc, foundTC := v.TestSuites[idTS].TestCases[idTC]
		if !foundTC {
			return nil, fmt.Errorf("testcase ID: %d not found", idTC)
		}
		return &teststruct.UIDTest{TestSuite: ts.ToHeader(), TestCase: tc.ToHeader()}, nil

	case 3:
		ts, foundTS := v.TestSuites[idTS]
		if !foundTS {
			return nil, fmt.Errorf("testsuite ID: %d not found", idTS)
		}
		tc, foundTC := v.TestSuites[idTS].TestCases[idTC]
		if !foundTC {
			return nil, fmt.Errorf("testcase ID: %d not found", idTC)
		}
		tstp, foundTStep := v.TestSuites[idTS].TestCases[idTC].TestSteps[idTStep]
		if !foundTStep {
			return nil, fmt.Errorf("teststep ID: %d not found", idTStep)
		}

		return &teststruct.UIDTest{TestSuite: ts.ToHeader(), TestCase: tc.ToHeader(), TestStep: tstp.ToTestStepDescribe()}, nil

	}

	return nil, nil
}

// Header List BY ID

func (v *Vigie) GetTestSuitesList() ([]teststruct.TSHeader, error) {

	var tsListHeader = make([]teststruct.TSHeader, 0, len(v.TestSuites))
	v.mu.RLock()
	for _, tSuite := range v.TestSuites {
		tsListHeader = append(tsListHeader, tSuite.ToHeader())
	}
	v.mu.RUnlock()

	return tsListHeader, nil
}

func (v *Vigie) GetTestCasesList(tsID uint64) ([]teststruct.TCHeader, error) {

	v.mu.RLock()
	defer v.mu.RUnlock()

	_, tsfound := v.TestSuites[tsID]
	if tsfound {
		v.TestSuites[tsID].Mutex.RLock()

		tcListHeader := make([]teststruct.TCHeader, 0, len(v.TestSuites[tsID].TestCases))
		for _, tc := range v.TestSuites[tsID].TestCases {
			tcListHeader = append(tcListHeader, tc.ToHeader())
		}
		v.TestSuites[tsID].Mutex.RUnlock()

		return tcListHeader, nil

	} else {
		return nil, fmt.Errorf("testsuite ID %d not found", tsID)
	}

}

func GetCleanUID(uID string) (ts, tc, tstp uint64, err error) {

	splitUID := strings.Split(uID, "-")
	switch len(splitUID) {

	case 0:
		return 0, 0, 0, fmt.Errorf("ID unknow : %q ", uID)
	case 1:
		idTSraw := splitUID[0]
		idTS, err := strconv.ParseInt(idTSraw, 10, 64)
		if err != nil {
			return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)
		}

		return uint64(idTS), 0, 0, nil

	case 2:
		idTSraw := splitUID[0]
		idTS, err := strconv.ParseInt(idTSraw, 10, 64)
		if err != nil {
			return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)
		}

		idTCraw := splitUID[1]
		idTC, err := strconv.ParseInt(idTCraw, 10, 64)
		if err != nil {
			return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)
		}

		return uint64(idTS), uint64(idTC), 0, nil

	case 3:
		idTSraw := splitUID[0]
		idTS, err := strconv.ParseInt(idTSraw, 10, 64)
		if err != nil {
			return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)
		}

		idTCraw := splitUID[1]
		idTC, err := strconv.ParseInt(idTCraw, 10, 64)
		if err != nil {
			return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)
		}

		idTStpraw := splitUID[2]
		idTStp, err := strconv.ParseInt(idTStpraw, 10, 64)
		if err != nil {
			return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)
		}

		return uint64(idTS), uint64(idTC), uint64(idTStp), nil

	default:
		return 0, 0, 0, fmt.Errorf("bad uID format: %q | Should be int-int-int", uID)

	}

}

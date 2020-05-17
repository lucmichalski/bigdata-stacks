package teststruct

import (
	"fmt"
	"github.com/sirupsen/logrus"
	"github.com/vincoll/vigie/pkg/assertion"
	"github.com/vincoll/vigie/pkg/utils"
	"time"

	"github.com/vincoll/vigie/pkg/probe"
)

type StepParam struct {
	Frequency  string `json:"frequency"`  // time interval between two test
	Retry      int    `json:"retry"`      // nb retry a test case if it is in failure.
	Retrydelay string `json:"retrydelay"` // delay between two retries
	Timeout    string `json:"timeout"`    // timeout on executor
}

type Processing struct {
	LastAttempt  time.Time
	Status       StepStatus
	VigieResults []VigieResult
	Issue        string
}

// WriteResult Write all temp processing data during RunTestStep in a teststep
func (tStep *TestStep) WriteResult(pData *Processing) (stateChanged, alertEvent bool) {

	start := time.Now()
	tStep.Mutex.Lock()
	tStep.LastAttempt = pData.LastAttempt
	tStep.VigieResults = pData.VigieResults
	tStep.Failures = make([]string, 0) // Clear past failures

	switch pData.Status {
	case Success:
		tStep.LastPositiveTimeResult = pData.LastAttempt
		tStep.LastPositiveVigieResults = &tStep.VigieResults

		utils.Log.WithFields(logrus.Fields{
			"package":  "process",
			"teststep": tStep.Name,
		}).Debugf("TestStep OK - Assertion OK")
		// Remember :
		// Alert Event will be true only if there is a change OK <=> ERR but no ND => OK
		stateChanged, alertEvent = tStep.setNewStatus(Success)

	case Error:
		tStep.Failures = append(tStep.Failures, fmt.Sprintf("%s", pData.Issue))

		utils.Log.WithFields(logrus.Fields{
			"package":  "process",
			"teststep": tStep.Name,
		}).Debugf("TestStep KO - Probe Error %s", pData.Issue)

		stateChanged, alertEvent = tStep.setNewStatus(Error)

	case Timeout:
		tStep.Failures = append(tStep.Failures, fmt.Sprintf("%s", pData.Issue))

		utils.Log.WithFields(logrus.Fields{
			"package":  "process",
			"teststep": tStep.Name,
		}).Debugf("TestStep KO - timeout %s", pData.Issue)

		stateChanged, alertEvent = tStep.setNewStatus(Timeout)

	case AssertFailure:
		utils.Log.WithFields(logrus.Fields{
			"package":  "process",
			"teststep": tStep.Name,
		}).Debugf("TestStep KO - Assertion FAILED")

		stateChanged, alertEvent = tStep.setNewStatus(AssertFailure)

	default:
		utils.Log.WithFields(logrus.Fields{
			"package":  "process",
			"teststep": tStep.Name,
		}).Errorf("TestStep - %s", pData.Status)

		tStep.Failures = append(tStep.Failures, fmt.Sprintf("Error: %s", pData.Issue))
		stateChanged, alertEvent = tStep.setNewStatus(Error)
	}

	utils.Log.WithFields(logrus.Fields{
		"package":  "process",
		"teststep": tStep.Name,
	}).Tracef("Time to complete WriteResult: %v", time.Since(start))

	tStep.Mutex.Unlock()
	return stateChanged, alertEvent
}

// setNewStatus update the status and return a boolean if the state flips
// Before any query, all tests have a "NotDefined" state.
// The return will be true only if there is a change OK <=> ERR but no ND => OK
func (tStep *TestStep) setNewStatus(newStatus StepStatus) (hasChanged, alertEvent bool) {

	// tStep.Mutex.Lock()
	if tStep.Status == newStatus {
		alertEvent = false
		hasChanged = false
	} else {

		hasChanged = true

		// Do not flip a AlertEvent if the status was "NotDefined" and result Success
		if tStep.Status == NotDefined && newStatus == Success {
			alertEvent = false
		} else {
			alertEvent = true
		}

		tStep.Status = newStatus

	}
	// tStep.Mutex.Unlock()

	return hasChanged, alertEvent
}

func (tStep *TestStep) GetStatus() (ss StepStatus) {
	tStep.Mutex.RLock()
	ss = tStep.Status
	tStep.Mutex.RUnlock()
	return ss

}

func (tStep *TestStep) GetLastPositiveResult() (vrs *[]VigieResult) {

	tStep.Mutex.RLock()
	defer tStep.Mutex.RUnlock()

	if tStep.LastPositiveVigieResults == nil {
		return nil
	} else {
		return tStep.LastPositiveVigieResults
	}

}

func (tStep *TestStep) setStatus(ss StepStatus) {
	tStep.Mutex.Lock()
	tStep.Status = ss
	tStep.Mutex.Unlock()

}

func (tStep *TestStep) GetReSyncro() (syncroDelay time.Duration) {

	tStep.Mutex.Lock()
	defer tStep.Mutex.Unlock()

	var nilTime time.Time
	if tStep.LastAttempt == nilTime {
		return 0
	} else {

		nextTimeCheck := tStep.LastAttempt.Add(tStep.ProbeWrap.Frequency)
		x := nextTimeCheck.Sub(time.Now())
		return x
	}

}

// applyChecks apply checks on result, return true if all assertions are Success, false otherwise
func (tStep *TestStep) AssertProbeResult(probeResult *probe.ProbeAnswer) (assertResults []assertion.AssertResult, success bool) {
	tStep.Mutex.RLock()

	utils.Log.WithFields(logrus.Fields{
		"package":  "process",
		"teststep": tStep.Name,
	}).Trace("Asserting test probe result")

	defer utils.Duration(time.Now(), "Teststep Assertion", "process", tStep.Name)

	assertStatus := true
	assertResults = make([]assertion.AssertResult, 0, len(tStep.Assertions))

	// Check de VigieResults against each Assertions
	for i, a := range tStep.Assertions {

		ar := assertion.AssertResult{Assertion: a.AssertConditionsLong()}

		assertion2 := &tStep.Assertions[i]
		_, fails := assertion.ApplyAssert(probeResult, assertion2)
		if fails != "" {
			assertStatus = false
			ar.ResultStatus = 2
			ar.ResultAssert = fails
		} else {
			ar.ResultStatus = 1
			ar.ResultAssert = "ok"
		}

		assertResults = append(assertResults, ar)

	}
	tStep.Mutex.RUnlock()
	return assertResults, assertStatus
}

func (tStep *TestStep) _SetUndefinedAssertRes() {
	tStep.Mutex.Lock()
	for i := range tStep.Assertions {
		assertion2 := &tStep.Assertions[i]

		assertion2.ResultStatus = 3
		assertion2.ResultAssert = ""
	}
	tStep.Mutex.Unlock()

}

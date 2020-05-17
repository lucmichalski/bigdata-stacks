package process

import (
	"github.com/vincoll/vigie/pkg/alertmanager"
	"time"

	"github.com/sirupsen/logrus"

	"github.com/vincoll/vigie/pkg/probe"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/tsdb"
	"github.com/vincoll/vigie/pkg/utils"
)

// ProcessTask runs the teststep then write the result into a DB
func ProcessTask(task teststruct.Task) {

	procData := runTestStep(task.TestStep)

	// WriteResult write probe result into TestStep
	// Then return if the TestStep ResultStatus has changed
	anyStateChange, alertEvent := task.TestStep.WriteResult(procData)
	//task.WriteMetadataChanges(procData.LastAttempt)

	if anyStateChange == true {

		// Update TestSuites and TC state because a change occurred
		updateParentTestStruct(task)

		task.RLockAll()
		if task.TestStep.Status == teststruct.Success {
			utils.Log.WithFields(logrus.Fields{
				"package": "process", "testcase": task.TestCase.Name, "teststep": task.TestStep.Name, "testsuite": task.TestSuite.Name,
			}).Infof("TestStep state has changed to %q.", task.TestStep.Status.String())
		} else {
			utils.Log.WithFields(logrus.Fields{
				"package": "process", "testcase": task.TestCase.Name, "teststep": task.TestStep.Name, "testsuite": task.TestSuite.Name,
			}).Warnf("TestStep state has changed to %q.", task.TestStep.Status.String())

		}
		task.RUnlockAll()

		if alertEvent && alertmanager.AM.IsEnable() {
			_ = alertmanager.AM.AddToAlertList(task)
		}

	}

	if tsdb.TsdbManager.Enable == true {
		// Insert Task ResultStatus to DB
		tsdb.TsdbManager.WriteOnTsdbs(task)
		// UpdateStatus TestSuite and TestCase
		tsdb.TsdbManager.UpdateTestStateToDB(task)
	}
}

// runTestStep runs Probe and Check Assertions (if no timeout or failure)
func runTestStep(tStep *teststruct.TestStep) *teststruct.Processing {

	tStep.Mutex.RLock()
	utils.Log.WithFields(logrus.Fields{
		"package":  "process",
		"teststep": tStep.Name,
	}).Trace("Start test")
	tStep.Mutex.RUnlock()

	// pData to avoid multiple lock / unlock, processing data will be written
	// in tStep at the end.
	var pData teststruct.Processing
	pData.LastAttempt = time.Now()

	// Run the Probe
	probeReturns, issue := runTestStepProbe(&tStep.ProbeWrap)
	if issue != nil {
		// timeout: No Probe results => No need to assert any subtests
		pData.Status = teststruct.Timeout
		pData.Issue = issue.Error()
		return &pData
	}

	// Loop and check on all subtest contained in ProbeAnswer
	// If one of the check fails =>
	// Set the worst case as TestStep Status (Err>timeout>AssertFail>Success)
	//
	// vigieResults contains (VigieResults, AssertionResult, Final Status)
	//

	vigieResults := make([]teststruct.VigieResult, 0, len(probeReturns))

	for _, pr := range probeReturns {
		vr := processProbeResult(tStep, pr)
		vigieResults = append(vigieResults, vr)
	}

	pData.VigieResults = vigieResults
	pData.Status = getFinalResultStatus(vigieResults)

	return &pData
}

// processProbeResult
// Error / timeout ...
// Assertion
func processProbeResult(tStep *teststruct.TestStep, pr probe.ProbeReturn) (vr teststruct.VigieResult) {

	// Add the VigieResults
	vr = teststruct.VigieResult{
		ProbeAnswer: pr.Answer,
		ProbeInfo:   pr.ProbeInfo,
	}

	// Look for any error, to avoid Assertion if not needed
	switch pr.ProbeInfo.Status {

	case probe.Failure:
		// The probe has failed to create or send the request
		// No result to assert => Exit
		vr.Status = teststruct.Failure
		vr.StatusDescription = pr.ProbeInfo.Error
		return vr

	case probe.Error:
		// The probe has encountered a error (can be considered as a desired state)
		prbCode := pr.ProbeInfo.ProbeCode

		vr.Status = teststruct.Error
		vr.StatusDescription = pr.ProbeInfo.Error

		// Despite the error if a probeCode is set, that error can be a desired state
		// eg: Absence of a DNS domain / record (Monitor for Typosquatting)
		if prbCode == 0.0 {
			// Unhandled error: no result to assert properly => Exit
			return vr
		}

	case probe.Timeout:
		// The probe has encountered a timeout
		// no result to assert => Exit
		vr.Status = teststruct.Timeout
		vr.StatusDescription = pr.ProbeInfo.Error
		return vr

	default:
		// Continue with Assertion
	}

	//
	// Assertion
	//
	// Even if Error : Continue and Assert
	// an Error can be the expected result
	// but only Error gracefully handle by the probe

	assertResult, success := tStep.AssertProbeResult(&pr.Answer)
	vr.AssertionResult = assertResult

	// VigieResult after Assertion
	if success == true {
		vr.Status = teststruct.Success
	} else {
		vr.Status = teststruct.AssertFailure
	}

	return vr
}

// getFinalResultStatus compare the VigieResults of one test
// and pick the worst case as Final Status
func getFinalResultStatus(vrs []teststruct.VigieResult) (finalStatus teststruct.StepStatus) {

	/*
		Success       StepStatus = 1
		NotDefined    StepStatus = 0
		AssertFailure StepStatus = -1
		Failure       StepStatus = -2
		Timeout       StepStatus = -3
		Error         StepStatus = -4
	*/

	finalStatus = teststruct.Success

	for _, vr := range vrs {

		if finalStatus == teststruct.Error {
			return teststruct.Error
		}

		if vr.Status < finalStatus {
			finalStatus = vr.Status
		}

	}
	return finalStatus
}

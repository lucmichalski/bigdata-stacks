package teststruct

// countTestStep return the numbers of TestStepsCount in this toTestCase
func (tc *TestCase) countTestStep() (totalTStep int) {
	tc.Mutex.RLock()
	totalTStep = len(tc.TestSteps)
	tc.Mutex.RUnlock()
	return totalTStep
}

// UpdateStatus change and return the TC ResultStatus
// Loop on each TSteps
// If one of the TSteps is KO => Set TC status to False
func (tc *TestCase) UpdateStatus() bool {
	tc.Mutex.Lock()

	for _, tStep := range tc.TestSteps {

		switch tStep.GetStatus() {

		case Success:
			// Pass
		case NotDefined:
			// Neutral => Treated as Success for now
		default:
			tc.Status = Failure
			tc.Mutex.Unlock()
			return false

		}
	}
	// If all TSteps == Success
	tc.Status = Success
	tc.Mutex.Unlock()
	return true
}

/* UpdateStatus TC and returns all the bad TestSteps as Array
func (tc *TestCase) GetAllTStepFailed() (failsTestStep []TStepShort) {
	tc.Mutex.Lock()
	for _, tStep := range tc.TestSteps {
		tStep.Mutex.RLock()
		if tStep.ResultStatus != Success {
			failsTestStep = append(failsTestStep, *tStep.ToHeader())
		}
		tStep.Mutex.RUnlock()
	}
	tc.Mutex.Unlock()
	return failsTestStep
}
*/

func (tc *TestCase) _result() bool {

	for _, tStp := range tc.TestSteps {

		if tStp.Status != Success {
			return false
		}
	}
	return true
}

func (tc *TestCase) _Errors() (count int) {

	for _, tStp := range tc.TestSteps {
		count += len(tStp.Failures)
	}
	return count
}

func (tc *TestCase) _Failures() (count int) {

	for _, tStp := range tc.TestSteps {
		count += len(tStp.Failures)
	}
	return count
}

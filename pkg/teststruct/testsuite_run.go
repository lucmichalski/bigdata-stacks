package teststruct

func (ts *TestSuite) UpdateStatus() {

	ts.Mutex.Lock()
	for _, tc := range ts.TestCases {

		if tc.GetStatus() == Failure {
			ts.Status = Failure
			ts.Mutex.Unlock()
			return
		}
	}
	ts.Status = Success
	ts.Mutex.Unlock()
	return
}

func (ts *TestSuite) SetStatus(status StepStatus) {
	ts.Mutex.Lock()
	ts.Status = status
	ts.Mutex.Unlock()
}

func (ts *TestSuite) isSuccess() bool {
	ts.Mutex.RLock()
	defer ts.Mutex.RUnlock()
	for _, tc := range ts.TestCases {
		tc.Mutex.RLock()
		//if tc.Details() > 0 || tc.Details() > 0 {
		if tc.Status != Success {
			tc.Mutex.RUnlock()
			return false
		}
		tc.Mutex.RUnlock()
	}
	return true
}

func (ts *TestSuite) Failures() (count int) {
	ts.Mutex.RLock()
	for _, tc := range ts.TestCases {
		tc.Mutex.RLock()
		count += tc.FailureCount()
		tc.Mutex.RUnlock()
	}
	ts.Mutex.RUnlock()
	return count
}

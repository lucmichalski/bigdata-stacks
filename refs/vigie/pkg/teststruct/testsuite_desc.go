package teststruct

type TSDescribe struct {
	//	Errors         int          `json:"errors"`
	Status string `json:"status"`
	//	Failures       int          `json:"failures"`
	Name string `json:"name"`
	ID   uint64 `json:"id"`
	//	TestCaseCount  int          `json:"testcasescount"`
	//	TestStepsCount int          `json:"teststepscount"`
	TestCases []TCDescribe `json:"testcases"`
}

func (ts *TestSuite) ToJSON() TSDescribe {

	ts.Mutex.RLock()

	var TSDesc TSDescribe

	TSDesc.TestCases = make([]TCDescribe, 0, len(ts.TestCases))
	for _, tc := range ts.TestCases {
		//	TSDesc.TestStepsCount += tc.countTestStep()
		tsD := tc.ToJSON()
		TSDesc.TestCases = append(TSDesc.TestCases, tsD)
	}

	TSDesc.Name = ts.Name
	TSDesc.ID = ts.ID
	// TSDesc.TestCaseCount = len(ts.TestCases)
	// TSDesc.Failures = ts.Failures()
	TSDesc.Status = ts.Status.String()

	ts.Mutex.RUnlock()

	return TSDesc
}

type TSHeader struct {
	ID     uint64 `json:"id"`
	Name   string `json:"name"`
	Status string `json:"status"`
}

func (ts *TestSuite) ToHeader() TSHeader {

	ts.Mutex.RLock()

	hts := TSHeader{
		Name:   ts.Name,
		ID:     ts.ID,
		Status: ts.Status.String(),
	}

	ts.Mutex.RUnlock()

	return hts

}

type TSAlertShort struct {
	TSHeader
	TestCases map[uint64]TCAlertShort `json:"testcases"`
}

func (ts *TestSuite) ToAlertShortTSRec() TSAlertShort {

	htc := ts.ToHeader()

	AsTC := TSAlertShort{
		TSHeader:  htc,
		TestCases: nil,
	}

	return AsTC
}

func (ts *TestSuite) ToAlertShortTS() TSAlertShort {

	htc := ts.ToHeader()

	TCAlerts := make(map[uint64]TCAlertShort, 0)

	AsTC := TSAlertShort{
		TSHeader:  htc,
		TestCases: TCAlerts,
	}

	/*
		ts.Mutex.RLock()
		for _, tc := range ts.TestCases {
			TCAlerts = append(TCAlerts, tc.ToAlertShortTC())
		}
		ts.Mutex.RUnlock()
	*/
	return AsTC
}

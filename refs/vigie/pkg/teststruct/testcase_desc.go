package teststruct

type TCHeader struct {
	ID     uint64 `json:"id"`
	Name   string `json:"name"`
	Status string `json:"status"`
}

type TCAlertShort struct {
	TCHeader
	TestSteps map[uint64]TStepAlertShort `json:"teststeps"`
}

type TCDescribe struct {
	ID uint64 `json:"id"`
	// Errors    int             `json:"errors"`
	Status string `json:"status"`
	// Failures  int             `json:"failures"`
	Name      string          `json:"name"`
	TestSteps []TStepDescribe `json:"teststeps"`
}

func (tc *TestCase) ToHeader() TCHeader {

	tc.Mutex.RLock()

	htc := TCHeader{
		ID:     tc.ID,
		Name:   tc.Name,
		Status: tc.Status.String(),
	}

	tc.Mutex.RUnlock()

	return htc
}

func (tc *TestCase) ToJSON() TCDescribe {

	var TCDesc TCDescribe
	TCDesc.TestSteps = make([]TStepDescribe, 0)
	tc.Mutex.RLock()
	TCDesc.Name = tc.Name
	TCDesc.Status = tc.Status.String()

	for _, tStp := range tc.TestSteps {

		tStpD := tStp.ToTestStepDescribe()
		TCDesc.TestSteps = append(TCDesc.TestSteps, tStpD)
	}
	tc.Mutex.RUnlock()
	return TCDesc
}

func (tc *TestCase) ToAlertShortTC() TCAlertShort {

	htc := TCHeader{
		ID:     tc.ID,
		Name:   tc.Name,
		Status: tc.Status.String(),
	}

	AsTC := TCAlertShort{
		TCHeader:  htc,
		TestSteps: make(map[uint64]TStepAlertShort, 0),
	}

	return AsTC
}

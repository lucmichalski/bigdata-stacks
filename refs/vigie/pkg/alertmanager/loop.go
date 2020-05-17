package alertmanager

import (
	"github.com/sirupsen/logrus"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/utils"
	"time"
)

// run will run all the tasks on each ticking
func (am *AlertManager) run() {

	for {
		select {
		case <-am.ticker.C:

			utils.Log.WithFields(logrus.Fields{
				"package": "alerting",
			}).Infof("Tick Alerting.")

			if am.anyChange() {

				utils.Log.WithFields(logrus.Fields{
					"package": "alerting",
				}).Infof("Tick Alerting Process.")

				tam := am.processAlertList()
				am.sendHooks(tam, normal)
			}
		case <-am.reminder.C:
			// Always send a reminder (dead men switch)
			tam := am.processAlertList()
			am.sendHooks(tam, reminder)
		}
	}
}

// Generate a Recap of each TestX
func (am *AlertManager) processAlertList() *teststruct.TotalAlertMessage {

	am.RLock()

	alrtsTS := make(map[uint64]teststruct.TSAlertShort, len(am.alrtList.Testsuites))

	alertMessages := teststruct.TotalAlertMessage{
		Date: time.Now(),
	}

	for _, ts := range am.alrtList.Testsuites {

		ats := ts.ToAlertShortTS()
		ats.TestCases = make(map[uint64]teststruct.TCAlertShort, len(am.alrtList.Testsuites[ts.ID].TestCases))

		for _, tc := range am.alrtList.Testsuites[ts.ID].TestCases {

			ats.TestCases[tc.ID] = tc.ToAlertShortTC()

			//x := make(map[int64]teststruct.TStepAlertShort, len(am.alrtList.Testsuites[ts.ID].TestCases[tc.ID].TestSteps))
			//ats.TestCases[tc.ID].TestSteps = x

			for _, tstp := range am.alrtList.Testsuites[ts.ID].TestCases[tc.ID].TestSteps {

				ats.TestCases[tc.ID].TestSteps[tstp.ID] = tstp.ToStepAlertShort()

			}

		}

		alrtsTS[ts.ID] = ats
	}

	am.RUnlock()

	alertMessages.TestSuites = alrtsTS

	return &alertMessages
}

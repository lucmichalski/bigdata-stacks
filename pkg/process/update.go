package process

import (
	"github.com/vincoll/vigie/pkg/teststruct"
)

// updateParentTestStruct permet de rafraichir l'état de Structures (TestSuites,TC)
// Ce changement d'état est du à un changement d'état d'une TStep
func updateParentTestStruct(task teststruct.Task) {

	if task.TestStep.GetStatus() != teststruct.Success {

		// If one tStep is KO => Parents are KO too
		task.TestCase.SetStatus(teststruct.Failure)
		task.TestSuite.SetStatus(teststruct.Failure)
		return
	} else {
		// Success => Update TC (check if there is any teststep KO left in TC)
		// UpdateStatus TC
		statusTC := task.TestCase.UpdateStatus()
		// UpdateStatus TestSuites
		if statusTC == false {
			// TC ResultStatus is False then
			// TestSuite is set to false immediately
			task.TestSuite.SetStatus(teststruct.Failure)
		} else {
			// This precise TestCase is OK,
			// But we need to check the others TCs in this TestSuites
			// to check if at least one of the TCs remains KO
			task.TestSuite.UpdateStatus()
		}
	}

}

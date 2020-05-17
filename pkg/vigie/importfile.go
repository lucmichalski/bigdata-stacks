package vigie

import (
	log "github.com/sirupsen/logrus"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/utils"
	"time"
)

// loadEverything, but keep current state
// 1- Load TestFiles
// 2- Prepare Tickers
func (v *Vigie) loadEverything() error {

	// Read and Initialize TestSuites Files
	// Unmarshall append here
	start := time.Now()
	// Importing Files in Vigie
	utils.Log.WithFields(log.Fields{
		"package": "vigie",
		"role":    "load testsuite and generate scheduling",
	}).Info("(Re)Load Testsuite and generate scheduling")

	newTSs, err := v.ImportManager.LoadTestSuites()
	if err != nil {
		return err
	} else {
		utils.Log.WithFields(log.Fields{
			"package": "vigie",
			"role":    "load Testsuite and generate scheduling",
		}).Debug("All the TestFiles have been unmarshalled with success")
	}

	// LOCK Vigie
	v.mu.Lock()
	defer v.mu.Unlock()

	start = time.Now()
	//
	// Import a new set of Testsuites
	//
	importedTS, anyChanges := v.ImportAllTestSuites(newTSs)
	if anyChanges == false {
		// No changes, no need to swap, keep the Vigie state as it is
		utils.Log.WithFields(log.Fields{
			"package": "vigie",
			"desc":    "load Testsuite and generate scheduling",
			"type":    "info",
		}).Debugf("No changes detected")

		return nil
	}
	//
	// Create new TickerPools
	//
	TPools := v.createTickerPools(importedTS)
	//utils.Log.Debug("New Tickerpool generated")

	elapsed := time.Since(start)
	utils.Log.WithFields(log.Fields{
		"package": "vigie",
		"desc":    "load Testsuite and generate scheduling",
		"type":    "perf_measurement",
		"value":   elapsed.Seconds(),
	}).Debugf("TOTAL Load Testsuite and generate scheduling duration: %s", elapsed)

	// Now that TS and TickerPools are set, we need to
	// swap the old and running Vigie state by the new state.

	v.swapState(importedTS, TPools)

	return nil
}

// ImportAllTestCases will add new TCs, remove oldTC that are absent from the new TCs, keep common TCs
func (v *Vigie) ImportAllTestSuites(newTSs map[uint64]*teststruct.TestSuite) (TSs map[uint64]*teststruct.TestSuite, anyChanges bool) {

	// Compilation to avoid multiples loops
	newStateTS := make(map[string]uint64, 0)
	for _, nts := range newTSs {
		newStateTS[nts.Name] = nts.ID
	}

	// UPDATE
	for _, oTS := range v.TestSuites {
		// If old TC name is in newTCs
		if nTSid, alreadyExists := newStateTS[oTS.Name]; alreadyExists {
			// Name exists, but have they the same ID(hash) ?
			if oTS.ID != nTSid {
				// Name is identical to an existing TC, but ID is different.
				// That means that the old import have changed. And so TSteps.
				// The full old TestCase state is keep, but we need to go deeper to update this TestCase.
				anyChanges = true
				newTSs[nTSid].ImportAllTestCases(oTS.TestCases)
			} else {
				// Name and ID are identical = No Changes > replace newTS by "OldTS" to keep the state
				newTSs[nTSid] = oTS
			}
		}
	}
	return newTSs, anyChanges
}

// addTestSuite simply  add a TestSuite into Vigie, no checks concurency safe
func (v *Vigie) addTestSuite(newTS *teststruct.TestSuite) {

	v.mu.Lock()
	v.TestSuites[newTS.ID] = newTS
	v.mu.Unlock()

}

// removeTestSuite simply removes a TestSuite from Vigie, concurency safe
func (v *Vigie) removeTestSuite(ID uint64) {

	v.mu.Lock()
	delete(v.TestSuites, ID)
	v.mu.Unlock()

}

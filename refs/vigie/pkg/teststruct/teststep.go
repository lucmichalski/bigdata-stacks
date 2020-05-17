package teststruct

import (
	"fmt"
	"github.com/mitchellh/hashstructure"
	"reflect"
	"regexp"
	"sync"
	"time"

	"github.com/vincoll/vigie/pkg/probe/probetable"

	"github.com/vincoll/vigie/pkg/assertion"
	"github.com/vincoll/vigie/pkg/probe"
)

// Step represents a Step
type Step map[string]interface{}

type JSONStep struct {
	Name       string                 `json:"name"`
	Config     configTestStructJson   `json:"config"`
	Probe      map[string]interface{} `json:"probe"`
	Assertions []string               `json:"assertions"`
	Loop       []string               `json:"loop"`
}

// TestStep est constitué d'une Step ainsi que d'autres objets permettant l'exec et la traçabilité
type TestStep struct {
	Mutex                    sync.RWMutex `hash:"ignore"`
	Name                     string
	ID                       uint64 `hash:"ignore"`
	Assertions               []assertion.Assert
	ProbeWrap                ProbeWrap
	Failures                 []string       `hash:"ignore"`
	LastAttempt              time.Time      `hash:"ignore"`
	LastChange               time.Time      `hash:"ignore"`
	LastPositiveTimeResult   time.Time      `hash:"ignore"`
	VigieResults             []VigieResult  `hash:"ignore"`
	LastPositiveVigieResults *[]VigieResult `hash:"ignore"`
	Status                   StepStatus     `hash:"ignore"`
}

// TestStepComparaison is use to compare a teststep, it only contains
// fixed values.
type TestStepComparaison struct {
	Name       string
	Assertions []assertion.Assert
	ProbeWrap  ProbeWrap
}

func (jstp JSONStep) toTestStep(ctsTC *configTestStruct, tsVars map[string][]string) ([]TestStep, error) {

	testSteps := make([]TestStep, 0)

	// Config
	// UnMarshall spécifique de la config avec conversion de strings type (1d,7m) en time.duration
	ctsStep, err := unmarshallConfigTestStruct(jstp.Config)
	if err != nil {
		return []TestStep{}, fmt.Errorf("config declaration: %s", err)
	}

	// Assertions
	assertions, errAsrt := assertion.GetCleanAsserts(jstp.Assertions)
	if errAsrt != nil {
		return []TestStep{}, fmt.Errorf("Invalid step assertion %s :", errAsrt)
	}

	// Replace Var if present in the probe section
	probeWraps, errVars := loop(jstp.Probe, jstp.Loop, tsVars)

	if errVars != nil {
		return []TestStep{}, fmt.Errorf("Invalid Loop in step: %s :", errVars)
	}

	for _, pw := range probeWraps {

		var tstep TestStep

		tstep.ProbeWrap = pw
		// A Slice is composed with pointers.
		// Can't share the same assertion object.
		// Copy is mandatory, assertion struct will be modified later.
		copyAssert := make([]assertion.Assert, 0, len(assertions))
		copyAssert = append(copyAssert[:0:0], assertions...)
		tstep.Assertions = copyAssert

		// Name
		if jstp.Name == "" {

			tstep.Name = tstep.ProbeWrap.Probe.GenerateTStepName()

		} else {

			if jstp.Loop != nil {
				// Generate a unique name for each looped variables
				genTstpName := tstep.ProbeWrap.Probe.GenerateTStepName()
				tstep.Name = fmt.Sprintf("%s (%s)", jstp.Name, genTstpName)

			} else {
				tstep.Name = jstp.Name
			}
		}

		// Import Config TestSruct into ProbeWrap
		errImpCts := tstep.importConfig(&ctsStep)
		if errImpCts != nil {
			return []TestStep{}, fmt.Errorf("Import Config TestSruct into ProbeWrap: %s :", errImpCts)

		}

		// Import Config TC TestSruct into ProbeWrap
		errImpTcCts := tstep.importConfig(ctsTC)
		if errImpTcCts != nil {
			return []TestStep{}, fmt.Errorf("Import Config TC TestSruct into ProbeWrap: %s :", errImpTcCts)

		}

		errVWrap := tstep.validateWrapProbe()
		if errVWrap != nil {
			return []TestStep{}, fmt.Errorf("step %q is invalid: %s", tstep.Name, errVWrap)
		}

		// The teststep generation is now done: teststep.ID is a hash of this teststep
		// It will be easier to compare this teststep later if changes occurs.
		tstep.ID, err = hashstructure.Hash(tstep, nil)
		if err != nil {
			panic(err)
		}

		testSteps = append(testSteps, tstep)

	}
	return testSteps, nil

}

func loop(stepProbe map[string]interface{}, loop []string, vars map[string][]string) (pws []ProbeWrap, err error) {

	if len(loop) == 0 {
		pw, err := wrapProbe(stepProbe)
		if err != nil {
			return []ProbeWrap{}, fmt.Errorf("%s", err)
		}
		pws = append(pws, pw)
		return pws, nil
	}
	var findItem bool
	var r = regexp.MustCompile(`(\B\$)(.+)`)
	for k, v := range stepProbe {
		// Detect if TestSuites value (interface) is a string or not
		//	if strv, ok := v.(string); ok {
		// If TestSuites value is matching {{_}} regex (ex: {{varX}} )
		strv := fmt.Sprintf("%v", v)
		if strv == "$item" {
			findItem = true
			for _, itm := range loop {
				// if variable pattern $*
				if r.MatchString(itm) {
					x := r.FindStringSubmatch(itm)
					y := x[len(x)-1] // y = foo from $foo
					// Looking for if foo exists in vigie's vars
					if valvigie, present := vars[y]; present {
						// For each oh them create/add a new ProbeWrap
						for _, val := range valvigie {
							stepProbe[k] = val
							pw, err := wrapProbe(stepProbe)
							if err != nil {
								return []ProbeWrap{}, fmt.Errorf("%s", err)
							}
							pws = append(pws, pw)

						}
					} else {
						// Vars pattern find, but not the vars does not exists.
						return []ProbeWrap{}, fmt.Errorf("vars does not exists %q", y)
					}
				} else {
					stepProbe[k] = itm
					pw, err := wrapProbe(stepProbe)
					if err != nil {
						return []ProbeWrap{}, fmt.Errorf("%s", err)
					}
					pws = append(pws, pw)
				}
			} // for val in Loop variable

		} // if $item

	} // Loop looking for $item
	if findItem == false {
		// No $item found despite the len(loop) > 0
		// return nil, fmt.Errorf("No var $item found, despite len(loop) >= 1 TODO") //TODO
		// Simply add without edit
		pw, err := wrapProbe(stepProbe)
		if err != nil {
			return []ProbeWrap{}, fmt.Errorf("%s", err)
		}
		pws = append(pws, pw)
	}

	return pws, nil

}

// probeType returns the name of the executor which is set to run this TestStep
// Is simply a shortcut for tStep.ProbeWrap.Probe.GetName()
func (tStep *TestStep) probeType() string {
	return tStep.ProbeWrap.Probe.GetName()
}

// responsetime return the duration time between the last call and the received response
// time is in second
func (tStep *TestStep) ResponseTimeInflux() float64 {

	tStep.Mutex.RLock()
	rt, _ := tStep.VigieResults[0].ProbeAnswer["probeinfo"]
	x, _ := rt.(map[string]interface{})
	rt = x["responsetime"]
	tStep.Mutex.RUnlock()

	var f float64
	switch v := rt.(type) {
	case float64:
		f = float64(v)
	case int:
		f = float64(v)
	case nil:
		return float64(Error)
	default:
		return float64(Error)
	}
	return f
}

// wrapProbe initializes a test by name
func wrapProbe(stepProbe map[string]interface{}) (pw ProbeWrap, err error) {

	var probeType string

	// Check if "type" Exists
	if itype, ok := stepProbe["type"]; ok {
		probeType = fmt.Sprintf("%s", itype)
	} else {
		return pw, fmt.Errorf("probe type is missing in a Step")
	}

	/// ---------------
	// xxx := utils.MapInterfacetoString(stepProbe)
	// ---------------

	// Check if Exec Exists & Create Probe Object
	if e, ok := probetable.AvailableProbes[probeType]; ok {

		// TODO : Clean this mess : Avoid reflection
		//https://groups.google.com/forum/#!topic/golang-nuts/1hWgUhXBBTU
		// http://play.golang.org/p/xInaAl3rkE
		var xProbe probe.Probe
		indirect := reflect.Indirect(reflect.ValueOf(e))
		newIndirect := reflect.New(indirect.Type())
		newIndirect.Elem().Set(reflect.ValueOf(indirect.Interface()))
		newNamed := newIndirect.Interface()
		casted := newNamed.(probe.Probe)
		xProbe = casted

		// Initialize TStep values against the own Probe needs
		// Initialize is different for each probe
		// Apply Step values to the Probe
		err = xProbe.Initialize(stepProbe)
		if err != nil {
			return pw, fmt.Errorf("probe %q can't import this step: %s", xProbe.GetName(), err)
		}

		pw = ProbeWrap{Probe: xProbe}

		return pw, nil

	} else {
		return pw, fmt.Errorf("probe type %q is not implemented in Vigie", probeType)
	}
}

// importConfig replace config from a cfg only if non-present in the ProbeWrap
func (tStep *TestStep) importConfig(cfg *configTestStruct) error {
	if tStep.ProbeWrap.Frequency == 0 {
		tStep.ProbeWrap.Frequency = cfg.Frequency[tStep.probeType()]
	}

	if tStep.ProbeWrap.Retry == 0 {
		tStep.ProbeWrap.Retry = cfg.Retry[tStep.probeType()]
	}

	if tStep.ProbeWrap.Retrydelay == 0 {
		tStep.ProbeWrap.Retrydelay = cfg.Retrydelay[tStep.probeType()]
	}

	if tStep.ProbeWrap.Timeout == 0 {
		tStep.ProbeWrap.Timeout = cfg.Timeout[tStep.probeType()]
	}
	return nil

}

// validateWrapProbe validate user values,
// if a value is empty or 0 (eg: Timeout)
// the value will be set to the specific value of the probe.
func (tStep *TestStep) validateWrapProbe() error {

	if tStep.ProbeWrap.Frequency == 0 {
		tStep.ProbeWrap.Timeout = tStep.ProbeWrap.Probe.GetDefaultFrequency()
	}

	if tStep.ProbeWrap.Frequency < time.Millisecond {
		return fmt.Errorf("frequency MUST be >= 1ms")
	}

	if tStep.ProbeWrap.Timeout == 0 {
		tStep.ProbeWrap.Timeout = tStep.ProbeWrap.Probe.GetDefaultTimeout()
	}

	return nil
}

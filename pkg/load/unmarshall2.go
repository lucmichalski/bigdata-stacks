package load

import (
	"encoding/json"
	"fmt"
	"github.com/ghodss/yaml"
	"github.com/sirupsen/logrus"
	"github.com/vincoll/vigie/pkg/probe"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/utils"
	"io/ioutil"
	"path/filepath"
)

type unMarshallTool struct {
	Variables map[string][]string
	Probes    map[string]probe.Probe // Probe (Interface)
}

func NewUnMarshallTool(varPaths []string, probelist map[string]probe.Probe) (*unMarshallTool, error) {
	umt := unMarshallTool{
		Variables: map[string][]string{},
		Probes:    probelist,
	}

	// ConfImport Variables from var Paths
	err := umt.importVariables(varPaths)
	if err != nil {
		return nil, err
	}

	// Global VAR
	utils.ALLVARS = umt.Variables

	return &umt, nil
}

// ImportAllTestSuites returns a TestSuite Vigie Struct
// ImportAllTestSuites unMarshall, apply any variables, validate data
// on each sub TestSuite sub-element (TestCase and TestStep)
func (umt *unMarshallTool) ImportTestSuite(tsFile string) (*teststruct.TestSuite, error) {

	// ConfImport TestSuites and Raw TC,TStep
	ts, err := umt.unmarshalTestSuiteFile(tsFile)
	if err != nil {
		return nil, fmt.Errorf("cannot unmarshall %q: %s", tsFile, err.Error())
	}

	return ts, nil
}

func (umt *unMarshallTool) unmarshalTestSuiteFile(file string) (*teststruct.TestSuite, error) {

	dat, err := ioutil.ReadFile(file)
	if err != nil {
		return nil, fmt.Errorf("Err %s while reading file", err)
	}

	ts := teststruct.TestSuite{}
	// Switch : UnMarshal YAML / JSON
	switch ext := filepath.Ext(file); ext {
	case ".yaml", ".yml":
		// Conversion est necessaire afin d'utiliser l interface UnmarshalJSON propre à Go
		jdat, err := yaml.YAMLToJSON(dat)
		if err != nil {
			return nil, fmt.Errorf("Err %s while converting YAML to JSON", err)
		}
		err = json.Unmarshal(jdat, &ts)
		if err != nil {
			return nil, fmt.Errorf("Cannot while unmarshal this file. Err: %v", err)
		}

	case ".json":
		// L'unMarshall d'une testsuite et de tout les éléments sous jacents
		// utilise une interface UnmarshalJSON afin d'init spécialiser l'objet fils en fonction du pére.
		err = json.Unmarshal(dat, &ts)
		if err != nil {
			return nil, fmt.Errorf("Cannot while unmarshal this file. Err: %v", err)
		}

	default:
		return nil, fmt.Errorf("Unsupported TestSuite file extension: %q", ext)
	}

	return &ts, nil

}

func (umt *unMarshallTool) importVariables(varPaths []string) error {

	for _, varFile := range varPaths {

		varFileMap := make(map[string][]string)
		bytes, err := ioutil.ReadFile(varFile)
		if err != nil {
			utils.Log.WithFields(logrus.Fields{}).Fatalf(err.Error())
		}

		switch filepath.Ext(varFile) {
		case ".json":
			err = json.Unmarshal(bytes, &varFileMap)
		case ".yaml", ".yml":
			err = yaml.Unmarshal(bytes, &varFileMap)
		default:
			//		log.Fatal("unsupported varFile format")
		}
		if err != nil {
			utils.Log.WithFields(logrus.Fields{}).Fatalf(err.Error())

		}

		for key, value := range varFileMap {
			(umt.Variables)[key] = value
		}
	}
	return nil

}

package assertion

import (
	"encoding/json"
	"fmt"
	"sort"
	"strconv"
	"time"

	"github.com/vincoll/vigie/pkg/probe"
	"github.com/vincoll/vigie/pkg/utils"
)

type AssertionsApplied struct {
	Ok       bool
	Failures []string
}

type Assert struct {
	Key          string       // Key in wich to pick the value from a probe result
	Method       AssertMethod // Assert method (equal, sup, contains ...)
	Value        interface{}  // value to assert
	Values       []string     // values to assert
	ResultStatus int8         //TODO: à typer en teststruct.Status like
	ResultAssert string       // ok, or assert fail msg
}

type AssertResult struct {
	Assertion    string
	ResultStatus int8   //TODO: à typer en teststruct.Status like
	ResultAssert string // ok, or assert fail msg
}

type AssertShortJSON struct {
	Key    string `json:"key"`
	Method string `json:"method"`
	Value  string `json:"value"`
}

type AssertDesc struct {
	LongAssert   string `json:"assertion"`
	ResultStatus int8   `json:"resultstatus"`
	ResultAssert string `json:"resultassert"`
}

// ToAssertJSON returns a struct with content easily readable
func (a Assert) ToAssertJSON() *AssertShortJSON {

	assertjson := &AssertShortJSON{
		Key:    a.Key,
		Method: a.Method.LongName,
	}

	if a.Values == nil {
		assertjson.Value = fmt.Sprintf("%v", a.Value)
	} else {
		jsonValues, _ := json.Marshal(a.Values)
		assertjson.Value = string(jsonValues)
	}

	return assertjson
}

func (a Assert) ToAssertDesc() AssertDesc {

	return AssertDesc{
		LongAssert:   a.AssertConditionsLong(),
		ResultStatus: a.ResultStatus,
		ResultAssert: a.ResultAssert,
	}

}

func (a Assert) AssertConditionsLong() string {

	if a.Values == nil {
		return fmt.Sprintf("%s %s %v", a.Key, a.Method.LongName, a.Value)
	} else {
		jsonValues, _ := json.Marshal(a.Values)
		return fmt.Sprintf("%s %s %s", a.Key, a.Method.LongName, string(jsonValues))
	}

}

// ApplyAssert find the corresponding value to assert in probeAnswer
// then asserts the probe value with the expected value.
func ApplyAssert(probeAnswer *probe.ProbeAnswer, tAssert *Assert) (assertRes bool, failCause string) {

	// Looking for the key value assertion in the probe result
	probeValueToAssert, found := browse(tAssert.Key, *probeAnswer)
	if !found {
		return false, fmt.Sprintf("key '%q' does not exist in result of probe: %+v", tAssert.Key, probeAnswer)
	}

	probValueFmt, probValuesFmt := formatProbeVal(probeValueToAssert, tAssert)

	// Assertion de Probe ResultValue sur l'attendu
	_, assertResult := tAssert.Method.AssertFunc(probValueFmt, probValuesFmt, tAssert.Value, tAssert.Values)
	if assertResult != "" {
		var failCause string
		if tAssert.Method.IsDuration {
			// If Duration, the formating need precise
			numActualVal, _ := utils.GetFloat(probValueFmt)
			failCause = fmt.Sprintf("assertion '%s' failed: probe result is '%s'", tAssert.AssertConditionsLong(), time.Duration(numActualVal))

		} else {
			failCause = fmt.Sprintf("assertion '%s' failed: probe result is '%v'", tAssert.AssertConditionsLong(), probValueFmt)
		}
		return false, failCause
	}
	return true, ""
}

func formatProbeVal(probeValue string, tAssert *Assert) (value interface{}, values []string) {

	// Define the input (String, Array, Nested Array)
	// String
	if utils.IsJSONString(probeValue) {
		// Simple String
		// Simple Array
		err := json.Unmarshal([]byte(probeValue), &value)
		if err != nil {
			panic(err)
		}

		return value, nil
	}

	// Float64
	// Numerical
	if utils.IsNumeric(probeValue) {
		num, _ := strconv.ParseFloat(probeValue, 64)
		return num, nil
	}

	if utils.IsBool(probeValue) {
		return fmt.Sprint(probeValue), nil
	}

	// Array
	if utils.IsArray(probeValue) && !utils.IsNestedArray(probeValue) {

		var fmtProbeValues []string

		// Simple Array
		err := json.Unmarshal([]byte(probeValue), &fmtProbeValues)
		if err != nil {
			panic(err)
		}

		if tAssert.Method.IsEqualType && !tAssert.Method.IsOrdered {
			sort.Strings(fmtProbeValues)
		}
		// Is an Array
		return nil, fmtProbeValues
	}

	// Nested Array
	if utils.IsNestedArray(probeValue) && utils.IsArray(probeValue) {

		// TODO: NestedArray

		/*	err := json.Unmarshal([]byte(v), &aNestedArrayValue)
			if err != nil {
				panic(err)
			}
		*/

	}

	return nil, nil
}

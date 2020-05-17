package assertion

import (
	"encoding/json"
	"fmt"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/vincoll/vigie/pkg/utils"
)

// GetCleanAsserts returns a structured TestStep Assertion Slice
// from raw assert string.
// this assertion slice has been validate.
func GetCleanAsserts(rawAsserts []string) ([]Assert, error) {

	nAssertions := make([]Assert, 0, len(rawAsserts))

	for _, rawAssert := range rawAsserts {
		// initAssert format les assertions sous forme d'une simple liste aisement traitable par la suite

		nAssert, err := initAssert(rawAssert)
		if err != nil {
			return nil, fmt.Errorf("cannot import assertion : %s", err)
		}
		for _, asrt := range nAssert {
			nAssertions = append(nAssertions, asrt)
		}
	}

	return nAssertions, nil
}

// Fonctionement moyen, conversion à chier : va falloir trancher dans les régles d'import des Assertions !
func initAssert(rawAssert string) ([]Assert, error) {

	// Split the Assertion
	a := strings.SplitN(rawAssert, " ", 3)
	if len(a) != 3 {
		return nil, fmt.Errorf("invalid assertion format %q len:%d, should be consists of 3 parts: Key Verb MultiValue(as json format)", rawAssert, len(rawAssert))
	}
	// Init Variables
	// Parsing
	aKey := a[0]
	aVerb := a[1]
	aVal := a[2:][0]

	// Init of Assert struct
	aStrValue := ""
	aArrayValue := make([]string, 0)
	aNestedArrayValue := make([][]string, 0)
	allAsserts := make([]Assert, 0)

	asrt := Assert{
		Key: aKey,
	}

	// Initialize aVerb
	assertMethod, err := detectAssertMethod(aVerb)
	if err != nil {
		return nil, err
	}
	asrt.Method = *assertMethod

	switch {

	// Define the input (String, Array, Nested Array)
	// String
	case utils.IsJSONString(aVal):
		{
			// Simple String
			err := json.Unmarshal([]byte(aVal), &aStrValue)
			if err != nil {
				panic(err)
			}

			// Faut-il re switch dans le cas ou l'utilisateur présente sciemment des strings ??
			if utils.IsDuration(aStrValue) {
				asrt.Value, _ = time.ParseDuration(aStrValue)
			} else {
				asrt.Value = aStrValue
			}
			allAsserts = append(allAsserts, asrt)
			return allAsserts, nil
		}

		// Avoid to double quote boolean value (true,false)
	case utils.IsBool(aVal):
		{
			asrt.Value = fmt.Sprint(aVal)
			allAsserts = append(allAsserts, asrt)
			return allAsserts, nil
		}

	case utils.IsDuration(aVal):
		{
			asrt.Value, _ = time.ParseDuration(aVal)
			// Add type hint for assert printing (1s, 20ms format)
			asrt.Method.IsDuration = true
			allAsserts = append(allAsserts, asrt)
			return allAsserts, nil
		}

		// Numerical
	case utils.IsNumeric(aVal):
		{
			asrt.Value, _ = strconv.ParseFloat(aVal, 64)
			allAsserts = append(allAsserts, asrt)
			return allAsserts, nil
		}

		// Array
	case utils.IsArray(aVal) && !utils.IsNestedArray(aVal):
		{

			// Simple Array
			err := json.Unmarshal([]byte(aVal), &aArrayValue)
			if err != nil {
				panic(err)
			}

			// Only if CONTAINS Assert Funct:
			// Create a single Assert for each
			// Ex: if the input is answer $$ [1,2,3]
			// This will be "convert" as if the input was:
			// answer $$ 1 ; answer $$ 2 ; answer $$ 3
			if asrt.Method.IsContainType {

				for _, a := range aArrayValue {
					asrt.Value = a
					allAsserts = append(allAsserts, asrt)
				}
				return allAsserts, nil
			}

			// EQUAL
			if asrt.Method.IsEqualType {

				if !asrt.Method.IsOrdered {
					// If Equal, but order doesn't matter:
					// Sort here, the Probe result
					// will also be shorted before the assertion
					sort.Strings(aArrayValue)
				}
				asrt.Values = aArrayValue
				allAsserts = append(allAsserts, asrt)
				return allAsserts, nil
			}
		}
		// Nested Array
	case utils.IsNestedArray(aVal) && utils.IsArray(aVal):
		{
			// Nested Array
			err := json.Unmarshal([]byte(aVal), &aNestedArrayValue)
			if err != nil {
				panic(err)
			}

			// TODO : Nested Array

		}

	default:

		// Simple String
		err := json.Unmarshal([]byte(aVal), &aStrValue)
		if err != nil {
			return nil, fmt.Errorf("Cannot unmarshall %q: %s", aVal, err)
		}
		asrt.Value = aStrValue
		allAsserts = append(allAsserts, asrt)
		return allAsserts, nil

		//	return nil, fmt.Errorf("Cannot determine structure type of: %s", aVal)
	}

	return allAsserts, nil
}

// detectAssertMethod return the AssertMethod from any identifier
// Longname: Equal || ShortName: "EQ" || Symbol: "=="
func detectAssertMethod(s string) (*AssertMethod, error) {

	for _, am := range NewAliasAsserts {
		switch s {
		case am.Symbol:
			return am, nil
		case am.ShortName:
			return am, nil
		case am.LongName:
			return am, nil
		}
	}
	return nil, fmt.Errorf("assertion method not found '%s'", s)
}

package assertion

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"
	"unicode"
	"unicode/utf8"

	"github.com/smartystreets/assertions"
	"github.com/tidwall/gjson"
)

func browse(path string, executorResult map[string]interface{}) (string, bool) {

	// TODO: Changer de Méthode: le fonctionement actuel est Overkill
	//  (transformer un object en json pour JQ dedans)
	blob, _ := json.Marshal(executorResult)
	value := gjson.Get(string(blob), path)

	if value.Raw == "" {
		return "", false
	}

	return value.Raw, true
}

// shouldContainSubstring receives exactly more than 2 string parameters and ensures that the first contains the second as a substring.
func shouldContainSubstring(actual interface{}, expected ...interface{}) string {
	if len(expected) == 1 {
		return assertions.ShouldContainSubstring(actual, expected...)
	}

	var arg string
	for _, e := range expected {
		arg += fmt.Sprintf("%v ", e)
	}
	return assertions.ShouldContainSubstring(actual, strings.TrimSpace(arg))
}

// splitAssertion splits the assertion string a, with support
// for quoted arguments.
// "result.status ShouldEqual ok"  => [result.status] [ShouldEqual] [ok]
func splitAssertion(a string) []string {
	lastQuote := rune(0)
	f := func(c rune) bool {
		switch {
		case c == lastQuote:
			lastQuote = rune(0)
			return false
		case lastQuote != rune(0):
			return false
		case unicode.In(c, unicode.Quotation_Mark):
			lastQuote = c
			return false
		default:
			return unicode.IsSpace(c)
		}
	}
	m := strings.FieldsFunc(a, f)
	for i, e := range m {
		first, _ := utf8.DecodeRuneInString(e)
		last, _ := utf8.DecodeLastRuneInString(e)
		if unicode.In(first, unicode.Quotation_Mark) && first == last {
			m[i] = string([]rune(e)[1 : utf8.RuneCountInString(e)-1])
		}
	}
	return m
}

// stringToType converts a string 'val' to another type wich correspond to 'valType'
func stringToType(val string, valType interface{}) (interface{}, error) {
	switch valType.(type) {
	case bool:
		return strconv.ParseBool(val)
	case string:
		return val, nil
	case int:
		return strconv.Atoi(val)
	case int8:
		return strconv.ParseInt(val, 10, 8)
	case int16:
		return strconv.ParseInt(val, 10, 16)
	case int32:
		return strconv.ParseInt(val, 10, 32)
	case int64:
		return strconv.ParseInt(val, 10, 64)
	case uint:
		newVal, err := strconv.Atoi(val)
		return uint(newVal), err
	case uint8:
		return strconv.ParseUint(val, 10, 8)
	case uint16:
		return strconv.ParseUint(val, 10, 16)
	case uint32:
		return strconv.ParseUint(val, 10, 32)
	case uint64:
		return strconv.ParseUint(val, 10, 64)
	case float32:
		iVal, err := strconv.ParseFloat(val, 32)
		return float32(iVal), err
	case float64:
		iVal, err := strconv.ParseFloat(val, 64)
		return float64(iVal), err
	case time.Time:
		return time.Parse(time.RFC3339, val)
	case time.Duration:
		return time.ParseDuration(val)
	}
	return val, nil
}

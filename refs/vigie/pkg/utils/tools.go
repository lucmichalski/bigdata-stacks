package utils

import (
	"bytes"
	"crypto/sha1"
	"encoding/gob"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"
)

func IsJSONString(s string) bool {
	var js string
	return json.Unmarshal([]byte(s), &js) == nil
}

func IsArray(s string) bool {
	var js []interface{}
	return json.Unmarshal([]byte(s), &js) == nil
}

func IsNestedArray(s string) bool {
	var js [][]interface{}
	return json.Unmarshal([]byte(s), &js) == nil
}

func IsDuration(s string) bool {

	_, err := time.ParseDuration(s)
	if err != nil {
		return false
	}
	return true
}

func IsBool(s string) bool {

	_, err := strconv.ParseBool(strings.ToLower(s))
	if err != nil {
		return false
	}
	return true
}

func IsNumeric(s string) bool {

	_, err := strconv.ParseFloat(s, 64)
	if err != nil {
		return false
	}
	return true
}

func GetFloat(num interface{}) (float64, error) {
	switch i := num.(type) {
	case float64:
		return float64(i), nil
	case float32:
		return float64(i), nil
	case int64:
		return float64(i), nil
	case int32:
		return float64(i), nil
	case int16:
		return float64(i), nil
	case int8:
		return float64(i), nil
	case uint64:
		return float64(i), nil
	case uint32:
		return float64(i), nil
	case uint16:
		return float64(i), nil
	case uint8:
		return float64(i), nil
	case int:
		return float64(i), nil
	case uint:
		return float64(i), nil
	default:
		return 0, fmt.Errorf("cannot convert %q to float64", num)
	}
}

// Use time.ParseDuration instead
func ParseDuration(durationStr string) (time.Duration, error) {

	var durationRE = regexp.MustCompile("^([0-9]+)(y|w|d|h|m|s|ms)$")

	matches := durationRE.FindStringSubmatch(durationStr)
	if len(matches) != 3 {
		return 0, fmt.Errorf("%q is not a valid duration string. It must follow [0-9]+)(y|w|d|h|m|s|ms) format", durationStr)
	}
	var (
		n, _ = strconv.Atoi(matches[1])
		dur  = time.Duration(n) * time.Millisecond
	)
	switch unit := matches[2]; unit {
	case "y":
		dur *= 1000 * 60 * 60 * 24 * 365
	case "w":
		dur *= 1000 * 60 * 60 * 24 * 7
	case "d":
		dur *= 1000 * 60 * 60 * 24
	case "h":
		dur *= 1000 * 60 * 60
	case "m":
		dur *= 1000 * 60
	case "s":
		dur *= 1000
	case "ms":
		// MultiValue already correct
	default:
		return 0, fmt.Errorf("invalid time unit in duration string: %q. It must follow [0-9]+)(y|w|d|h|m|s|ms) format", unit)
	}
	return dur, nil
}

// Map performs a deep copy of the given map m.
func CopyMapGob(m map[string]interface{}) (map[string]interface{}, error) {
	var buf bytes.Buffer
	enc := gob.NewEncoder(&buf)
	dec := gob.NewDecoder(&buf)
	err := enc.Encode(m)
	if err != nil {
		return nil, err
	}
	var copy map[string]interface{}
	err = dec.Decode(&copy)
	if err != nil {
		return nil, err
	}
	return copy, nil
}

func DeepCopyJSON(src map[string]interface{}, dest map[string]interface{}) {
	for key, value := range src {
		switch src[key].(type) {
		case map[string]interface{}:
			dest[key] = map[string]interface{}{}
			DeepCopyJSON(src[key].(map[string]interface{}), dest[key].(map[string]interface{}))
		default:
			dest[key] = value
		}
	}
}

// MergeMaps merge 2 maps, in case of duplicate:
// the second map arg will overwrite the value.
func MergeMaps(globalVar map[string][]string, tsVars ...map[string][]string) map[string][]string {

	mergedMap := make(map[string][]string, len(globalVar)+len(tsVars))

	for k, v := range globalVar {
		mergedMap[k] = v
	}

	// Overwrite globalVar by TestSuites vars
	for _, m := range tsVars {
		for k, v := range m {
			mergedMap[k] = v
		}
	}
	return mergedMap
}

func MapStringEquals(a, b map[string]string) bool {
	if len(a) != len(b) {
		return false
	}

	for k, v := range a {
		if w, ok := b[k]; !ok || v != w {
			return false
		}
	}

	return true
}

func StringInSlice(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}

func CreateDirIfNotExist(dir string) {
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		err = os.MkdirAll(dir, 0755)
		if err != nil {
			panic(err)
		}
	}
}

// GetSHA1Hash return the SHA1 of a string
func GetSHA1Hash(s string) string {
	hasher := sha1.New()
	hasher.Write([]byte(s))
	return hex.EncodeToString(hasher.Sum(nil))
}

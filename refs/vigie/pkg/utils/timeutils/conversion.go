package timeutils

import (
	"fmt"
	"strconv"
	"strings"
	"time"
)

const (
	week     = day * 7
	day      = time.Hour * 24
	hour     = time.Hour
	min      = time.Minute
	sec      = time.Second
	millisec = time.Millisecond
	nanosec  = time.Nanosecond
)

type shortTimeStr string

const (
	yearStr     shortTimeStr = "y"
	monthStr    shortTimeStr = "m"
	weekStr     shortTimeStr = "w"
	dayStr      shortTimeStr = "d"
	hourStr     shortTimeStr = "h"
	minStr      shortTimeStr = "m"
	secStr      shortTimeStr = "s"
	millisecStr shortTimeStr = "ms"
	nanosecStr  shortTimeStr = "ns"
)

func ShortTimeStrToDuration(sts string) (time.Duration, error) {

	timeMap := map[string]time.Duration{
		"w":  time.Hour * 24 * 7,
		"d":  time.Hour * 24,
		"h":  time.Hour,
		"m":  time.Minute,
		"s":  time.Second,
		"ms": time.Millisecond,
		"ns": time.Nanosecond,
	}

	// Cleaning string
	sts = strings.ToLower(strings.TrimSpace(sts))

	tailSts2 := sts[len(sts)-2:]
	// For 2 letters : ms, ns
	if durType, exist := timeMap[tailSts2]; exist {
		duration, _ := strconv.Atoi(sts[len(sts)+2:])
		return durType * time.Duration(duration), nil
	}
	tailSts1 := sts[len(sts)-1:]
	// For 1 letter : others
	if durType, exist := timeMap[tailSts1]; exist {

		duration, _ := strconv.Atoi(sts[:len(sts)-1])
		return durType * time.Duration(duration), nil
	}

	fmt.Println("sts n'est pas valide")
	return time.Nanosecond, fmt.Errorf("%q is not a valid frequency", sts)

}

func FormatDuration(inter time.Duration) string {

	if inter >= time.Hour*24 {
		return fmt.Sprintf("%dd", inter/time.Hour*24)
	}

	if inter >= time.Hour {
		return fmt.Sprintf("%dh", inter/time.Hour)
	}

	if inter >= time.Minute {
		return fmt.Sprintf("%dm", inter/time.Minute)
	}

	if inter >= time.Second {
		return fmt.Sprintf("%ds", inter/time.Second)
	}

	if inter >= time.Millisecond {
		return fmt.Sprintf("%dms", inter/time.Millisecond)
	}

	return "1ms"
}

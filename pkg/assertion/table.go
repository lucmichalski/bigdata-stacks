package assertion

import (
	assertion "github.com/vincoll/vigie/pkg/assertion/func"
)

type AssertMethod struct {
	LongName      string
	ShortName     string
	Symbol        string
	IsNumericType bool
	IsEqualType   bool
	IsContainType bool
	IsOrdered     bool
	IsDuration    bool
	AssertFunc    func(actualValue interface{}, actualValues []string, expectValue interface{}, expectValueValues []string) (bool, string) `hash:"ignore"`
}

var (
	Equal           = AssertMethod{AssertFunc: assertion.Equal, LongName: "Equal", ShortName: "EQ", Symbol: "==", IsEqualType: true}
	NotEqual        = AssertMethod{AssertFunc: assertion.NotEqual, LongName: "NotEqual", ShortName: "NEQ", Symbol: "!=", IsEqualType: true}
	OrderedEqual    = AssertMethod{AssertFunc: assertion.Equal, LongName: "OrderedEqual", ShortName: "OEQ", Symbol: "#==", IsEqualType: true, IsOrdered: true}
	Contain         = AssertMethod{AssertFunc: assertion.Contains, LongName: "Contains", ShortName: "CTN", Symbol: "$$", IsContainType: true}
	LessThan        = AssertMethod{AssertFunc: assertion.LessThan, LongName: "LessThan", ShortName: "LT", Symbol: "<", IsContainType: false, IsNumericType: true}
	GreaterThan     = AssertMethod{AssertFunc: assertion.GreaterThan, LongName: "GreaterThan", ShortName: "GT", Symbol: ">", IsContainType: false, IsNumericType: true}
	LessThanOrEq    = AssertMethod{AssertFunc: assertion.LessThanOrEq, LongName: "LessThanOrEqual", ShortName: "LTE", Symbol: "<=", IsContainType: false, IsNumericType: true}
	GreaterThanOrEq = AssertMethod{AssertFunc: assertion.GreaterThanOrEq, LongName: "GreaterThanOrEqual", ShortName: "GTE", Symbol: ">=", IsContainType: false, IsNumericType: true}
)
var NewAliasAsserts = []*AssertMethod{
	&Equal,
	&NotEqual,
	&OrderedEqual,
	&Contain,
	&LessThan,
	&GreaterThan,
	&LessThanOrEq,
	&GreaterThanOrEq,
}

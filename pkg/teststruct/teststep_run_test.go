package teststruct

import (
	"sync"
	"testing"
)

func TestTestStep_setNewStatus(t *testing.T) {
	type Tstep struct {
		Mutex  sync.RWMutex
		Status StepStatus
	}
	notDef := Tstep{Mutex: sync.RWMutex{}, Status: NotDefined}
	success := Tstep{Mutex: sync.RWMutex{}, Status: Success}
	failure := Tstep{Mutex: sync.RWMutex{}, Status: Failure}
	asrtFail := Tstep{Mutex: sync.RWMutex{}, Status: AssertFailure}
	timeout := Tstep{Mutex: sync.RWMutex{}, Status: Timeout}
	err := Tstep{Mutex: sync.RWMutex{}, Status: Error}
	type args struct {
		newStatus StepStatus
	}
	tests := []struct {
		name           string
		fields         Tstep
		args           args
		wantHasChanged bool
		wantAlertEvent bool
	}{
		// Not Defined
		{"T_NotDefined-NotDefined", notDef, args{newStatus: NotDefined}, false, false},
		{"T_NotDefined-Success", notDef, args{newStatus: Success}, true, false},
		{"T_NotDefined-Failure", notDef, args{newStatus: Failure}, true, true},
		{"T_NotDefined-AssertFail", notDef, args{newStatus: AssertFailure}, true, true},
		{"T_NotDefined-timeout", notDef, args{newStatus: Timeout}, true, true},
		{"T_NotDefined-Error", notDef, args{newStatus: Error}, true, true},
		// Success
		{"T_Success-NotDefined", success, args{newStatus: NotDefined}, true, true},
		{"T_Success-Success", success, args{newStatus: Success}, false, true},
		{"T_Success-Failure", success, args{newStatus: Failure}, true, true},
		{"T_Success-AssertFail", success, args{newStatus: AssertFailure}, true, true},
		{"T_Success-timeout", success, args{newStatus: Timeout}, true, true},
		{"T_Success-Error", success, args{newStatus: Error}, true, true},
		// Failure
		{"T_Failure-NotDefined", failure, args{newStatus: NotDefined}, true, true},
		{"T_Failure-Success", failure, args{newStatus: Success}, true, true},
		{"T_Failure-Failure", failure, args{newStatus: Failure}, false, true},
		{"T_Failure-AssertFail", failure, args{newStatus: AssertFailure}, true, true},
		{"T_Failure-timeout", failure, args{newStatus: Timeout}, true, true},
		{"T_Failure-Error", failure, args{newStatus: Error}, true, true},
		// Assert Failure
		{"T_AssertFailure-NotDefined", asrtFail, args{newStatus: NotDefined}, true, true},
		{"T_AssertFailure-Success", asrtFail, args{newStatus: Success}, true, true},
		{"T_AssertFailure-Failure", asrtFail, args{newStatus: Failure}, true, true},
		{"T_AssertFailure-AssertFail", asrtFail, args{newStatus: AssertFailure}, false, true},
		{"T_AssertFailure-timeout", asrtFail, args{newStatus: Timeout}, true, true},
		{"T_AssertFailure-Error", asrtFail, args{newStatus: Error}, true, true},
		// Timeoeut
		{"T_Timeout-NotDefined", timeout, args{newStatus: NotDefined}, true, true},
		{"T_Timeout-Success", timeout, args{newStatus: Success}, true, true},
		{"T_Timeout-Failure", timeout, args{newStatus: Failure}, true, true},
		{"T_Timeout-AssertFail", timeout, args{newStatus: AssertFailure}, true, true},
		{"T_Timeout-timeout", timeout, args{newStatus: Timeout}, false, true},
		{"T_Timeout-Error", timeout, args{newStatus: Error}, true, true},
		// Error
		{"T_Error-NotDefined", err, args{newStatus: NotDefined}, true, true},
		{"T_Error-Success", err, args{newStatus: Success}, true, true},
		{"T_Error-Failure", err, args{newStatus: Failure}, true, true},
		{"T_Error-AssertFail", err, args{newStatus: AssertFailure}, true, true},
		{"T_Error-timeout", err, args{newStatus: Timeout}, true, true},
		{"T_Error-Error", err, args{newStatus: Error}, false, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tStep := &TestStep{
				Mutex:  tt.fields.Mutex,
				Status: tt.fields.Status,
			}
			gotHasChanged, gotAlertEvent := tStep.setNewStatus(tt.args.newStatus)
			if gotHasChanged != tt.wantHasChanged {
				t.Errorf("setNewStatus() StatusChanged = %v, want %v", gotHasChanged, tt.wantHasChanged)
			}
			if gotHasChanged != tt.wantHasChanged {
				t.Errorf("setNewStatus() AlertEvent = %v, want %v", gotAlertEvent, tt.wantAlertEvent)
			}

			if tStep.Status != tt.args.newStatus {
				t.Errorf("New status (%v) has not be applied on tStep.Status!", tt.args.newStatus)

			}
		})
	}
}

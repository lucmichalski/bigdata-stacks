package process

import (
	"github.com/vincoll/vigie/pkg/teststruct"
	"testing"
)

func Test_getFinalResultStatus(t *testing.T) {
	type arg struct {
		vrs []teststruct.VigieResult
	}

	// VR samples
	vr_err := teststruct.VigieResult{Status: teststruct.Error}
	vr_fail := teststruct.VigieResult{Status: teststruct.Failure}
	vr_to := teststruct.VigieResult{Status: teststruct.Timeout}
	vr_asrtfail := teststruct.VigieResult{Status: teststruct.AssertFailure}
	vr_nd := teststruct.VigieResult{Status: teststruct.NotDefined}
	vr_succ := teststruct.VigieResult{Status: teststruct.Success}

	// Multiples VRS

	// each
	vrs_err := []teststruct.VigieResult{vr_err}
	vrs_nd := []teststruct.VigieResult{vr_nd}
	vrs_to := []teststruct.VigieResult{vr_to}
	vrs_succ := []teststruct.VigieResult{vr_succ}
	vrs_af := []teststruct.VigieResult{vr_asrtfail}
	vrs_fail := []teststruct.VigieResult{vr_fail}

	// nd . x
	vrs_nd_nd := []teststruct.VigieResult{vr_nd, vr_nd}
	vrs_nd_err := []teststruct.VigieResult{vr_nd, vr_err}
	vrs_nd_to := []teststruct.VigieResult{vr_nd, vr_to}
	vrs_nd_succ := []teststruct.VigieResult{vr_nd, vr_succ}
	vrs_nd_fail := []teststruct.VigieResult{vr_nd, vr_fail}
	vrs_nd_af := []teststruct.VigieResult{vr_nd, vr_asrtfail}

	// succ . x
	vrs_succ_err := []teststruct.VigieResult{vr_succ, vr_err}
	vrs_succ_nd := []teststruct.VigieResult{vr_succ, vr_nd}
	vrs_succ_to := []teststruct.VigieResult{vr_succ, vr_to}
	vrs_succ_af := []teststruct.VigieResult{vr_succ, vr_asrtfail}
	vrs_succ_succ := []teststruct.VigieResult{vr_succ, vr_succ}
	vrs_succ_fail := []teststruct.VigieResult{vr_succ, vr_fail}

	// err . x
	vrs_err_err := []teststruct.VigieResult{vr_err, vr_err}
	vrs_err_nd := []teststruct.VigieResult{vr_err, vr_nd}
	vrs_err_to := []teststruct.VigieResult{vr_err, vr_to}
	vrs_err_succ := []teststruct.VigieResult{vr_err, vr_succ}
	vrs_err_fail := []teststruct.VigieResult{vr_err, vr_fail}
	vrs_err_asrtfail := []teststruct.VigieResult{vr_err, vr_asrtfail}

	// fail . x
	vrs_fail_err := []teststruct.VigieResult{vr_fail, vr_err}
	vrs_fail_nd := []teststruct.VigieResult{vr_fail, vr_nd}
	vrs_fail_to := []teststruct.VigieResult{vr_fail, vr_to}
	vrs_fail_af := []teststruct.VigieResult{vr_fail, vr_asrtfail}
	vrs_fail_succ := []teststruct.VigieResult{vr_fail, vr_succ}
	vrs_fail_fail := []teststruct.VigieResult{vr_fail, vr_fail}

	// asrtfail . x
	vrs_asrtfail_err := []teststruct.VigieResult{vr_asrtfail, vr_err}
	vrs_asrtfail_nd := []teststruct.VigieResult{vr_asrtfail, vr_nd}
	vrs_asrtfail_to := []teststruct.VigieResult{vr_asrtfail, vr_to}
	vrs_asrtfail_af := []teststruct.VigieResult{vr_asrtfail, vr_asrtfail}
	vrs_asrtfail_succ := []teststruct.VigieResult{vr_asrtfail, vr_succ}
	vrs_asrtfail_fail := []teststruct.VigieResult{vr_asrtfail, vr_fail}

	// timeout . x
	vrs_to_err := []teststruct.VigieResult{vr_to, vr_err}
	vrs_to_nd := []teststruct.VigieResult{vr_to, vr_nd}
	vrs_to_to := []teststruct.VigieResult{vr_to, vr_to}
	vrs_to_af := []teststruct.VigieResult{vr_to, vr_asrtfail}
	vrs_to_succ := []teststruct.VigieResult{vr_to, vr_succ}
	vrs_to_fail := []teststruct.VigieResult{vr_to, vr_fail}

	tests := []struct {
		name            string
		args            arg
		wantFinalStatus teststruct.StepStatus
	}{
		{name: "vrs_err", args: arg{vrs_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_nd", args: arg{vrs_nd}, wantFinalStatus: teststruct.NotDefined},
		{name: "vrs_succ", args: arg{vrs_succ}, wantFinalStatus: teststruct.Success},
		{name: "vrs_af", args: arg{vrs_af}, wantFinalStatus: teststruct.AssertFailure},
		{name: "vrs_to", args: arg{vrs_to}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_fail", args: arg{vrs_fail}, wantFinalStatus: teststruct.Failure},

		{name: "vrs_nd_nd", args: arg{vrs_nd_nd}, wantFinalStatus: teststruct.NotDefined},
		{name: "vrs_nd_err", args: arg{vrs_nd_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_nd_succ", args: arg{vrs_nd_succ}, wantFinalStatus: teststruct.NotDefined},
		{name: "vrs_nd_fail", args: arg{vrs_nd_fail}, wantFinalStatus: teststruct.Failure},
		{name: "vrs_nd_af", args: arg{vrs_nd_af}, wantFinalStatus: teststruct.AssertFailure},
		{name: "vrs_nd_to", args: arg{vrs_nd_to}, wantFinalStatus: teststruct.Timeout},

		{name: "vrs_succ_err", args: arg{vrs_succ_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_succ_nd", args: arg{vrs_succ_nd}, wantFinalStatus: teststruct.NotDefined},
		{name: "vrs_succ_af", args: arg{vrs_succ_af}, wantFinalStatus: teststruct.AssertFailure},
		{name: "vrs_succ_succ", args: arg{vrs_succ_succ}, wantFinalStatus: teststruct.Success},
		{name: "vrs_succ_fail", args: arg{vrs_succ_fail}, wantFinalStatus: teststruct.Failure},
		{name: "vrs_succ_to", args: arg{vrs_succ_to}, wantFinalStatus: teststruct.Timeout},

		{name: "vrs_err_err", args: arg{vrs_err_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_err_nd", args: arg{vrs_err_nd}, wantFinalStatus: teststruct.Error},
		{name: "vrs_err_succ", args: arg{vrs_err_succ}, wantFinalStatus: teststruct.Error},
		{name: "vrs_err_fail", args: arg{vrs_err_fail}, wantFinalStatus: teststruct.Error},
		{name: "vrs_err_asrtfail", args: arg{vrs_err_asrtfail}, wantFinalStatus: teststruct.Error},
		{name: "vrs_err_to", args: arg{vrs_err_to}, wantFinalStatus: teststruct.Error},

		{name: "vrs_fail_to", args: arg{vrs_fail_to}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_fail_err", args: arg{vrs_fail_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_fail_nd", args: arg{vrs_fail_nd}, wantFinalStatus: teststruct.Failure},
		{name: "vrs_fail_af", args: arg{vrs_fail_af}, wantFinalStatus: teststruct.Failure},
		{name: "vrs_fail_succ", args: arg{vrs_fail_succ}, wantFinalStatus: teststruct.Failure},
		{name: "vrs_fail_fail", args: arg{vrs_fail_fail}, wantFinalStatus: teststruct.Failure},

		{name: "vrs_asrtfail_to", args: arg{vrs_asrtfail_to}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_asrtfail_err", args: arg{vrs_asrtfail_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_asrtfail_nd", args: arg{vrs_asrtfail_nd}, wantFinalStatus: teststruct.AssertFailure},
		{name: "vrs_asrtfail_af", args: arg{vrs_asrtfail_af}, wantFinalStatus: teststruct.AssertFailure},
		{name: "vrs_asrtfail_succ", args: arg{vrs_asrtfail_succ}, wantFinalStatus: teststruct.AssertFailure},
		{name: "vrs_asrtfail_fail", args: arg{vrs_asrtfail_fail}, wantFinalStatus: teststruct.Failure},

		{name: "vrs_to_to", args: arg{vrs_to_to}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_to_err", args: arg{vrs_to_err}, wantFinalStatus: teststruct.Error},
		{name: "vrs_to_nd", args: arg{vrs_to_nd}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_to_af", args: arg{vrs_to_af}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_to_succ", args: arg{vrs_to_succ}, wantFinalStatus: teststruct.Timeout},
		{name: "vrs_to_fail", args: arg{vrs_to_fail}, wantFinalStatus: teststruct.Timeout},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if gotFinalStatus := getFinalResultStatus(tt.args.vrs); gotFinalStatus != tt.wantFinalStatus {
				t.Errorf("getFinalResultStatus() = %v, want %v", gotFinalStatus, tt.wantFinalStatus)
			}
		})
	}
}

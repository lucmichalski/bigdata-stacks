package load

import (
	"reflect"
	"testing"
)

/*
func TestGetFilesPath(t *testing.T) {
	type args struct {
		paths   []string
		exclude []string
	}
	path01 := []string{"../build/ci/tests/ut/load/01"}
	path02 := []string{"../build/ci/tests/ut/load/02"}

	tests := []struct {
		name    string
		args    args
		want    []string
		wantErr bool
	}{ //TODO : Faire fonctionner
		{"T00_empty", args{paths: []string{""}, exclude: []string{""}}, []string(nil), true},
		{"T01_empty", args{paths: path01, exclude: []string{""}}, []string(nil), true},
		{"T02_one", args{paths: path02, exclude: []string{""}}, []string(nil), true},
		{"T02_addexclude1", args{paths: path02, exclude: []string{"../build/ci/tests/ut/load/02/x.yml"}}, []string(nil), true},
		{"T02_addexclude2", args{paths: path02, exclude: []string{"../build/ci/tests/ut/load/02/x.yml"}}, []string(nil), true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := getFilesPath(tt.args.paths, tt.args.exclude)
			if (err != nil) != tt.wantErr {
				t.Errorf("getFilesPath() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("getFilesPath() = %v, want %v", got, tt.want)
				println("o")
			}
		})
	}
}
*/
func TestUniqueRecursiveFilesPath(t *testing.T) {
	type args struct {
		SrcPaths []string
		extfile  map[string]bool
	}
	tests := []struct {
		name    string
		args    args
		want    map[string]bool
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := uniqueRecursiveFilesPath(tt.args.SrcPaths, tt.args.extfile)
			if (err != nil) != tt.wantErr {
				t.Errorf("uniqueRecursiveFilesPath() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("uniqueRecursiveFilesPath() = %v, want %v", got, tt.want)
			}
		})
	}
}

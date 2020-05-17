package webapi

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/mux"
	"github.com/vincoll/vigie/pkg/teststruct"
	"net/http"
	"strconv"
)

func (api *apiVigie) addVigieAPI(router *mux.Router) {

	// TESTSUITE
	router.HandleFunc("/api/testsuites/all", api.getAllTestSuites).Methods("GET")
	router.HandleFunc("/api/testsuites/list", api.getTestSuitesList).Methods("GET")

	router.HandleFunc("/api/testsuite/{idTS}", api.getTestSuite).Methods("GET")
	router.HandleFunc("/api/testsuite/{idTS}/testcase/{idTC}", api.getTestCase).Methods("GET")

	// TESTCASE
	router.HandleFunc("/api/testsuite/{idTS}/testcase/list", api.getTestCase).Methods("GET")
	router.HandleFunc("/api/testsuite/{idTS}/testcase/{idTC}", api.getTestCase).Methods("GET")

	// TESTSTEP
	router.HandleFunc("/api/testsuite/{idTS}/testcase/{idTC}/teststep", api.getTestSuite).Methods("GET")

	// UID
	router.HandleFunc("/api/uid/{uid}", api.getTestbyUID).Methods("GET") // GET /id/{uID} ex /id/6-87-230

	// ID
	router.HandleFunc("/api/id/{idTS}/{idTC}/{idTSTP}", api.getTestStep).Methods("GET")
	router.HandleFunc("/api/id/{idTS}/{idTC}", api.getTestCase).Methods("GET")
	router.HandleFunc("/api/id/{idTS}", api.getTestSuite).Methods("GET")

}

func (api *apiVigie) getAllTestSuites(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var tsList = make([]teststruct.TSDescribe, 0, len(api.vigie.TestSuites))
	for _, tSuite := range api.vigie.TestSuites {
		tsList = append(tsList, tSuite.ToJSON())
	}
	_ = json.NewEncoder(w).Encode(tsList)
}

func (api *apiVigie) getTestSuitesList(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var tsListHeader = make([]teststruct.TSHeader, 0, len(api.vigie.TestSuites))

	for _, tSuite := range api.vigie.TestSuites {
		tsListHeader = append(tsListHeader, tSuite.ToHeader())
	}

	_ = json.NewEncoder(w).Encode(tsListHeader)
}

func (api *apiVigie) getTestSuite(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)

	idTS, err := strconv.ParseInt(params["idTS"], 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%d of type %T", idTS, idTS)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	ts, err := api.vigie.GetTestSuiteByID(uint64(idTS))
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	_ = json.NewEncoder(w).Encode(ts)
}

func (api *apiVigie) getTestCase(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)

	tsID := params["idTS"]
	tcID := params["idTC"]

	if tsID == "" && tcID == "" {
		http.Error(w, "", http.StatusNotFound)
		return
	}

	idTS, err := strconv.ParseInt(tsID, 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%d of type %T", idTS, idTS)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	idTC, err := strconv.ParseInt(tcID, 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%d of type %T", idTS, idTS)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	ts, err := api.vigie.GetTestCaseByID(uint64(idTS), uint64(idTC))
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	_ = json.NewEncoder(w).Encode(ts)
}

func (api *apiVigie) getTestCaseList(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	tsID := params["idTS"]

	if tsID == "" {
		http.Error(w, "", http.StatusNotFound)
		return
	}

	idTS, err := strconv.ParseInt(params["idTS"], 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%d of type %T", idTS, idTS)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	tcListHeader, err := api.vigie.GetTestCasesList(uint64(idTS))
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	_ = json.NewEncoder(w).Encode(tcListHeader)
}

func (api *apiVigie) getTestStep(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)

	tsID := params["idTS"]
	tcID := params["idTC"]
	tstpID := params["idTSTP"]

	if tsID == "" || tcID == "" || tstpID == "" {
		http.Error(w, "", http.StatusNotFound)
		return
	}

	idTS, err := strconv.ParseInt(tsID, 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%d of type %T", idTS, idTS)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	idTC, err := strconv.ParseInt(tcID, 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%d of type %T", idTS, idTS)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	idTSTP, err := strconv.ParseInt(tstpID, 10, 64)
	if err != nil {
		msg := fmt.Sprintf("%v of type %T", tstpID, tstpID)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}

	ts, err := api.vigie.GetTestStepByID(uint64(idTS), uint64(idTC), uint64(idTSTP))
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	_ = json.NewEncoder(w).Encode(ts)
}

func (api *apiVigie) getTestbyUID(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	uID := params["uid"]

	if uID == "" {
		http.Error(w, "", http.StatusNotFound)
		return
	}

	txResult, err := api.vigie.GetTestByUID(uID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	_ = json.NewEncoder(w).Encode(txResult)
}

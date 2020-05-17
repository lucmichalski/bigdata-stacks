package webapi

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"net/http"
)

func (api *apiVigie) addHealthEndpoints(router *mux.Router) {

	router.HandleFunc("/metrics", func(w http.ResponseWriter, r *http.Request) {
		_ = json.NewEncoder(w).Encode(map[string]bool{"todo": true})
	})

	router.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		// an example API handler
		if api.vigie.Status == 1 {
			_ = json.NewEncoder(w).Encode(map[string]bool{"ok": true})
		} else {
			http.Error(w, http.StatusText(503), 503)
		}
	})

}

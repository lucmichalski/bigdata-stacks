package webapi

import (
	"fmt"
	"github.com/gorilla/handlers"
	"net/http"

	"github.com/gorilla/mux"

	"github.com/sirupsen/logrus"

	"github.com/vincoll/vigie/pkg/utils"
	"github.com/vincoll/vigie/pkg/vigie"
)

type apiVigie struct {
	vigie *vigie.Vigie
}

func InitWebAPI(confWAPI ConfWebAPI, vigieInstance *vigie.Vigie) error {

	if confWAPI.Enable == true {

		api := apiVigie{
			vigie: vigieInstance,
		}

		go api.Run(confWAPI)
	}

	return nil
}

func (api *apiVigie) Run(confWAPI ConfWebAPI) {

	utils.Log.WithFields(logrus.Fields{"component": "webapi", "status": "running", "port": confWAPI.Port}).Infof("Vigie REST WebAPI is enabled")

	router := mux.NewRouter()

	// Add Health Endpoints
	api.addHealthEndpoints(router)

	// Add Vigie API endpoints
	api.addVigieAPI(router)

	// Load and Expose pprof addProfiling
	cors := handlers.CORS(
		handlers.AllowedHeaders([]string{"content-type"}),
		handlers.AllowedOrigins([]string{"*"}),
		handlers.AllowCredentials(),
	)

	router.Use(cors)

	if confWAPI.Environment != "production" {
		// Activate Profiling endpoint with pprof
		addProfiling(router)
	}
	/*
		statikFS, errStatik := fs.New()
		if errStatik != nil {
		}
		staticHandler := http.FileServer(statikFS)

		router.Handle("/ui/", http.StripPrefix("/ui/", staticHandler))
		router.Handle("/html/", http.StripPrefix("", http.FileServer(statikFS)))

		//router.Handle("/webui/", http.StripPrefix("/webui/", http.FileServer(statikFS)))
		/*
			spa := spaHandler{staticFS: statikFS, indexPath: "index.html"}
			router.PathPrefix("/").Handler(spa)
	*/
	err := http.ListenAndServe(fmt.Sprint(":", confWAPI.Port), router)
	if err != nil {
		fmt.Println("ConfWebAPI ListenAndServe:", err)
		utils.Log.WithFields(logrus.Fields{"component": "api", "status": "failed", "error": err}).Fatal("[ConfWebAPI] has failed to start")

	}

}

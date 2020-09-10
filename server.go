package main

import (
	"gomicroservice/routers"
	// "gomicroservice/plugins" if you create your own plugins import them here
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/static"
	log "github.com/sirupsen/logrus"
	"os"
	
)

func port() string {
	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "8080"
	}
	return ":" + port
}

func main() {

	log.SetFormatter(&log.JSONFormatter{})
	log.SetOutput(os.Stdout)

	router := gin.Default()
	router.RedirectTrailingSlash = false

	router.GET("/explorer", routers.SwaggerExplorerRedirect)
	router.GET("/swagger/api", routers.SwaggerAPI)
	router.Use(static.Serve("/explorer/", static.LocalFile("./public/swagger-ui/", true)))
	router.GET("/health", routers.HealthGET)

	log.Info("Starting gomicroservice on port " + port())

	router.Run(port())
}
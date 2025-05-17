package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/zkfmapf123/pdf-bot/handlers"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/swagger"
)

const (
	DEFAULT_PORT = "3000"
	APP_NAME     = "user"
	PREFIX       = "api"
)

// @title			example
// @version		1.0
// @description	This is a sample swagger for Fiber
// @termsOfService	http://swagger.io/terms/
// @contact.name	API Support
// @contact.email	fiber@swagger.io
// @license.name	Apache 2.0
// @license.url	http://www.apache.org/licenses/LICENSE-2.0.html
// @host			localhost:3000
// @BasePath		/
func main() {
	app := fiber.New(fiber.Config{
		Prefork:       true,
		CaseSensitive: true,
		StrictRouting: true,
		ServerHeader:  "fiber",
		AppName:       APP_NAME,
	})

	app.Use(logger.New())
	r := app.Group(PREFIX)

	r.Get("/ping", handlers.PingHandlers)
	app.Get("/swagger/*", swagger.HandlerDefault)

	port := os.Getenv("PORT")
	if port == "" {
		port = DEFAULT_PORT
	}

	go func() {
		if err := app.Listen(":" + port); err != nil {
			log.Printf("Server error: %v\n", err)
		}
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)

	<-c
	log.Println("Shutting down server...")
	app.Shutdown()
}

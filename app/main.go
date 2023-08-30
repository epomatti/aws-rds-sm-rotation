package main

import (
	"main/sm"
	"main/utils"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	utils.Check(err)

	secretId := os.Getenv("SECRET_ID")

	value := sm.GetSecretValue(secretId)
	println(value)
}

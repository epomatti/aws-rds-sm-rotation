package main

import (
	"main/secrets"
	"main/utils"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	utils.Check(err)

	// value := secrets.GetSecretValue()
	value := secrets.GetCachedSecret()
	println(value.Password)
}

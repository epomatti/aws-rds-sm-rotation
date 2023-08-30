package main

import (
	"fmt"
	"main/secrets"
	"main/utils"
	"time"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	utils.Check(err)

	value := secrets.GetSecretValue()
	fmt.Printf("Username: %v\n", value.Username)
	fmt.Printf("Password: %v\n", value.Password)

	for i := 0; i < 1; {
		time.Sleep(time.Duration(1) * time.Second)
	}

}

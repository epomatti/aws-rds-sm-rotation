package main

import (
	"fmt"
	"main/db"
	"main/secrets"
	"main/utils"
	"time"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	utils.Check(err)

	credentials := secrets.GetSecretValue()
	fmt.Printf("Username: %v\n", credentials.Username)
	fmt.Printf("Password: %v\n", credentials.Password)

	for i := 0; i < 1; {
		db.Query(credentials)
		time.Sleep(time.Duration(1) * time.Second)
	}

}

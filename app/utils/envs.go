package utils

import "os"

func GetSecretId() string {
	return os.Getenv("SECRET_ID")
}

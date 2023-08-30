package utils

import (
	"os"
	"strconv"
)

func GetSecretId() string {
	return os.Getenv("SECRET_ID")
}

func GetLoopSleep() int {
	env := os.Getenv("LOOP_SLEEP_SECONDS")
	i, err := strconv.Atoi(env)
	Check(err)
	return i
}

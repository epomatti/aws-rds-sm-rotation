package utils

import (
	"os"
	"strconv"
)

func GetSecretId() string {
	return os.Getenv("SECRET_ID")
}

func GetRDSMysqlAddress() string {
	return os.Getenv("RDS_MYSQL_ADDRESS")
}

func GetLoopSleep() int {
	env := os.Getenv("LOOP_SLEEP_SECONDS")
	i, err := strconv.Atoi(env)
	Check(err)
	return i
}

package main

import "main/sm"

func main() {
	var secretId string = "rds!db-10db40ec-cebd-4ade-9865-a4b99718a0a1"
	value := sm.GetSecretValue(secretId)
	println(value)
}

package db

import (
	"database/sql"
	"fmt"
	"main/secrets"
	"main/utils"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

func Query(c secrets.RdsMasterCredentials) {
	address := utils.GetRDSMysqlAddress()
	dataSourceName := fmt.Sprintf("%s:%s@tcp(%s:3306)/testdb", c.Username, c.Password, address)
	db, err := sql.Open("mysql", dataSourceName)
	utils.Check(err)

	defer db.Close()
	// See "Important settings" section.
	db.SetConnMaxLifetime(time.Second * 10)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	var version string
	err = db.QueryRow("SELECT VERSION()").Scan(&version)
	fmt.Println(version)
	utils.Check(err)
}

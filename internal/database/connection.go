package database

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/lib/pq"
)

func Connect() (*sql.DB, error) {
	host := os.Getenv("DB_HOST")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	db_name := os.Getenv("DB_NAME")
	DATABASE_URL := fmt.Sprintf("%s://%s:%s@postgres:5432/%s?sslmode=disable", host, user, password, db_name)
	db, err := sql.Open("postgres", DATABASE_URL)
	if err != nil {
		return nil, fmt.Errorf("Not able to connect to postgres database")
	}
	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("Not able to connect to postgres database")
	}
	fmt.Println("Connected to Postgres!")
	return db, nil
}

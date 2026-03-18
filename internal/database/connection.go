package database

import (
	"database/sql"
	"fmt"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func Connect() (*sql.DB, error) {
	err := godotenv.Load()
	if err != nil {
		return nil, fmt.Errorf(".env file not found")
	}
	ConnString := os.Getenv("DATABASE_URL")
	if ConnString == "" {
		return nil, fmt.Errorf("DATABASE_URL not set")
	}
	db, err := sql.Open("postgres", ConnString)
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

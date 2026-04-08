.PHONY: setup up migrate run down logs clean

setup:
	docker compose build

up:
	docker compose up -d postgres

migrate:
	docker compose --profile migrations up --abort-on-container-exit

run: up migrate
	docker compose run --rm go-cli

down:
	docker compose down

logs:
	docker compose logs -f

clean:
	docker compose down -v
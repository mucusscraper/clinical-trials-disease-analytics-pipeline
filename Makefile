build:
	docker compose build

up:
	docker compose up -d postgres

run:
	docker compose run --rm go-cli

down:
	docker compose down

logs:
	docker compose logs -f

clean:
	docker compose down -v
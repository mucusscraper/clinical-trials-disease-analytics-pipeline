.PHONY: setup start migrate run down logs clean

# Baixa todas as imagens
setup:
	docker compose pull

# Sobe apenas o banco
start:
	docker compose up -d postgres

# Roda as migrations usando o container do Go CLI
migrate:
	docker compose run --rm go-cli sh -c "goose -dir sql/schema postgres 'postgresql://admin:admin@postgres:5432/clinical_trials?sslmode=disable' up"

# Roda a aplicação Go
run: start migrate
	docker compose run --rm go-cli

# Para todos os containers
down:
	docker compose down

# Logs de todos os containers
logs:
	docker compose logs -f

# Remove containers, redes e volumes
clean:
	docker compose down -v
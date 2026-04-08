FROM golang:1.25.6 AS build


WORKDIR /app 

COPY go.mod go.sum ./

RUN apt-get update
RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  go mod download

COPY internal/ ./internal
COPY cmd ./cmd
COPY reports ./reports
COPY requirements.txt .
COPY sql ./sql
RUN go install github.com/pressly/goose/v3/cmd/goose@latest
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache-dir --break-system-packages -r requirements.txt
RUN CGO_ENABLED=0 go build \
    -o trial-analyzer \
    ./cmd/trial-analyzer/


CMD sh -c "sleep 5 && ./trial-analyzer"
FROM golang:1.25.4-alpine AS build

RUN adduser -D -u 1001 nonroot

WORKDIR /app 

COPY go.mod go.sum ./

RUN apk add --no-cache ca-certificates

RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  go mod download

COPY internal/ ./internal
COPY cmd ./cmd
COPY reports ./reports
COPY requirements.txt .

RUN CGO_ENABLED=0 go build \
    -o trial-analyzer \
    ./cmd/trial-analyzer/


# 👇 runtime simples e FUNCIONAL
FROM alpine:3.20


RUN apk add --no-cache ca-certificates python3 py3-pip
RUN apk add --no-cache ca-certificates

WORKDIR /

COPY --from=build /app/trial-analyzer .
COPY --from=build /app/reports ./reports
COPY --from=build /app/requirements.txt .
ENV MPLCONFIGDIR=/tmp/matplotlib
RUN pip install --no-cache-dir --break-system-packages -r /requirements.txt

USER 1001
CMD ["./trial-analyzer"]
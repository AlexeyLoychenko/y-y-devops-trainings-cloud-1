FROM golang:1.21 as builder
WORKDIR /usr/src/app
COPY ./catgpt/go.mod ./catgpt/go.sum ./
RUN go mod download && go mod verify
COPY ./catgpt/. .
RUN CGO_ENABLED=0 go build -o /catgpt-app

FROM gcr.io/distroless/static-debian12:latest-amd64
COPY --from=builder /catgpt-app /
EXPOSE 8080
CMD ["/catgpt-app"]
FROM golang:1.22-alpine AS build

RUN apk add --no-cache curl

RUN curl -sSL https://github.com/leighmcculloch/vangen/releases/download/v1.1.3/vangen_1.1.3_linux_amd64.tar.gz | tar xz -C /usr/local/bin vangen

WORKDIR /build

COPY vangen.json ./

RUN vangen -out ./public

COPY go.mod ./

RUN go mod download

COPY . .

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 \
    go build -o go-vanityurls go.topi.wtf/go-vanityurls

FROM alpine

COPY --from=build /build/go-vanityurls /bin/go-vanityurls

ENTRYPOINT ["/bin/go-vanityurls"]

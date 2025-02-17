FROM --platform=${BUILDPLATFORM} golang:1.18-alpine AS builder
ARG TARGETOS
ARG TARGETARCH

# Git is required for getting the dependencies.
# hadolint ignore=DL3018
RUN apk add --no-cache git

WORKDIR /src

# Fetch dependencies first; they are less susceptible to change on every build
# and will therefore be cached for speeding up the next build
COPY ./go.mod ./go.sum ./
RUN go mod download

# Import the code from the context.
COPY ./ ./

# Build the executable to `/app`. Mark the build as statically linked.
# hadolint ignore=SC2155
RUN export TAG=$(git describe --tags "$(git rev-list --tags --max-count=1)") && \
    export COMMIT=$(git rev-parse --short HEAD) && \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    go build -installsuffix 'static' \
    -ldflags="-X main.version=${TAG} -X main.commit=${COMMIT}" \
    -o /app .

FROM alpine:3.12.1 AS final

# Set up non-root user and app directory
# * Non-root because of the principle of least privlege
# * App directory to allow mounting volumes
RUN addgroup -g 1000 app && \
    adduser -HD -u 1000 -G app app && \
    mkdir -p /app/logs && \
    chown -R app:app /app
USER app

# Import the compiled executable from the first stage.
COPY --from=builder /app /app

EXPOSE 8080

# Run the compiled binary.
ENTRYPOINT ["/app/app"]
# Use the Vapor image because its easy

FROM swift:5.3 as build
WORKDIR /build

# Copy entire repo into container
COPY . .

RUN apt-get update
RUN apt-get install -y libssl1.0-dev \
  zlib1g-dev \
  sqlite3 \
  libsqlite3-dev

RUN swift build \
    --enable-test-discovery \
    -c release \
    -Xswiftc -g

FROM vapor/ubuntu:18.04
WORKDIR /run

# Copy build artifacts
COPY --from=build /build/.build/release /run
# Copy Swift runtime libraries
COPY --from=build /usr/lib/swift/ /usr/lib/swift/

ENTRYPOINT ["./friend-bot"]
CMD []

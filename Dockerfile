# Use the Vapor image because its easy

FROM vapor/swift:5.3 as build
WORKDIR /build

# Copy entire repo into container
COPY . .

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

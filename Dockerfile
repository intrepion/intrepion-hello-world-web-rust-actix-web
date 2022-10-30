FROM lukemathwalker/cargo-chef:latest-rust-1.64.0 as chef
WORKDIR /app
RUN apt update && apt install lld clang -y

FROM chef as builder
COPY . .
RUN cargo build --release --bin intrepion-hello-world-web-rust-actix-web

FROM debian:bullseye-slim AS runtime
WORKDIR /app
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/intrepion-hello-world-web-rust-actix-web intrepion-hello-world-web-rust-actix-web
ENTRYPOINT ["./intrepion-hello-world-web-rust-actix-web"]

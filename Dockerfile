FROM rust:1.87.0 AS builder

WORKDIR /app

RUN apt update && apt install lld clang -y

COPY . .

ENV SQLX_OFFLINE true

RUN cargo build --release

FROM rust:1.87.0-slim AS runtime

WORKDIR /app

COPY --from=builder /app/target/release/zero2prod zero2prod
COPY configuration configuration
ENV APP_ENVIRONMENT producetion

ENTRYPOINT ["./zero2prod"]
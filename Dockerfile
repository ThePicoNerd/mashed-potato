FROM ekidd/rust-musl-builder:stable AS builder
RUN USER=rust cargo init
COPY --chown=rust:rust Cargo.* ./
RUN cargo build --release
RUN rm -r target/x86_64-unknown-linux-musl/release/deps/mashed_potato*
COPY --chown=rust:rust src ./src
RUN cargo build --release

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /home/rust/src/target/x86_64-unknown-linux-musl/release/mashed-potato /usr/local/bin/

ENV ADDR 0.0.0.0:80
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/mashed-potato"]
# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM hugomods/hugo:exts AS builder

WORKDIR /site

# Copy source (public/ should be gitignored and not present)
COPY . .

RUN hugo --minify --gc

# ── Stage 2: Serve ────────────────────────────────────────────────────────────
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /site/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1

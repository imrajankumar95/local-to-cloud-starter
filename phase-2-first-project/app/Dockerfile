# ─────────────────────────────────────────────
# Dockerfile — my-app
# Base: nginx:alpine (tiny, ~8MB)
# ─────────────────────────────────────────────

FROM nginx:alpine

# Remove the default Nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy our HTML app into the Nginx web root
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 (Nginx default)
EXPOSE 80

# Nginx starts automatically — no CMD needed
# (the base image already has: CMD ["nginx", "-g", "daemon off;"])

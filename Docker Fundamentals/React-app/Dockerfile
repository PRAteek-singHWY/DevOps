# Stage 1: install dependencies and produce the static bundle
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN npm install
COPY index.html vite.config.js ./
COPY src ./src
RUN npm run build

# Stage 2: ship only the built files on a tiny web server
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80

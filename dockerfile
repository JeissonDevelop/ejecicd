# compilar app angular
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# servir app angular
FROM nginx:alpine
COPY --from=builder /app/dist/angular-ci-cd /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
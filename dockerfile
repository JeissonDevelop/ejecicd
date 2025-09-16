# Build Angular
FROM node:22-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Servir con Nginx
FROM nginx:alpine

# Limpiar contenido por defecto
RUN rm -rf /usr/share/nginx/html/*

# Copiar build
COPY --from=builder /app/dist/angular_ci_cd/browser /usr/share/nginx/html

# Configuración Nginx para Angular SPA
RUN rm /etc/nginx/conf.d/default.conf
RUN printf '%s\n' \
'server {' \
'    listen 80;' \
'    server_name localhost;' \
'    root /usr/share/nginx/html;' \
'    index index.html;' \
'    location / {' \
'        try_files $uri $uri/ /index.html;' \
'    }' \
'}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

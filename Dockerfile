# Frontend Dockerfile
FROM node:20-alpine

WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем зависимости
RUN npm ci

# Копируем исходный код
COPY . .

# Собираем приложение
RUN npm run build

# Устанавливаем serve для раздачи статики
RUN npm install -g serve

# Используем nginx для раздачи статики
FROM nginx:alpine

# Копируем собранное приложение
COPY --from=0 /app/dist /usr/share/nginx/html

# Копируем кастомную конфигурацию nginx (если нужна)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
# Используем официальный образ Node.js
FROM node:18

# Устанавливаем рабочую директорию
WORKDIR /usr/src/app

# Копируем файлы package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем весь исходный код
COPY . .

# Сборка приложения
RUN npm run build

# Указываем порт, который будет использовать приложение
EXPOSE 3000

# Команда для запуска приложения
CMD ["npm", "run", "preview"]

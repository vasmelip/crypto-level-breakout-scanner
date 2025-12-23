# 🚀 Quick Start - Быстрые команды развёртывания

## 📊 Установка репозитория

```bash
cd /tmp
git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner
```

---

## Опция 1: Docker (рекомендуется)

### Быстрый старт (1 команда):
```bash
bash DEPLOY.sh
# Выберите опцию 1
```

### Мануальная установка:
```bash
# Проверка Docker
docker --version

# Создание образа
docker build -t crypto-scanner:latest .

# Запуск контейнера
docker run -d \
  --name crypto-scanner \
  -p 80:80 \
  --restart unless-stopped \
  crypto-scanner:latest

# Проверка статуса
docker ps | grep crypto-scanner

# Запрос на localhost:80
curl http://localhost:80

# Полная очистка
docker stop crypto-scanner
docker rm crypto-scanner
docker rmi crypto-scanner:latest
```

---

## Опция 2: Nginx (Linux)

### Минимальная установка:
```bash
# 1. Клонирание
cd /var/www
sudo git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner

# 2. Даю права
sudo chown -R www-data:www-data /var/www/crypto-level-breakout-scanner
sudo chmod -R 755 /var/www/crypto-level-breakout-scanner

# 3. Конфигурирую Nginx
sudo tee /etc/nginx/sites-available/crypto-scanner > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/crypto-level-breakout-scanner;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# 4. Активирую
sudo ln -s /etc/nginx/sites-available/crypto-scanner /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default 2>/dev/null || true

# 5. Тест конфига
sudo nginx -t

# 6. Перезагружу
sudo systemctl restart nginx

# Проверка
curl http://localhost
```

### После работы:
```bash
# Просмотр логов
sudo tail -f /var/log/nginx/access.log

# Остановка
sudo systemctl stop nginx
```

---

## Опция 3: Apache (Linux)

### Минимальная установка:
```bash
# 1. Клонирание
cd /var/www/html
sudo git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner

# 2. Включить mod_rewrite
sudo a2enmod rewrite

# 3. Настройка VirtualHost
sudo tee /etc/apache2/sites-available/crypto-scanner.conf > /dev/null << 'EOF'
<VirtualHost *:80>
    ServerName _
    DocumentRoot /var/www/html/crypto-level-breakout-scanner
    
    <Directory /var/www/html/crypto-level-breakout-scanner>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# 4. Активирую
sudo a2ensite crypto-scanner.conf
sudo a2dissite 000-default.conf

# 5. Тест
sudo apache2ctl configtest

# 6. Перезагружу
sudo systemctl restart apache2

# Проверка
curl http://localhost
```

---

## Опция 4: Node.js Express

### Установка:
```bash
# 1. На macOS
brew install node

# 2. На Linux (Debian/Ubuntu)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. Проверка
node --version
npm --version

# 4. Установка зависимостей
npm install

# 5. На Linux - ставлю PM2 для автостарта
npm install -g pm2
pm2 start server.js --name "crypto-scanner"
pm2 startup
pm2 save

# На macOS - только ручный старт
node server.js

# Проверка
curl http://localhost:3000
```

---

## Опция 5: GitHub Pages (бесплатно!)

### Настройка автодеплоя:
```bash
# Приложение автоматически развертывается ат GitHub на push
# По адресу:
https://vasmelip.github.io/crypto-level-breakout-scanner/

# Мануально только гит команды
git add .
git commit -m "Обновление"
git push
```

---

## У меня уже есть сервер - ТОЛЬКО две команды!

### Linux/Ubuntu (SSH)
```bash
ssh user@your-server.com
cd /tmp && git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner
bash DEPLOY.sh  # выберите вариант
```

### Windows (PowerShell до Docker Desktop)
```powershell
git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner
docker build -t crypto-scanner .
docker run -d -p 80:80 crypto-scanner
```

---

## Тестирование после развертывания

```bash
# Все варианты
curl http://localhost/index.html

# Должно вернуть HTML код приложения

# Откройте в браузере
http://localhost

# Кнопка "Анализировать" должна работать
```

---

## Остановка сервиса

### Docker
```bash
docker stop crypto-scanner
docker rm crypto-scanner
```

### Nginx
```bash
sudo systemctl stop nginx
```

### Apache
```bash
sudo systemctl stop apache2
```

### Node.js (PM2)
```bash
pm2 stop crypto-scanner
pm2 delete crypto-scanner
```

### Node.js (мануально)
```bash
# После Ctrl+C
```

---

## Обновление кода

```bash
# Обновить данные из GitHub
cd /var/www/crypto-level-breakout-scanner  # или где у вас
sgit pull origin main

# Пересобрать Docker робраз
# (if using Docker)
docker stop crypto-scanner
docker rm crypto-scanner
docker build -t crypto-scanner:latest .
docker run -d --name crypto-scanner -p 80:80 --restart unless-stopped crypto-scanner:latest
```

---

При всех вопросах Наши Настройки Оси GitHub Issues: https://github.com/vasmelip/crypto-level-breakout-scanner/issues

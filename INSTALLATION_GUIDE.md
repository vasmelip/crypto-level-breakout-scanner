# 📋 Пошаговое руководство по установке Crypto Level Breakout Scanner

## 🎯 Вы уже выполнили первый шаг!

```bash
cd /tmp && git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git && cd crypto-level-breakout-scanner
bash DEPLOY.sh
```

Если эта команда у вас не запустилась, выполните её частями:

```bash
# Шаг 1: Перейдите во временную папку
cd /tmp

# Шаг 2: Клонируйте репозиторий
git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git

# Шаг 3: Перейдите в папку проекта
cd crypto-level-breakout-scanner

# Шаг 4: Просмотрите содержимое
ls -la
```

---

## 🚀 ШАГИ УСТАНОВКИ (Выберите один!)

### ✅ СПОСОБ 1: Docker (САМЫЙ ПРОСТОЙ И РЕКОМЕНДУЕМЫЙ)

#### Шаг 1: Проверка Docker
```bash
docker --version
```

#### Шаг 2: Сборка Docker образа
```bash
cd /tmp/crypto-level-breakout-scanner
docker build -t crypto-scanner:latest .
```

#### Шаг 3: Запуск контейнера
```bash
docker run -d --name crypto-scanner -p 80:80 --restart unless-stopped crypto-scanner:latest
```

#### Шаг 4: Проверка
```bash
docker ps
```

#### Шаг 5: Тестирование
```bash
curl http://localhost
# Откройте в браузере: http://localhost
```

---

### ✅ СПОСОБ 2: Nginx (Linux)

#### Шаг 1: Установка
```bash
sudo apt-get update
sudo apt-get install -y nginx
```

#### Шаг 2: Размещение файлов
```bash
cd /var/www
sudo git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner
sudo chown -R www-data:www-data /var/www/crypto-level-breakout-scanner
```

#### Шаг 3: Конфиг Nginx
```bash
sudo nano /etc/nginx/sites-available/crypto-scanner
```

Вставьте:
```nginx
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
```

#### Шаг 4: Активация
```bash
sudo ln -s /etc/nginx/sites-available/crypto-scanner /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default 2>/dev/null || true
sudo nginx -t
sudo systemctl restart nginx
```

#### Шаг 5: Тестирование
```bash
curl http://localhost
```

---

### ✅ СПОСОБ 3: Apache (Linux)

#### Шаг 1: Установка
```bash
sudo apt-get update
sudo apt-get install -y apache2 libapache2-mod-rewrite
```

#### Шаг 2: Размещение
```bash
cd /var/www/html
sudo git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
```

#### Шаг 3: Включение mod_rewrite
```bash
sudo a2enmod rewrite
```

#### Шаг 4: VirtualHost
```bash
sudo nano /etc/apache2/sites-available/crypto-scanner.conf
```

Вставьте:
```apache
<VirtualHost *:80>
    ServerName _
    DocumentRoot /var/www/html/crypto-level-breakout-scanner
    
    <Directory /var/www/html/crypto-level-breakout-scanner>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

#### Шаг 5: Активация
```bash
sudo a2ensite crypto-scanner.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl restart apache2
```

#### Шаг 6: Тестирование
```bash
curl http://localhost
```

---

### ✅ СПОСОБ 4: Node.js Express

#### Шаг 1: Установка Node.js

**Linux:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**macOS:**
```bash
brew install node
```

#### Шаг 2: Установка зависимостей
```bash
cd /tmp/crypto-level-breakout-scanner
npm install
```

#### Шаг 3: Запуск
```bash
# Способ 1: просто
node server.js

# Способ 2: через PM2 (продакшен)
npm install -g pm2
pm2 start server.js --name "crypto-scanner"
pm2 startup
pm2 save
```

#### Шаг 4: Тестирование
```bash
curl http://localhost:3000
```

---

## 📊 СРАВНЕНИЕ МЕТОДОВ

| Метод | Сложность | Скорость | Надёжность |
|-------|-----------|----------|------------|
| Docker | ⭐ Легко | ⚡ Быстро | ✅ Отличная |
| Nginx | ⭐⭐ Средне | ⚡⚡ Очень быстро | ✅ Отличная |
| Apache | ⭐⭐⭐ Сложно | ⚡ Быстро | ✅ Отличная |
| Node.js | ⭐ Легко | ⚡ Нормально | ⚠️ Требует PM2 |

---

## 🔍 ПРОВЕРКА

```bash
# Docker
docker ps | grep crypto-scanner

# Nginx
sudo systemctl status nginx

# Apache
sudo systemctl status apache2

# Node.js
pm2 status
```

---

## ⚠️ ПРОБЛЕМЫ И РЕШЕНИЯ

**Port 80 is already in use:**
```bash
sudo lsof -i :80
# Остановите конфликтующий процесс
```

**Permission denied:**
```bash
sudo chown -R www-data:www-data /var/www/crypto-level-breakout-scanner
sudo chmod -R 755 /var/www/crypto-level-breakout-scanner
```

**Module not found (Node.js):**
```bash
npm install
```

---

## ✅ ГОТОВО!

Откройте в браузере:
- Docker/Nginx/Apache: http://localhost
- Node.js: http://localhost:3000
- GitHub Pages: https://vasmelip.github.io/crypto-level-breakout-scanner/

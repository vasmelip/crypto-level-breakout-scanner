#!/bin/bash

# Crypto Level Breakout Scanner - Deployment Script
# Поддерживает: Linux (Ubuntu/Debian), macOS
# Использование: bash DEPLOY.sh

set -e

echo "======================================"
echo "🚀 Crypto Level Breakout Scanner Setup"
echo "======================================"
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функции
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Выбор варианта развёртывания
echo "Выберите метод развёртывания:"
echo "1) Docker (рекомендуется)"
echo "2) Nginx (Linux)"
echo "3) Apache (Linux)"
echo "4) Node.js Express"
echo "5) GitHub Pages (только настройка)"
echo ""
read -p "Введите номер (1-5): " choice

case $choice in
    1)
        echo ""
        print_info "Установка Docker..."
        
        # Проверка Docker
        if ! command -v docker &> /dev/null; then
            print_error "Docker не установлен"
            echo "Установите Docker: https://docs.docker.com/get-docker/"
            exit 1
        fi
        
        print_status "Docker обнаружен: $(docker --version)"
        
        # Создание Dockerfile
        cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
EOF
        print_status "Dockerfile создан"
        
        # Сборка образа
        docker build -t crypto-scanner:latest .
        print_status "Docker образ собран"
        
        # Запуск контейнера
        docker run -d \
          --name crypto-scanner \
          -p 80:80 \
          --restart unless-stopped \
          crypto-scanner:latest
        
        print_status "Контейнер запущен"
        echo ""
        print_info "Доступ к приложению: http://localhost:80"
        echo "Проверка статуса: docker ps | grep crypto-scanner"
        echo "Просмотр логов: docker logs -f crypto-scanner"
        ;;
        
    2)
        echo ""
        print_info "Установка Nginx..."
        
        if ! command -v nginx &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y nginx
            print_status "Nginx установлен"
        else
            print_status "Nginx уже установлен: $(nginx -v 2>&1)"
        fi
        
        # Создание конфигурации
        cat > crypto-scanner.conf << 'EOF'
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
        
        # Копирование конфигурации
        sudo cp crypto-scanner.conf /etc/nginx/sites-available/
        sudo ln -sf /etc/nginx/sites-available/crypto-scanner.conf /etc/nginx/sites-enabled/
        sudo rm -f /etc/nginx/sites-enabled/default
        
        # Тестирование конфигурации
        sudo nginx -t
        print_status "Конфигурация Nginx проверена"
        
        # Перезагрузка Nginx
        sudo systemctl restart nginx
        print_status "Nginx перезагружен"
        
        echo ""
        print_info "Доступ к приложению: http://localhost"
        echo "Просмотр статуса: sudo systemctl status nginx"
        echo "Просмотр логов: sudo tail -f /var/log/nginx/access.log"
        ;;
        
    3)
        echo ""
        print_info "Установка Apache..."
        
        if ! command -v apache2 &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y apache2 libapache2-mod-rewrite
            print_status "Apache установлен"
        else
            print_status "Apache уже установлен"
        fi
        
        # Включение mod_rewrite
        sudo a2enmod rewrite
        
        # Создание .htaccess
        cat > .htaccess << 'EOF'
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.html [QSA,L]
</IfModule>
EOF
        
        # Создание VirtualHost
        cat > crypto-scanner.conf << 'EOF'
<VirtualHost *:80>
    ServerName _
    DocumentRoot /var/www/crypto-level-breakout-scanner
    
    <Directory /var/www/crypto-level-breakout-scanner>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    <IfModule mod_expires.c>
        ExpiresActive On
        ExpiresByType text/html "access plus 1 hour"
        ExpiresByType application/javascript "access plus 1 year"
        ExpiresByType text/css "access plus 1 year"
        ExpiresByType image/* "access plus 1 year"
    </IfModule>
</VirtualHost>
EOF
        
        sudo cp crypto-scanner.conf /etc/apache2/sites-available/
        sudo a2ensite crypto-scanner.conf
        sudo a2dissite 000-default.conf
        
        # Тестирование конфигурации
        sudo apache2ctl configtest
        print_status "Конфигурация Apache проверена"
        
        sudo systemctl restart apache2
        print_status "Apache перезагружен"
        
        echo ""
        print_info "Доступ к приложению: http://localhost"
        echo "Просмотр статуса: sudo systemctl status apache2"
        echo "Просмотр логов: sudo tail -f /var/log/apache2/access.log"
        ;;
        
    4)
        echo ""
        print_info "Установка Node.js..."
        
        if ! command -v node &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install -y nodejs
            print_status "Node.js установлен"
        else
            print_status "Node.js уже установлен: $(node --version)"
        fi
        
        # Установка зависимостей
        npm install express cors compression
        print_status "Зависимости установлены"
        
        # Создание server.js
        cat > server.js << 'EOF'
const express = require('express');
const compression = require('compression');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(compression());
app.use(cors());
app.use(express.static(path.join(__dirname, '.')));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/health', (req, res) => {
    res.json({ status: 'ok', uptime: process.uptime() });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
EOF
        
        print_status "server.js создан"
        
        # Установка PM2
        npm install -g pm2
        pm2 start server.js --name "crypto-scanner"
        pm2 startup
        pm2 save
        
        print_status "Приложение запущено через PM2"
        
        echo ""
        print_info "Доступ к приложению: http://localhost:3000"
        echo "Просмотр статуса: pm2 status"
        echo "Просмотр логов: pm2 logs crypto-scanner"
        ;;
        
    5)
        echo ""
        print_info "GitHub Pages настройка"
        echo "Ваш репозиторий уже на GitHub!"
        echo ""
        echo "Приложение доступно по адресу:"
        echo "${GREEN}https://vasmelip.github.io/crypto-level-breakout-scanner/${NC}"
        echo ""
        print_info "Для пользовательского домена:"
        echo "1. Добавьте файл CNAME с вашим доменом"
        echo "2. Настройте DNS записи у вашего регистратора"
        ;;
        
    *)
        print_error "Неверный выбор"
        exit 1
        ;;
esac

echo ""
print_status "Развёртывание завершено!"
echo ""
echo "======================================"
echo "📊 Crypto Level Breakout Scanner Ready"
echo "======================================"

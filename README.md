# 📊 Crypto Level Breakout Scanner

Продвинутый сканер криптовалютных пар для анализа **консолидации и пробоев уровней сопротивления**.

## 🎯 Описание

Приложение анализирует 3-дневный паттерн консолидации:
- **День 1**: Формирует уровень сопротивления (дневной максимум)
- **День 2-3**: Локальные максимумы касаются уровня (тесты)
- **Консолидация**: Локальные минимумы растут, диапазон сужается
- **Сигнал**: Готовность к пробою вверх

## 🚀 Быстрый старт

### Локальный запуск
```bash
# Просто откройте файл в браузере
open index.html
# или
firefox index.html
# или
chrome index.html
```

## 📦 Развёртывание на сервер

### Вариант 1: Apache/Nginx (Статический хостинг)

#### Linux/Unix (Ubuntu/Debian):
```bash
# 1. Клонируем репозиторий
cd /var/www
sudo git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner

# 2. Устанавливаем права
sudo chown -R www-data:www-data /var/www/crypto-level-breakout-scanner
sudo chmod -R 755 /var/www/crypto-level-breakout-scanner

# 3. Для Nginx - создаём конфиг
sudo nano /etc/nginx/sites-available/crypto-scanner

# Добавляем:
server {
    listen 80;
    server_name your-domain.com;  # Замените на ваш домен

    root /var/www/crypto-level-breakout-scanner;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Кэширование
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# 4. Активируем конфиг
sudo ln -s /etc/nginx/sites-available/crypto-scanner /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### Apache:
```bash
# 1. Клонируем
cd /var/www/html
sudo git clone https://github.com/vasmelip/crypto-level-breakout-scanner.git
cd crypto-level-breakout-scanner

# 2. Создаём .htaccess
sudo nano .htaccess

# Добавляем:
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.html [QSA,L]
</IfModule>

# 3. Включаем mod_rewrite
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### Вариант 2: Docker
```bash
docker run -d -p 80:80 --name crypto-scanner nginx:alpine
docker cp index.html crypto-scanner:/usr/share/nginx/html/
docker restart crypto-scanner
```

### Вариант 3: GitHub Pages (FREE)
```bash
# Уже активно!
# Приложение доступно:
https://vasmelip.github.io/crypto-level-breakout-scanner/
```

## 🔧 Использование

1. Откройте приложение
2. Введите торговую пару
3. Настройте параметры
4. Нажмите "Анализировать"

## 📄 Лицензия

MIT License

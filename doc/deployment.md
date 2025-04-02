# 答案之书应用部署指南

## 服务器环境要求

- Linux服务器（veLinux 2.0 CentOS Compatible 64 bit）
- Python 3.8+
- MySQL 8.0+
- Nginx
- Node.js 16+（用于构建前端）

## 后端部署

### 1. 安装Python环境

```bash
# 安装Anaconda（使用清华源）
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
bash Anaconda3-2023.09-0-Linux-x86_64.sh

# 配置conda清华源
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set show_channel_urls yes

# 创建并激活虚拟环境
conda env create -f environment.yml
conda activate answer_book
```

### 2. 安装MySQL

```bash
# 配置阿里云yum源
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo yum clean all
sudo yum makecache

# 配置MySQL阿里云源
sudo wget https://repo.mysql.com/mysql80-community-release-el7.rpm
sudo rpm -ivh mysql80-community-release-el7.rpm
sudo sed -i 's/repo.mysql.com/mirrors.aliyun.com\/mysql/g' /etc/yum.repos.d/mysql-community.repo
sudo yum update
sudo yum install mysql-server
sudo systemctl start mysqld
sudo mysql_secure_installation

# 创建数据库和用户
mysql -u root -p
CREATE DATABASE answer_book;
CREATE USER 'answer_book'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON answer_book.* TO 'answer_book'@'localhost';
FLUSH PRIVILEGES;
```

### 3. 配置后端服务

```bash
# 配置pip豆瓣源
pip config set global.index-url https://pypi.douban.com/simple

# 安装Gunicorn
pip install gunicorn

# 创建systemd服务文件
sudo nano /etc/systemd/system/answer_book.service
```

添加以下内容：

```ini
[Unit]
Description=Answer Book Backend
After=network.target

[Service]
User=your_user
WorkingDirectory=/path/to/backend
Environment="PATH=/path/to/anaconda3/envs/answer_book/bin"
# 2核CPU配置下建议使用2个工作进程
ExecStart=/path/to/anaconda3/envs/answer_book/bin/gunicorn -w 2 -b 127.0.0.1:5000 --timeout 30 --max-requests 1000 --max-requests-jitter 50 app:app

# 资源限制
CPUQuota=180%
MemoryLimit=1.5G

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl start answer_book
sudo systemctl enable answer_book
```

## 前端部署

### 1. 构建Flutter Web应用

```bash
cd frontend
flutter build web --release
```

### 2. 配置Nginx

```bash
# 配置Nginx阿里云源
sudo cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

sudo sed -i 's/nginx.org/mirrors.aliyun.com\/nginx/g' /etc/yum.repos.d/nginx.repo
sudo yum install nginx

# 创建Nginx配置文件
sudo nano /etc/nginx/sites-available/answer_book
```

添加以下内容：

```nginx
server {
    listen 80;
    server_name your_domain.com;

    # 性能优化配置
    worker_connections 256;
    keepalive_timeout 65;
    client_max_body_size 1m;
    client_body_buffer_size 128k;
    
    # 开启gzip压缩
    gzip on;
    gzip_min_length 1k;
    gzip_types text/plain text/css application/javascript application/json;

    # 前端静态文件
    location / {
        root /path/to/frontend/build/web;
        try_files $uri $uri/ /index.html;
        
        # 静态资源缓存策略
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 7d;
            add_header Cache-Control "public, no-transform";
        }
        
        # HTML文件不缓存
        location ~* \.html$ {
            add_header Cache-Control "no-cache";
        }

    # 后端API代理
    location /api/ {
        proxy_pass http://127.0.0.1:5000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```bash
# 启用站点配置
sudo ln -s /etc/nginx/sites-available/answer_book /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 3. 配置HTTPS（推荐）

```bash
# 安装Certbot
sudo yum install certbot python3-certbot-nginx

# 获取SSL证书
sudo certbot --nginx -d your_domain.com
```

## 环境变量配置

创建 `.env` 文件在后端目录：

```env
FLASK_ENV=production
SECRET_KEY=your_secret_key
DATABASE_URL=mysql://answer_book:your_password@localhost/answer_book
```

## 部署检查清单

- [ ] 后端服务是否正常运行（`sudo systemctl status answer_book`）
- [ ] 数据库连接是否正常
- [ ] Nginx配置是否正确（`sudo nginx -t`）
- [ ] HTTPS证书是否正常工作
- [ ] 前端静态文件是否正确部署
- [ ] API请求是否正常响应
- [ ] 环境变量是否正确配置

## 常见问题

1. 如果遇到权限问题，请检查文件权限和用户权限
2. 如果前端访问后端API失败，检查Nginx代理配置和CORS设置
3. 如果数据库连接失败，检查数据库用户权限和连接字符串

## 维护建议

1. 定期备份数据库
2. 监控服务器资源使用情况（2核2G配置需特别关注）：
   - CPU使用率不应持续超过80%
   - 内存使用率控制在85%以下
   - 定期清理日志和临时文件
3. 及时更新安全补丁
4. 配置日志轮转（建议保留最近7天日志）
5. 设置监控告警
6. MySQL优化建议：
   - innodb_buffer_pool_size设置为512M
   - max_connections限制为100
   - 开启慢查询日志，设置long_query_time=2
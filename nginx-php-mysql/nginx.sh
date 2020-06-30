#!/bin/bash 
#the user executing this script is not root, so sudo is needed
sudo cat > /etc/yum.repos.d/nginx.repo <<EOL
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/8/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOL
sudo dnf makecache
sudo dnf install vim nginx -y
 #add '' to EOL to don't interpret the $uri variable
sudo cat > /etc/nginx/conf.d/default.conf <<'EOL' 
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
    location ~ \.php$ {
        try_files $uri =404;
        root           /usr/share/nginx/html;
        fastcgi_pass   unix:/run/php-fpm/www.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
EOL
sudo cat > /usr/share/nginx/html/index.php <<'EOL'
<?php
$servername = '172.19.42.20:3306';
$username = "nour";
$password = "Hello123?";

try {
  $conn = new PDO("mysql:host=$servername;dbname=vagrant", $username, $password);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  #$version= $conn->query('select version()')->fetchColumn();
  echo "<h3 style=\"color:##373131; text-align:center; font-size: 150%;\";> Connected to Mysql! </h3>";
    }

catch(PDOException $e)
    {
   echo "<h3 style=\"color:#f71818; text-align:center; font-size: 150%;\";> ERROR: " . $e->getMessage() ."</h3>";

    }
?>
EOL
sudo systemctl enable --now nginx
sudo systemctl enable --now firewalld
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --reload
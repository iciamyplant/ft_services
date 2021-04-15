wp core install --url=localhost --title=Example --admin_user=supervisor --admin_password=strongpassword --admin_email=info@example.com --path=/var/www/localhost/htdocs/wordpress
wp user create bob bob@example.com --role=author --path=/var/www/localhost/htdocs/wordpress
wp user create ann ann@example.com --porcelain --path=/var/www/localhost/htdocs/wordpress
wp user create bernard bernard@example.com --role=contributor --path=/var/www/localhost/htdocs/wordpress

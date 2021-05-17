# ft_services

KUBERNETES :
- Déploiement : un objet qui exécute et gère N instances d'une image Docker donnée. Par exemple, vous pouvez avoir un déploiement qui lancera et gérera 10 serveurs Apache.
- Service : un objet qui lie un déploiement en externe ou à d'autres conteneurs. Par exemple, un déploiement qui liera l'IP 192.168.0.1 aux 10 serveurs Apache et choisira celui qui a le moins de charge de travail. 
Le service existe car sinon communiquer grâce aux IP entre pods pose problème. Si un pod crash et qu’on le remplace nouvelle adresse IP. Et alors communication rompue. 
C’est une IP address permanent.
Le cycle de vie des pods et des services est indépendant. Même si le pod meurt l’IP adress du service reste.

Différents services :
external services (accessible de l'extérieur)
internal services (genre la base de donnée) (configmap et secret)
tu peux tester en allant sur ton browser et tappant http://*adressedunnoeud*:*portduservice*

Pod : un pod est une instance en cours d'exécution d'un déploiement, vous pouvez y exécuter un shell. Il a sa propre adresse IP et sa propre espace mémoire. Les pods peuvent communiquer entre eux grace à cette adresse.
si un pod redémarre car il a crashé on perd toute la data : volumes attaches a physical stockage on local machine (ou cloud)
replicate : on va repliquer comme ca si y a un pod qui die y a un replica en place. Le replica est connecté au même service.

Le service a 2 fonctionnalités :
- une adresse IP permanente
- un load balancer
= define blueprints pour dire combien de replicas on veut dans le déploiement
la database peut pas etre repliquée dans le deploiement : statefulset
MINIKUBE & KUBECTL :
Minikube est le logiciel que nous utilisons pour créer une machine virtuelle qui exécute Kubernetes et assure la compatibilité avec VirtualBox.
C'est un programme avec en ligne de commande kubectl qui simule un environnement sur kubernetes pour s'entraîner, c'est donc sur ça que se fait tout le projet ft_service.

Dans minikube : un noeud dans lequel y a : les noeuds esclaves + le noeud master + docker préinstallé. C’est un cluster a noeud unique.
minikube marchera sur notre ordi via une virtualbox 
Une fois qu’on a créé un minicluster sur notre ordi, il faut interagir avec ce cluster. Créer des configs etc. C’est à ca que sert kubcetl qui est un outil en ligne de commande pour les clusters kubernetes.
api server : point d’entrée dans notre cluster. C’est l’API server qui permet après de communiquer avec le cluster. Et pour parler avec l’api server il faut parler avec kubectl


Etape 1: Bien comprendre ce qu’on me demande 
j'avais lu ce github au début pour me faire une idée plus précise de ce qui était attendu du projet : https://github.com/t0mm4rx/ft_services


Mettre une infrastructure de plusieurs déploiements en place. Chaque déploiement exécute une image Docker donnée N fois. Un déploiement de 2 serveurs Nginx par exemple.
Dans chaque déploiement tournera un pod (=un conteneur) et un replica (=copie du conteneur) ayant sa propre adresse IP. En effet, Kubernetes va fournir un service de routage en assignant une adresse IP privée par conteneur.
Ensuite faire des liens entre les conteneurs : par exemple, si vous avez un site Web dans un conteneur qui a besoin d'une base de données d'un autre conteneur, vous devez créer un service, qui créera un accès facile au conteneur de base de données.


avec un load balancer metallb: un service qu’il faut juster installer
Ici le load balancer doit utiliser une seule adresse ip. Le réseau a donc une adresse IP externe.
Et va équilibrer la charge du trafic vers les différents pod. Les requêtes de services sont alors transférées par kubernetes vers un des pods du service.


Etape 2 : Docker, mini kube, metallb:
Installer Docker
Petits rappels (build des images, dockerfile, run ….) Rappel de toutes les commandes Docker : https://blog.ippon.fr/2014/10/20/docker-pour-les-nu-pour-les-debutants/
sudo docker images
sudo docker container ls (= sudo docker ps, liste les container qui sont en train de tourner)
sudo docker ps -a (tous les container pas que ceux en train de run)
sudo docker run *nomdelimage* : on va voir une boucle infinie pour pas de boucle infinie faire: sudo docker run -d *nomimage*
les ports : rediriger le port 80 interne au container au port 8080 de la machine hôte : sudo docker run -d -p 8080:80 *nomimage*
rediriger plusieurs ports : sudo docker run -d -p 8080:80 -p 3000:80 *nomimage*
docker stop *nomcontainer*
docker start *nomcontainer*
sudo docker rm $(sudo docker ps -aq) = (supprimer tous les containers)
sudo docker rm -f $(sudo docker ps -aq) = (supprimer tous les containers, meme ceux en train de run)
sudo docker exec -it *nomconteneurouid* bash (-i for interactive)
sudo docker exec --help


Installer minikube et kubectl
Minikube comporte de nombreux outils, tels qu'un tableau de bord pour voir comment vont vos pods. https://kubernetes.io/fr/docs/tasks/access-application-cluster/web-ui-dashboard/
kubectl get nodes ou pods (=permet de connaitre le statut des nodes)
kubectl get deployment (pour avoir tous les déploiements en cours)
kubectl get replicaset
minikube status
kubectl get services (c’est là que sont écrits ClusterIP)
Minikube = juste pour démarrer et supprimer le cluster
kubectl = tout le reste, toutes les configs de notre cluster
Dans kubernetes tu ne crée pas des pods direct. Tu crée des déploiements qui créent les pods
kubectl create deployment NAME --image=image
kubectl create deployment nginx-depl --image=nginx
une fois que t’as créé un deploiement et que tu fais kubectl get pod, tu vois le pod de ton déploiement
pour debug :
kubectl logs *nomdupod*
kubectl exec -it *nomdupod* bash

kubectl apply -f *filename* : créer et udpater un deploiement
mm si g fait des changements meme commande ca va juste mettre à jour le deploiement
kubectl delete -f *file*
kubectl delete deployment ...
service:
kubectl get svc
minikube service list 
kubectl delete service service_name
pour que un service LoadBalancer partage son ip: 
annotations:
	metallb.universe.tf/allow-shared-ip: shared

the connection to the server 127.0.0.1:49153 was refused - did you specify the right host or port ? : refaire commande : minikube start --vm-driver=docker

---------debugging pods https://www.youtube.com/watch?v=Wf2eSG3owoA
      	>   kubectl exec -it FullDeployName -- /bin/sh (exécuter des commandes dans un container)


installer metallb 
https://minikube.sigs.k8s.io/docs/commands/addons/
en lançant des 'manifest' en gros des scripts de config dans kubernetes qui font tout le travail. Ca va surtout servir à attribuer des IP a tes services, et comme dans ce projet, on veut qu'ils aient tous la même adresse IP : il suffit de le configurer en mettant une range d'adresses IP avec 2 fois la même adresse IP, et donc celle que tu génères en faisant la commande du point 4/ du notion au dessus.
https://metallb.universe.tf/installation/ : (installation)
Minikube IP : CLUSTER_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"

erreur a la premire install :
pod/speaker-htxfd                 0/1     CreateContainerConfigError
il faut faire : eval $(minikube docker-env)
et mettre le secret
https://devopslearning.medium.com/metallb-load-balancer-for-bare-metal-kubernetes-43686aa0724f
kubectl get all



Etape 3 :
Nginx :
installer nginx
configuer
ssl
ingress
voir les nginx en cours : sudo lsof -nP | grep LISTEN
→ dabord installer nginx :
apk add nginx
nginx -d daemon off
sleep infinity
→ ensuite configurer. docker exec -ti test4 bin/sh et pas bash
https://www.youtube.com/watch?v=4SswbTwkOZA
https://www.youtube.com/watch?v=X3Pr5VATOyA
https://codingwithmanny.medium.com/configure-self-signed-ssl-for-nginx-docker-from-a-scratch-7c2bcd5478c6
firefox redirects http to https

FTPS :
Etape 1 : Créer un serveur FTP
Ca ressemble à Nginx, il faut apk add vsftpd
démarrer vsftpd avec  : service vsftpd start ; sleep infinity
Avant de faire les config tu peux rentrer dans le conteneur tester s’il tourne avec service vsftpd status
Ensuite faut savoir que pour tester mon serveur ftp j’ai utilisé deux trucs différents :
Le premier c’est la commande : ftp -v -p localhost
Qui va servir à voir les retours d’erreur et vérifier si ça fonctionne. 
Le second c’est le logiciel FileZilla, que j’ai téléchargé. Et ensuite quand t’ouvre le logiciel genre la partie à gauche c’est les fichiers de ton ordinateur donc de la vm et la partie à droite c’est les fichiers de ton serveur. Et FileZilla il me servait à tester si j’arrive à transférer de la gauche à la droite un fichier(en mode drag and drop). (+ attention aux droits du fichier). Dans FileZilla t’as plusieurs cases : en haut t’as “host” là tu pourras mettre 172.0.0.1 ensuite t’as username password :
Donc il faut créer l’utilisateur et son mot de passe qui a accès au serveur FTP.
RUN adduser -D ftpuser ; echo "ftpuser:password"  | chpasswd
Faut utiliser la commande adduser. Ici l’utilisateur c’est ftpuser et le mot de passe c’est password.
pour le port c’est 21. Mais ca marche pas si on ouvre pas plusieurs port pas seulement le 21 de base. Faut ouvrir le 20 et j’ai ouvert aussi les 21009 21010 et 21011.


Etape 2 : Faire les configs
Ensuite il faut modifier le fichier de config vsftpd.conf
J’ai suivi plusieurs tutos
ici t’as tout le man des configs : http://vsftpd.beasts.org/vsftpd_conf.html
→ perso au début j’avais une erreur je crois c’était 501 et du coup j’avais trouvé sur un forum cette commande : seccomp_sandbox=NO dans le fichier config et ça m'avait enlevé mon erreur.

→ Là tu peux tester et normalement avec ftp il va se connecter à ton serveur et il va te demander user et le mot de passe et ensuite il te dira si tout est OK.

Etape 3 : Ajouter le ssl pour avoir un serveur FTPS
un tuto qui m’a aidé : https://www.youtube.com/watch?v=TrTrTHALWjg
apk add openssl ; openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=France/L=Paris/O=42/OU=42/CN=localhost" -keyout /etc/ssl/private/example.key -out /etc/ssl/private/example.crt
configurer le fichier vsftpd.conf pour le certificat ssl dans le fichier config: 
ssl_enable=YES
rsa_cert_file=/etc/ssl/private/example.crt
rsa_private_key_file=/etc/ssl/private/example.key
Y a d’autres configs que j’ai ajouté autour du ssl mais je sais pas trop si elles sont obligatoires. Tu peux check dans le man à quoi sert chaque config si tu te demande
faut savoir que là par contre pour tester j’ai plus utilisé ftp -v -p localhost parce que y a pas écrit si le certificat ssl est activé ou pas. Du coup j’ai installé les packages qu’il fallait et j’ai utilisé ftp-ssl -v -p localhost.

→ attention faut pouvoir transférer les fichiers de gauche à droite avec FileZilla.



wordpress:
->installer nginx tout comme pour le container nginx mais sans ssl
→installer et configurer wordpress:
wget -c http://wordpress.org/latest.tar.gz , puis l’extraire dans le www avec tar -xzvf latest.tar.gz
ajouter le wp-config.php contenant les infos de la database (pour DB_HOST on mettra pas localhost mais le nom du service mysql, sinon on remplace DB_NAME, DB_USER et DB_PASSWORD par les noms que on va donner dans le .sql(voir installation mysql))


Créer des Users et automatiser l’installation wordpress (avec wp cli):
installation: https://wp-cli.org/
https://make.wordpress.org/cli/handboocd /guides/installing/
->installer l’extension php phar pour que ca marche:
apk add php-phar
->installer wcli : 
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar ; mv wp-cli.phar /usr/local/bin/wp : le rendre exécutable avec la commande wp :https://developer.wordpress.org/cli/commands/
automatiser l’installation:
wp core install --url=172.17.0.2:5050 --title=mywebsite --admin_user=leboss --admin_password=password --admin_email=test@gmail.com --skip-email --path=/home/www/wordpress
créer un user:
wp user create user_name user_name@gmail.com --role=editor --path=/home/www/wordpress
on peux remplacer le role editor par administrator, author, contributor, ou subscriber histoire d’avoir plusieurs types

=> pour vérifier aller au site d’installation et ajouter /wp-admin
=> verifier les users dans l’onglet users

→installer php (car wordpress c’est full fichier .php):
apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
→configurer nginx pour qu’il gère wordpress:


config du .conf:
dans la directive server:
->pour wordpress
listen 5050
root /chemin/vers/dossier/wordpress
index index.php
->pour php:
       location ~ \.php$ {
              fastcgi_pass      127.0.0.1:9000;
              fastcgi_index     index.php;
              include           fastcgi.conf;
        }

Comme on veut accéder à mysql depuis wordpress il faut aussi installer mariadb:
apk add mariadb mariadb-common mariadb-client ; /etc/init.d/mariadb setup
démarrer tout les service dont wordpress a besoin:
rc-service php-fpm7 start ; rc-service nginx start 
Mysql:
-installer mysql: https://techviewleo.com/how-to-install-mariadb-on-alpine-linux/
apk add mariadb mariadb-common mariadb-client
-créer un user et lui accorder tout les droit sur la database: mysql < fichier.sql dans le CMD
- creer le .sql: https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
CREATE DATABASE nomDatabase;
GRANT ALL ON nomDatabase.* TO 'nomUser'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
Phpmyadmin:
comme pour wordpress, on reinstalle nginx sans ssl
installation: https://wiki.alpinelinux.org/wiki/PhpMyAdmin
installer php:

les même package que pour wordpress:
apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
avec eux en bonus:
apk add php7-fpm php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom

installer phpmyadmin(ici on creer un lien symbolique pour le laisser dans /usr/share/webapps et qu’il soit accessible dans notre www):
mkdir -p /usr/share/webapps ; cd /usr/share/webapps ; wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz ; tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz ; rm phpMyAdmin-5.0.2-all-languages.tar.gz ; mv phpMyAdmin-5.0.2-all-languages phpmyadmin ; chmod -R 777 /usr/share/webapps/ ; ln -s /usr/share/webapps/phpmyadmin/ /home/www/phpmyadmin

configurer phpmyadmin(avec config.inc.php):
ajouter le fichier config.inc.php dans /usr/webapps/phpmyadmin/
->par défaut phpmyadmin est configuré sur localhost donc remplacer par le nom du service mysql:
$cfg['Servers'][$i]['host'] = 'nom_service_mysql';

le .conf nginx:
root /chemin/vers/dossier/phpmyadmin
index index.php

deployment: https://www.serverlab.ca/tutorials/containers/kubernetes/deploy-phpmyadmin-to-kubernetes-to-manage-mysql-pods/
modif dans le tuto:
pour le deployment remplacer les port 80 par des 5000 et le PMAHOST par le nom de notre service mysql, et le MYSQL_ROOT_PASSWORD par le mdp mysql et changer limage par l’ image local en ajoutant aussi imagePullPolicy: Never
pour le service changer en Load balancer, ajouter le partage d’IP et remplacer le port 80 en 5000 :
annotations: (sous metadata)
      	metallb.universe.tf/allow-shared-ip: shared
type: LoadBalancer
  loadBalancerIP: 172.17.0.2


comme phpmyadmin utilise la base de donnee on installe mariadb avec:
apk add mariadb mariadb-common mariadb-client ; /etc/init.d/mariadb setup

et on oublie pas de start nginx et php-fmp7 au lancement du container

Persistent volumes: (lier mysql et wordpress):
on va save notre dossier/var/lib/mysql avec un persistentVolumeClaim (PVC)
https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/
Modif du tuto:
remplacer par nos images local (ajouter imagePullPolicy: Never)
réduire les 20 Gi a 500Mi (suffisant)
on peut retirer le PVC du wordpress
> si le contenue est écrasé juste appeler les commandes pour setup mysql dans le run du dockerfile et non avant
si après avoir tout déployé dans le navigateur il s’affiche :error establishing a database connexion, tenter d’ajouter au dockerfile mysql:
RUN echo -e "\n[mysqld]\nskip-networking=0\nskip-bind-address\n" >> /etc/my.cnf

https://mariadb.com/kb/en/configuring-mariadb-for-remote-client-access/


Redirection 307 : redirection interne. The request ressource is moved to another URI
http://nginx.org/en/docs/beginners_guide.html
location /wordpress = fait référence au chemin relatif qui est dans l'URL

Reverse Proxy : permet à un utilisateur d’internet (externe) d’accéder à des serveurs internes. Joue le role d’intermédiaire de sécurité car permet aux serveurs internes de les protéger des attaques externes. Permet un point de filtrage aux ressources internes.
il permet de porter le chiffrement ssl
accélere la navigation
réparittion de charge des requêtes externes

La redirection 307 vers wordpress et le reverse proxy vers phpmyadmin:
redirection:
location /wordpress {
            	return 307 http://$host:5050;
    	}
reverse proxy:
location /phpmyadmin/ {
            	proxy_set_header X-Forwarded-Proto https; (pour gerer le https sinon il rale)
            	proxy_pass http://172.17.0.2:5000/;    (demande au proxi de nous emmener a cette addresse)
    	}
si quand tu te log il y a error 404 not found, ajouter:
 $cfg['PmaAbsoluteUri'] = './'; dans le phpmyadmin/conf.inc.php pour l’aider a trouver les fichiers


Utile pour tous les containers:
rc-status    pour lister les services


dashboard :
minikube dashboard pour ouvrir le dashboard
→ on passe par les addons = modules complémentaires de minikube
minikube addons list
et ajouter des addons s’ils s’y trouvent pas : minikube addons enable ADDON_NAME [flags]


Probleme Disk Pressure :
fd -h --total pour avoir le disque utilisé


log=install-$(date +%F%H%M%S).log
DB=mysql 	# mysql, mariadb 
DB_VERSION=5.7	# tag/version
MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
MYSQL_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

GITEA_VERSION=1.3.2

GITEA_DB_VOLUME=gitea-db
GITEA_DATA_VOLUME=gitea-data

GITEA_UI_PORT=3000
GITEA_SSH_PORT=2200

# Uses the variables in the app.ini configuration file
echo "Uses MySQL password and UI and SSH ports to generate the configuration file.\n" >> $log
sed -e "s/GITEADBPASSWORD/$MYSQL_PASSWORD/g" -e "s/GITEAUIPORT/$GITEA_UI_PORT/g" -e "s/GITEASSHPORT/$GITEA_SSH_PORT/g" tpl.app.ini > app.ini

echo "Downloading GITEA docker image..." >> $log
sudo docker pull gitea/gitea:$GITEA_VERSION


echo "Downloading $DB docker image..." >> $log
sudo docker pull $DB:$DB_VERSION

echo "Creating data volume $GITEA_DATA_VOLUME ..." >> $log
sudo docker volume create $GITEA_DATA_VOLUME

echo "Creating data volume for Gitea's DB..." >> $log
sudo docker volume create $GITEA_DB_VOLUME

echo "Creating a user-defined bridge..." >> $log
sudo docker network create gitea-net

echo "Copying Gitea conf to $GITEA_DATA_VOLUME..." >> $log
sudo docker run --rm -d --name gitea --mount source=$GITEA_DATA_VOLUME,target=/data gitea/gitea:$GITEA_VERSION sleep 60
sudo docker cp $PWD/app.ini gitea:/data/gitea/conf
sudo docker stop gitea

echo "Launch $DB container..." >> $log
sudo docker run -d --name gitea-db -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=gitea -e MYSQL_USER=gitea -e MYSQL_PASSWORD=$MYSQL_PASSWORD  --mount source=$GITEA_DB_VOLUME,target=/var/lib/mysql --network gitea-net $DB:$DB_VERSION

echo "Launch Gitea $GITEA_VERSION container..." >> $log
sudo docker run -d --name gitea  --network gitea-net -p $GITEA_SSH_PORT:22 -p $GITEA_UI_PORT:3000 --mount source=$GITEA_DATA_VOLUME,target=/data gitea/gitea:$GITEA_VERSION

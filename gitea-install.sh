
DB=mysql 	# mysql, mariadb 
DB_VERSION=5.7	# tag/version
MYSQL_ROOT_PASSWORD=VucWftX5ITR7
MYSQL_PASSWORD=GHh5R9AySsyT

GITEA_VERSION=1.3.2

GITEA_DB_VOLUME=gitea-db
GITEA_DATA_VOLUME=gitea-data

GITEA_UI_PORT=3000
GITEA_SSH_PORT=22


if [ $GITEA_VERSION != "latest" ]
then
  echo "Downloading GITEA docker image..."
  sudo docker pull gitea/gitea:$GITEA_VERSION
fi

echo "Downloading $DB docker image..."
sudo docker pull $DB:$DB_VERSION

echo "Creating data volume $GITEA_DATA_VOLUME ..."
sudo docker volume create $GITEA_DATA_VOLUME

echo "Creating data volume for Gitea's DB..."
sudo docker volume create $GITEA_DB_VOLUME

echo "Creating a user-defined bridge..."
sudo docker network create gitea-net

echo "Launch $DB container..."
sudo docker run -d --name gitea-db -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=gitea -e MYSQL_USER=gitea -e MYSQL_PASSWORD=$MYSQL_PASSWORD  --mount source=$GITEA_DB_VOLUME,target=/var/lib/mysql --network gitea-net $DB:$DB_VERSION

echo "Launch Gitea $GITEA_VERSION container..."
sudo docker run -d --name gitea  --network gitea-net -p 2200:22 -p 3000:3000 --mount source=$GITEA_DATA_VOLUME,target=/data gitea/gitea:$GITEA_VERSION

echo "Copying configuration to gitea container..."
sudo docker cp $PWD/app.ini gitea:/data/gitea/conf 

echo "Restart Gitea container to reload copied config..."
sudo docker stop gitea
sudo docker start gitea


DB=mysql 	# mysql, mariadb 
DB_VERSION=5.7	# tag/version

GITEA_VERSION=1.3.2
GITEA_DATA_VOLUME=data-gitea

GITEA_UI_PORT=3000
GITEA_SSH_PORT=22

if [ $GITEA_VERSION != "latest" ]
then
  echo "Downloading GITEA docker image..."
  sudo docker pull gitea/gitea:$GITEA_VERSION
fi

echo "Downloading $DB docker image..."
sudo docker pull $DB:$DB_VERSION


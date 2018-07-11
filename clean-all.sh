sudo docker stop gitea-db
sudo docker rm gitea-db
sudo docker stop gitea
sudo docker rm gitea
sudo docker volume rm gitea-data
sudo docker volume rm gitea-db
sudo docker network rm gitea-net


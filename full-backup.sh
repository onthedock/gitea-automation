# ref: https://docs.gitea.io/en-us/backup-and-restore/
# Creates a full backup on the root of the container's filesystem
sudo docker exec -it gitea /app/gitea/gitea dump

# You can use `docker cp` to copy from the gitea container to you local host:
# sudo docker cp gitea:/gitea-dump-#####.zip .

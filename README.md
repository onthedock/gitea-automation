# Automating Gitea installation

Just for the fun of it, I've decided to automate the process of seting up a Gitea server using Docker.
I did not want to use Docker Compose so I went with old plain containers.
The script pulls the [MySQL](https://hub.docker.com/_/mysql/) and [Gitea](https://hub.docker.com/r/gitea/gitea/) images from Dockerhub, creates the named volumes for both the
database and the Gitea container and the custom bridged network to allow communication between them.

I decided to use a _premade_ configuration file for Gitea (https://gitea.io) using the IP for my lab host... It would be nice
if the script modified the configuration file with the actual IP of the host on wich the container
will run.

The script also stores the plaintext password for the root and gitea users for the DB, which is not the ideal solution.

So there's a lot to improve! 

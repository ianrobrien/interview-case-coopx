#!/bin/bash
cd /home/ec2-user/twitflow || exit
docker-compose down
docker system prune -a -f
docker-compose build --no-cache
docker-compose up -d

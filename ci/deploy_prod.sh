#!/usr/bin/env bash

BUILD_PROFILE="prod"
PORT="7088"
LOGIN_COMMAND="login --username=shiyaost@126.com -p=sleep1234... registry.cn-shenzhen.aliyuncs.com"
DOCKER_NAME="obowin_web"
repo="registry.cn-shenzhen.aliyuncs.com/obowin/${DOCKER_NAME}:latest"
REMOTE_SERVER="root@120.79.154.128"
JOB_NAME=${DOCKER_NAME}

# Docker
echo Start to build docker...

cd ci
rm -rf dist
cp -rf ../src ./dist
docker build -t ${DOCKER_NAME} .


docker ${LOGIN_COMMAND}
docker tag ${DOCKER_NAME} ${repo}
docker push ${repo}

# Deploy
echo deploy to remote server...

ssh ${REMOTE_SERVER} "
docker ${LOGIN_COMMAND};
docker pull ${repo};
docker rm -f $JOB_NAME || true;
docker run -d -p ${PORT}:80 --name ${JOB_NAME} ${repo};"


######
#docker login --username=shiyaost@126.com -p=sleep1234... registry.cn-shenzhen.aliyuncs.com
#docker pull registry.cn-shenzhen.aliyuncs.com/obowin/sports_admin_qa:latest
#docker rm -f sports_admin_qa || true
#docker run -d -p 7111:80 --name sports_admin_qa registry.cn-shenzhen.aliyuncs.com/obowin/sports_admin_qa:latest


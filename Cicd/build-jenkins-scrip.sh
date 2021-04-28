#/bin/bash

if [ "x$ALLOWDEBUG" != "xtrue" ]; then
  export DEBUG=false
fi

if [ "$DEBUG" == "true" ]; then
  set -xv
fi

sudo docker rmi $(sudo docker images --quiet --filter "dangling=true") || true

echo "------------------------------------------------------------------------"
echo "INFO: Start building docker images with git@git.eway.vn:tech-core/docker-helper.git"
echo "------------------------------------------------------------------------"


set -e
if [ ! -d docker-helper ]; then
	git clone git@git.eway.vn:x10-core/docker-helper.git
fi

cd docker-helper
git reset --hard
git checkout master
git pull
cd ${PROJECT_PATH}
echo "MAVEN_PROFILES=$MAVEN_PROFILES"
for i in ${MAVEN_PROFILES}; do
  rm -rf package || true
  mvn -f ../../../sources/pom.xml -U clean install -Papp -Dapp.name=${i}
  timeout 60m bash ./docker-helper.sh \
    --destinationProject ../../../sources \
    --pushToDocker true \
    --registryServer ${DOCKER_REGISTRY} \
    -M ${i}
done


if [ ! $? -eq 0 ]; then
	echo "------------------------------------------------------------------------"
	echo "ERROR: Build image with Docker failed!"
	echo "------------------------------------------------------------------------"
fi 
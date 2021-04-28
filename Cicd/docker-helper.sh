#!/bin/bash -e

PREV_STEP=0
STEP=0
TS=`date +%Y%m%d_%H%M%S`
if [ "${DEBUG}" == "true" ]; then
  set -xv
fi
function echo_type()
{
  if [ $# -eq 1 ]; then
    infotype="\e[92mINFO:"
    msg=$1
  else
    infotype="$1"
    msg="$2"
  fi
  if [ $PREV_STEP != $STEP ]; then
    HIGHLIGHT=" >> "
    PREV_STEP=$STEP
    SUBSTEP="0"
    echo "--"
    infotype="\e[45m\e[1m${infotype}"
  else
    HIGHLIGHT="    "
    SUBSTEP=$((SUBSTEP+1))
  fi
  echo -e "$infotype [${STEP}.${SUBSTEP}] $HIGHLIGHT $msg $HIGHLIGHT\e[0m\e[90m"
}

function echo_info()
{
  echo_type "\e[92mINFO:" "$1"
}

function echo_warning()
{
  echo_type " \e[5m \e[93mWARNING:" "$1"
}

function echo_debug()
{
  echo_type "  \e[94mDEBUG:" "$1"
}

function increase_step()
{
  STEP=$((STEP +1))
}

function usage
{
 echo_warning "\nUsage: \
 \n `basename $0` \
 \n-r | --localRepo, default: EMPTY\
 \n-s | --registryServer, default: docker.eway.vn\
 \n-p | --pushToDocker, default: false\
 \n-P | --registryServerUIPort, default: 8989\
 \n-d | --destinationProject, default: rewardb-backend\
 \n-a | --applicationIdentification, default: :adflex-rest: \
 \n-M | --mavenProfile, default: :adflex-rest: \
 \n-h | --help"
 exit 1
}

function validateInput()
{
  i=0
  while [ "$1" != "" ]; do
      case $1 in -r | --localRepo ) localrepoUrl=$2;;
	  -s | --registryServer ) registryServer=${2};;
	  -p | --pushToDocker ) pushToDocker=${2};;
	  -P | --registryServerUIPort ) registryServerUIPort=${2};;
	  -d | --destinationProject ) destinationProject=$2;;
	  -a | --applicationIdentification ) applicationIdentification=$2;;
	  -M | --mavenProfile ) mavenProfile=$2;;
	  -h | --help) usage
	  exit
	  ;;
    esac
	  shift
	  shift
  done

  if [ -z $destinationProject ]; then
    usage
  fi
  
  registryServer=${registryServer:-"docker.eway.vn"}
  pushToDocker=${pushToDocker:-"false"}
  registryServerUIPort=${registryServerUIPort:-"8989"}
  applicationIdentification=${applicationIdentification:-":adflex-rest:"}
  mavenProfile=${mavenProfile:-"adflex-rest"}

}

validateInput $@

echo_info "Start building docker image $destinationProject with info: "
echo_debug "localRepo=${localRepo} \n registryServer=${registryServer} \n pushToDocker=${pushToDocker} \n registryServerUIPort=${registryServerUIPort} \n destinationProject=${destinationProject}"
if [ ! -z $localrepoUrl ]; then
  maven_repo_local="-Dmaven.repo.local=`readlink -f ${localrepoUrl}`"
  echo_info "maven_repo_local: $maven_repo_local"
fi

rm -rf package || true
mkdir -p package/app/bin/ || true

pushd $destinationProject
tmp_file=/tmp/${USER}.docker.tmp
rm -f ${tmp_file}* || true

mvn help:effective-pom -Papp -Dapp.name=${mavenProfile} > $tmp_file
artifact_full=`grep  -A 2 "Effective POM for project" $tmp_file | grep -E ":.*:" | grep $applicationIdentification | sed -r "s/.*'(.*):(jar|zip):([^']+)'.*/\1:\3:zip/g" `
image_full=`grep  -A 2 "Effective POM for project" $tmp_file | grep -E ":.*:" | grep $applicationIdentification | sed -r "s/.*'(.*):(.*):(jar|zip):([^']+)'.*/\1\/\2_zip_bin:\4/g"`
image_url=`echo $image_full | sed 's#/#%252F#g'| sed -r 's#:[^:]+$##g'`
final_image_url="http://${registryServer}:${registryServerUIPort}/tags/$image_url"
echo_debug " final_image_url= $final_image_url"
image_full=`echo ${registryServer}/${image_full} | sed -r "s#//+#/#g" `
image_full=${image_full}-${mavenProfile}


echo_debug " image_full=$image_full"
artifact_full="${artifact_full}"
echo_debug " artifact_full=$artifact_full"

if [ -z $artifact_full ]; then
  echo_warning "ERROR: cannot get full artifact information"
  exit 1
fi
popd

pushd package/app/
if [ `echo $artifact_full | grep -c SNAPSHOT ` -gt 0 ]; then
  repoUrl=http://repo.eway.vn/artifactory/snapshots
else
  repoUrl=http://repo.eway.vn/artifactory/releases
fi

increase_step
echo_info " start to download package from repository $repoUrl"

mvn -U dependency:copy $maven_repo_local -DrepoUrl=$repoUrl \
  -Dartifact=$artifact_full \
  -DoutputDirectory=./ | tee $tmp_file.mvn

if [ ` grep -c 'BUILD FAILURE' $tmp_file.mvn ` -gt 0 ]; then
  echo_warning "ERROR:: Got BUILD FAILURE while downloading the package, exit!"
  exit 1
fi
f=`ls ./ -tr | tail -1`

unzip -q $f -d tmp && rm -f $f
f2=`ls tmp/ | tail -1 `
cp tmp/$f2/* . -r
rm -rf tmp/

popd

increase_step
echo_info " Apply docker template to x10 "
cp -r template/app package/


echo_info " the package is ready is ready for docker build"



increase_step
echo_info " start building the image with: [sudo docker build -t $image_full .] "

sudo /usr/sbin/service docker start || true
sudo docker build -t $image_full . | tee $tmp_file.build
docker_build_stat=`grep -c "Successfully built" $tmp_file.build`
if [ $docker_build_stat -gt 0 ]; then
  echo_info " docker image $image_full has been built"
  if [ "x$pushToDocker" == "xtrue" ]; then
    
    increase_step
    
    echo_info " start pushing the image [sudo docker push $image_full ] "
    sudo docker push $image_full
    echo_info " the image should be there: $final_image_url "
    
  fi
  
  increase_step
  echo_info " it is now ready for you to start a container with [docker run -ti $image_full]"
  
else
  echo_warning "ERROR happened while building the image $image_full"
fi

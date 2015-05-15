#!/bin/bash -xe

##################################################################################
function usage(){
  echo "usage: $(basename $0) /path/to/jenkins_home /path/to/destination"
}
##################################################################################

readonly JENKINS_HOME=$1
readonly DEST_DIR=$2
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

if [ $# -ne 2 ] ; then
  usage >&2
  exit 1
fi

rm -rf "$DEST_DIR"/*
mkdir -p "$DEST_DIR/"{plugins,jobs,users}

cp "$JENKINS_HOME/"*.xml "$DEST_DIR"
cp "$JENKINS_HOME/plugins/"*.[hj]pi "$DEST_DIR/plugins"
hpi_pinned_count=$(find $JENKINS_HOME/plugins/ -name *.hpi.pinned | wc -l)
jpi_pinned_count=$(find $JENKINS_HOME/plugins/ -name *.jpi.pinned | wc -l)
if [ $hpi_pinned_count -ne 0 -o $jpi_pinned_count -ne 0 ]; then
  cp "$JENKINS_HOME/plugins/"*.[hj]pi.pinned "$DEST_DIR/plugins"
fi
cp -R "$JENKINS_HOME/users/"* "$DEST_DIR/users"

cd "$JENKINS_HOME/jobs/"
ls -1 | while read job_name
do
  mkdir -p "$DEST_DIR/jobs/$job_name/"
  find "$JENKINS_HOME/jobs/$job_name/" -maxdepth 1 -name "*.xml" | xargs -I {} cp {} "$DEST_DIR/jobs/$job_name/"
done

exit 0

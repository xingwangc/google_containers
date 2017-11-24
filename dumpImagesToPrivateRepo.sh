#! /usr/local/bin/bash

set -e

declare -a IMAGES=(
	"elasticsearch:v2.4.1"
	"fluentd-elasticsearch:1.20"
	"kibana:v4.6.1"
	"heapster_influxdb:v0.7"
	"heapster_grafana:v3.1.1"
	"heapster:v1.2.0"
	"addon-resizer:1.6"
	"kubedns-amd64:1.8"
	"kube-dnsmasq-amd64:1.4"
	"exechealthz-amd64:1.2"
	"kubernetes-dashboard-amd64:v1.4.2"
	"node-problem-detector:v0.1"
)

function Usage() {
	echo ""
	echo "dumpImagesToPrivateRepo.sh will pull images from the remote docker repository,"
	echo "and then retag them, then push the retaged images to you private repository."
	echo "So before execute this script, you should make sure you have the permission for"
	echo "these 2 repos!"
	echo "	dumpImagesToPrivateRepo.sh remoteRepo privateRepo"
	echo "		remoteRepo: the remote repository from which to pull images"
	echo "		privateRepo: the private repository to which the images will be pushed"

}


function main() {
	[[ $# == 2 ]] || (Usage; return 1)

	remote_repo=$1
	private_repo=$2

	for image in ${IMAGES[@]}; do
		docker pull ${remote_repo}/${image}
		docker tag ${remote_repo}/${image} ${private_repo}/${image}
		docker push ${private_repo}/${image}
	done
}

main $*

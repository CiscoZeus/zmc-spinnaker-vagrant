# zmc-spinnaker-vagrant

## Prerequisites
* Host System : Ubuntu 16.04
* sudo apt-get install vagrant // TODO: add prereq for vagrant


```
vagrant up
vagrant ssh 
bash /vagrant/setup.sh
```

## If you want to try docker 
```
docker run --name halyard -d -v ~/.hal:/root/.hal \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_REGION=us-west-2 \
    -e AWS_BUCKET=zeus-multicloud-spinnaker \
    -e TERM=xterm \
    -e AWS_ACCOUNT=$AWS_ACCOUNT \
    -e AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID \
    -e AWS_ROLE=$AWS_ROLE \
    -p 9000:9000 \
    gcr.io/spinnaker-marketplace/halyard:stable
```

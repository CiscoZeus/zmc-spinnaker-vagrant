# zmc-spinnaker-vagrant

## Prerequisites
* Host System : Ubuntu 16.04
* sudo apt-get install vagrant // TODO: add prereq for vagrant; 1.9.3

## Setup
Set these in your local environment in your ~/.bashrc, ~/.profile, or /etc/environment (in Ubuntu 16 I used /etc/environment)

* AWS_ACCESS_KEY_ID
* AWS_REGION
* AWS_BUCKET
* AWS_ACCOUNT
* AWS_ACCOUNT_ID
* AWS_ROLE
* AWS_SECRET_ACCESS_KEY

Make sure you're not a sudo user:

```
vagrant up
vagrant ssh 
bash /vagrant/setup.sh
```

## If you want to try docker 
```
sudo docker pull gcr.io/spinnaker-marketplace/halyard:stable
mkdir -p ~/.hal
sudo docker run --name halyard --rm \
# if in vagrant cd /vagrant
    -v /$PWD:/tools/ \
    -v ~/.hal:/root/.hal \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_REGION=us-west-2 \
    -e AWS_BUCKET=zeus-multicloud-spinnaker \
    -e TERM=xterm \
    -e AWS_ACCOUNT=$AWS_ACCOUNT \
    -e AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID \
    -e AWS_ROLE=$AWS_ROLE \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -p 9000:9000 \
    gcr.io/spinnaker-marketplace/halyard:stable
sudo docker exec --user nobody -it halyard bash
sudo docker exec -it halyard bash
```

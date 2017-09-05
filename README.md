# zmc-spinnaker-vagrant

## Prerequisites
* Host System : Ubuntu 16.04
* virtualbox (for vagrant)
* sudo apt-get install vagrant // TODO: add prereq for vagrant; 1.9.3

## Setup
Set these in your local environment in your ~/.bashrc, ~/.profile, or /etc/environment (in Ubuntu 16 I used /etc/environment)

* AWS_ACCESS_KEY_ID
* AWS_REGION=us-west-2
* AWS_BUCKET=zeus-multicloud-spinnaker
* AWS_ACCOUNT
* AWS_ACCOUNT_ID
* AWS_ROLE=role/spinnakerManaged
* AWS_SECRET_ACCESS_KEY

Make sure you're not a sudo user:

resources: https://stackoverflow.com/questions/44541839/port-forwarding-on-spinnaker
```
vagrant up
vagrant ssh 
# to see the commands run include -x
bash -x /vagrant/setup.sh
curl localhost:9000
# below will forward and then go to machine with browser; leave it rnning in a separate shell
ssh -A -L 9000:localhost:9000 -L 8084:localhost:8084 -L 8087:localhost:8087 user@ip-of-machine-with-browser-access
ssh -L 9000:localhost:9000 -L 8084:localhost:8084 -L 8087:localhost:8087 vagrant@<vagrant ip address> 

```

In your machine with browser access:
localhost:9000
If you want to use another ip address; add -g to ssh and change localhost to the ip you want to use

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

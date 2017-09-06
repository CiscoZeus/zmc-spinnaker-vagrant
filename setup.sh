sudo mkdir ~/.aws
sudo cp /vagrant/credentials ~/.aws/credentials
sudo chmod +x /InstallHalyard.sh

sudo sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/hosts


echo "Y" | sudo bash /InstallHalyard.sh --user $USER && \
sleep 30 && \
hal config version edit --version "1.1.2" && \

echo "$AWS_SECRET_ACCESS_KEY" | hal config storage s3 edit --access-key-id $AWS_ACCESS_KEY_ID --secret-access-key --region $AWS_REGION --bucket $AWS_BUCKET

hal config storage edit --type s3

echo "$AWS_SECRET_ACCESS_KEY" | hal config provider aws edit --access-key-id $AWS_ACCESS_KEY_ID --secret-access-key

hal config provider aws account add $AWS_ACCOUNT --account-id $AWS_ACCOUNT_ID --assume-role $AWS_ROLE

hal config provider aws enable


hal config deploy edit --type localdebian

#sudo "host: 0.0.0.0" | tee \
#    ~/.hal/default/service-settings/gate.yml \
#    ~/.hal/default/service-settings/deck.yml

#hal config security ui edit \
#    --override-base-url http://192.168.33.10:9000

#hal config security api edit \
#    --override-base-url http://192.168.33.10:8084

sudo hal deploy apply
sudo hal deploy connect

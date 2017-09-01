sudo chmod +x /InstallHalyard.sh
sudo bash /InstallHalyard.sh
hal config version edit --version "1.1.2"

hal config storage s3 edit --access-key-id $AWS_ACCESS_KEY_ID --secret-access-key --region $AWS_REGION --bucket $AWS_BUCKET

hal config storage edit --type s3

hal config provider aws edit --access-key-id $AWS_ACCESS_KEY_ID --secret-access-key

hal config provider aws account add $AWS_ACCOUNT --account-id $AWS_ACCOUNT_ID --assume-role $AWS_ROLE

hal config provider aws enable


hal config deploy edit --type localdebian

sudo hal deploy apply
sudo hal deploy connect

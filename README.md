Sample Package Drop Repository that can be used for cloning while creating new repositories

Docker Image needs to be uploaded to the repository registry
Custom SSH Key Pair to be added as a environment variable in BASE64 Encoded format
New Environments to be defined on GITLAB.COM. These environment names should match the names defined in .gitlab-ci.yml and also deploy_target.yml
Host IPs to be updated in deploy_target.yml
SSH Public Key to be added on the target deployment hosts under ~/.ssh/authorized_keys

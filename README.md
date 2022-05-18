# Stand up the infrastructure

## 1. Create a bucket

Run the following command and change the parameter "bucket-name" for the name of the bucket you want to create:

    aws s3api create-bucket --bucket bucket-name
 
## 2. Create a public key and store it on AWS 

Run the following command on linux or WSL 2 and change "my-key" name for the specific key pair you want to create:

    ssh-keygen -t rsa -b 2048 -f ~/.ssh/my-key

This command imports the provided public key to a single region: **

    aws ec2 import-key-pair --key-name "my-key" --public-key-material fileb://~/.ssh/my-key.pub --region region-name

## 3. Terraform init

Run the following command in the project directory and change the parameters values:

    terraform init -backend-config="bucket=my_bucket_name" -backend-config="key=environment_name/filename"

## 4. Terraform plan

After run the previous command, run the following command and change the parameters values:

    terraform plan -var="environment=environment_name" -var="public_key=public_key_name"

## 5. Terraform apply 

Finally run the command below and change the parameters values:

    terraform apply -var="environment=environment_name" -var="public_key=public_key_name" auto--approve

## 6. Terraform destroy

The following command will destroy the resources:

    terraform destroy -var="environment=environment_name" -var="public_key=public_key_name" auto--approve

## 7.Emptying the bucket

The following rm command removes objects that have the key name prefix doc, for example, doc/doc1 and doc/doc2:

    aws s3 rm s3://bucket-name/doc --recursive

Use the following command to remove all objects without specifying a prefix:

    aws s3 rm s3://bucket-name --recursive

## 8. Deleting the bucket

Run the following command and change the parameter "bucket_name" for the name of the bucket you want to delete:

    aws s3api delete-bucket --bucket bucket-name

## 9. Deleting the key pairs

Run the following command and change the parameter values:**

    aws ec2 delete-key-pair --key-name "my-key" --region region-name

** If you need to store/delete the key pair in more than one region, change the "region-name" and run the previous command as needed. In this case we will need to execute the command on the regions "us-east-1" and "us-west-2".

## Documentation

- [Terraform Input Variables](https://www.terraform.io/language/values/variables#input-variable-documentation)
- [Terraform Backend Configuration](https://www.terraform.io/language/settings/backends/configuration)
- [Creating AWS Bucket Resource](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html)
- [Emptying AWS Bucket Resource](https://docs.aws.amazon.com/AmazonS3/latest/userguide/empty-bucket.html)
- [Deleting AWS Bucket Resource](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html)
- [Import key pairs on AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/ec2/import-key-pair.html)
- [Import key pairs on AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html)
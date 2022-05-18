# Content

## 1. Create a bucket

Run the following command and change the parameter "bucket-name" for the name of the bucket you want to create:

    aws s3api create-bucket --bucket bucket-name

## 2. Terraform init

Run the following command in the project directory and change the parameters values:

    terraform init -backend-config="bucket=my_bucket_name" -backend-config="key=environment_name/filename"

## 3. Terraform plan

After run the previous command, run the following command and change the parameters values:

    terraform plan -var="environment=environment_name" -var="public_key=public_key_name"

## 4. Terraform apply 

Finally run the command below and change the parameters values:

    terraform apply -var="environment=environment_name" -var="public_key=public_key_name" auto--approve

## 5. Terraform destroy

The following command will destroy the resources:

    terraform destroy -var="environment=environment_name" -var="public_key=public_key_name" auto--approve

## 6.Emptying the bucket

The following rm command removes objects that have the key name prefix doc, for example, doc/doc1 and doc/doc2:

    aws s3 rm s3://bucket-name/doc --recursive

Use the following command to remove all objects without specifying a prefix:

    aws s3 rm s3://bucket-name --recursive

## 7. Deleting the bucket

Run the following command and change the parameter "bucket_name" for the name of the bucket you want to delete:

    aws s3api delete-bucket --bucket bucket-name

## 8. Documentation

- [Terraform Input Variables](https://www.terraform.io/language/values/variables#input-variable-documentation)
- [Terraform Backend Configuration](https://www.terraform.io/language/settings/backends/configuration)
- [Creating AWS Bucket Resource](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html)
- [Emptying AWS Bucket Resource](https://docs.aws.amazon.com/AmazonS3/latest/userguide/empty-bucket.html)
- [Deleting AWS Bucket Resource](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html)

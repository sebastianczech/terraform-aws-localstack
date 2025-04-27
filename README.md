# Terraform modules for provisioning resource in AWS LocalStack

## Usage

Install CLI tools:

```bash
brew install localstack/tap/localstack-cli
pip install awscli-local
```

Setup environment:

```bash
export LOCALSTACK_AUTH_TOKEN=<your_auth_token>

export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"
```

Start environment:

```bash
localstack start
```

Set auth token:

```bash
localstack auth set-token <your_auth_token>
```

Show configuration:

```bash
localstack config show
```

Stop environment:

```bash
localstack stop
```

Clean environment:

```bash
docker image prune --all --force
docker system prune --all --force
```

## AWS commands

### General

```bash
aws s3 mb s3://my-first-bucket --endpoint-url=http://localhost:4566

awslocal s3 mb s3://my-second-bucket

awslocal s3 ls
```

### DynamoDB

```bash
aws --endpoint-url=http://localhost:4566 dynamodb list-tables

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name demo-dynamodb-cli \
    --attribute-definitions AttributeName=FirstName,AttributeType=S AttributeName=LastName,AttributeType=S \
    --key-schema AttributeName=FirstName,KeyType=HASH AttributeName=LastName,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --tags Key=Owner,Value=Sebastian

aws --endpoint-url http://localhost:4566 dynamodb describe-table --table-name demo-dynamodb-cli

cat > infra/terraform/demo-dynamodb-cli-item.json << EOF
{
    "FirstName": {"S": "Jan"},
    "LastName": {"S": "Kowalski"}
}
EOF

aws --endpoint-url http://localhost:4566 dynamodb put-item \
    --table-name demo-dynamodb-cli \
    --item file://infra/terraform/demo-dynamodb-cli-item.json \
    --return-consumed-capacity TOTAL \
    --return-item-collection-metrics SIZE

aws --endpoint-url http://localhost:4566 dynamodb scan --table-name demo-dynamodb-cli
```

### S3 bucket

```bash
aws --endpoint-url=http://localhost:4566 s3 mb s3://demo-bucket-cli
aws --endpoint-url=http://localhost:4566 s3api put-bucket-acl --bucket demo-bucket-cli --acl public-read

aws --endpoint-url=http://localhost:4566 s3 ls
aws --endpoint-url=http://localhost:4566 s3 ls s3://demo-bucket-cli

aws --endpoint-url=http://localhost:4566 s3 ls s3://demo-bucket-py
aws --endpoint-url=http://localhost:4566 s3 cp s3://demo-bucket-py/simple_file_with_binary_data.txt .
aws --endpoint-url=http://localhost:4566 s3 cp simple_file_with_binary_data.txt s3://demo-buck
```

### SNS

```bash
aws --endpoint-url=http://localhost:4566 sns list-topics
aws --endpoint-url=http://localhost:4566 sns create-topic --name demo-sns-cli
aws --endpoint-url=http://localhost:4566 sns publish --topic-arn arn:aws:sns:us-east-1:000000000000:demo-sns-cli --message "Test message sent to SNS on Localstack"

aws --endpoint-url=http://localhost:4566 sns subscribe \
              --topic-arn arn:aws:sns:us-east-1:000000000000:demo-sns-cli \
              --protocol sqs \
              --notification-endpoint http://localhost:4566/000000000000/demo-sqs-cli

aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url http://localhost:4566/000000000000/demo-sqs-cli
```

### SQS

```bash
aws --endpoint-url=http://localhost:4566 sqs list-queues
aws --endpoint-url=http://localhost:4566 sqs create-queue --queue-name demo-sqs-cli 
```

### Lambda

```bash
aws --endpoint-url http://localhost:4566 lambda list-functions

cd app/src
zip lambda_hello_world.zip lambda_hello_world.py

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name lambda_hello_world_cli \
    --zip-file fileb://lambda_hello_world.zip \
    --role arn:aws:iam::123456789012:role/service-role/MyTestFunction-role-tges6bf

aws --endpoint-url=http://localhost:4566 lambda list-functions

aws --endpoint-url=http://localhost:4566 lambda get-function --function-name lambda_hello_world_cli

curl http://localhost:4566/2015-03-31/functions/lambda_hello_world_cli/code --output lambda_hello_world.zip
unzip lambda_hello_world.zip
cat lambda_hello_world.py

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name lambda_hello_world_cli \
    --cli-binary-format raw-in-base64-out \
    --payload file://lambda_hello_world_input.json \
    lambda_hello_world_output.json
```

## Links

* [LocalStack Cloud](https://app.localstack.cloud/)
* [Docker Desktop](https://docs.docker.com/desktop/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Cloud-Native-CI-CD](https://github.com/sebastianczech/Cloud-Native-CI-CD)

## Problems

### Failed to connect to /var/run/com.docker.vmnetd.sock

Error:

```
Error while starting LocalStack container: Docker process returned with errorcode 1
Error response from daemon: Ports are not available: exposing port TCP 127.0.0.1:443 -> 127.0.0.1:0: failed to connect to /var/run/com.docker.vmnetd.sock: is vmnetd running?: dial unix /var/run/com.docker.vmnetd.sock: connect: no such file or directory
```

Issue: https://github.com/localstack/localstack/issues/10576

Solution:

```
sudo /Applications/Docker.app/Contents/MacOS/install vmnetd
```

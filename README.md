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

aws --endpoint-url=http://localhost:4566 s3 cp .gitignore s3://demo-bucket-cli
aws --endpoint-url=http://localhost:4566 s3 ls s3://demo-bucket-cli
```

### SNS

```bash
aws --endpoint-url=http://localhost:4566 sns list-topics
aws --endpoint-url=http://localhost:4566 sns create-topic --name demo-sns-cli
```

### SQS

```bash
aws --endpoint-url=http://localhost:4566 sqs list-queues
aws --endpoint-url=http://localhost:4566 sqs create-queue --queue-name demo-sqs-cli
```

### SNS & SQS

```bash
aws --endpoint-url=http://localhost:4566 sqs get-queue-attributes \
    --queue-url http://localhost:4566/000000000000/demo-sqs-cli \
    --attribute-names QueueArn

aws --endpoint-url=http://localhost:4566 sns subscribe \
              --topic-arn arn:aws:sns:us-east-1:000000000000:demo-sns-cli \
              --protocol sqs \
              --notification-endpoint arn:aws:sqs:us-east-1:000000000000:demo-sqs-cli

aws --endpoint-url=http://localhost:4566 sns publish --topic-arn arn:aws:sns:us-east-1:000000000000:demo-sns-cli --message "Test message sent to SNS on Localstack"

aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url http://localhost:4566/000000000000/demo-sqs-cli
```

### Lambda

```bash
cd lambda/hello-world
zip lambda-hello-world.zip app.py

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name lambda_hello_world_cli \
    --zip-file fileb://lambda-hello-world.zip \
    --handler app.lambda_handler \
    --runtime python3.9 \
    --role arn:aws:iam::123456789012:role/service-role/MyTestFunction-role-tges6bf

aws --endpoint-url=http://localhost:4566 lambda list-functions

aws --endpoint-url=http://localhost:4566 lambda get-function --function-name lambda_hello_world_cli

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name lambda_hello_world_cli \
    --cli-binary-format raw-in-base64-out \
    output.json
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

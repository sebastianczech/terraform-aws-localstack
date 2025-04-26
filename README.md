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

```bash
aws s3 mb s3://my-first-bucket --endpoint-url=http://localhost:4566

awslocal s3 mb s3://my-second-bucket

awslocal s3 ls
```

## Links

* [LocalStack Cloud](https://app.localstack.cloud/)
* [Docker Desktop](https://docs.docker.com/desktop/)
* [Docker Compose](https://docs.docker.com/compose/)

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

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

## Links

* [LocalStack Cloud](https://app.localstack.cloud/)
* [Docker Desktop](https://docs.docker.com/desktop/)
* [Docker Compose](https://docs.docker.com/compose/)

# AWS CLI in Docker

Containerized AWS CLI on alpine to avoid requiring the `aws cli` to be installed on machines.

Inspired by [mesosphere/aws-cli](https://github.com/mesosphere/aws-cli).

## Build

```
docker build -t aws-cli .
```

## Usage

```
docker run --rm -v $HOME/.aws:/root/.aws:ro aws-cli [aws-cli command and options] 
```
Where:
- `--rm` remove container after command execution has finished
- `-v $HOME/.aws:/root/.aws:ro` mounts `.aws` config/credentials from the local files system into the docker image using `:ro` Read Only mode.
- `aws-cli` image name
- `aws-cli command and options`: see examples

### Examples

Describe VPCS in currently configured `default` region
```
docker run --rm -v $HOME/.aws:/root/.aws:ro aws-cli ec2 describe-vpcs
```

Describe VPCS in specific AWS region
```
docker run --rm -v $HOME/.aws:/root/.aws:ro aws-cli ec2 describe-vpcs --region=us-east-1
```

Docker login into ECR
```
eval $(docker run --rm -v $HOME/.aws:/root/.aws:ro illya/aws-cli ecr get-login --region us-west-2)
```


## Configure AWS CLI Credentials

In order to use `aws-cli` you must provide `aws` configurations and credentials, which are typically stored in `$HOME/.aws`.

[Configuring the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) provides `Quick Configuration` instructions.
However, those instructions imply that you have `aws` cli already installed.

You can generate `.aws/config` and `.aws/credentials` files manually

#### Sample .aws/config
```
[default]
output = json
region = us-west-2
```

#### Sample .aws/credentials
```
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

For more details on AWS CLI configuration see [Configuring the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

### Generate Configuration

You can generate configuration using `aws-cli` image by running:
```
# create directory and files to have current user ownership
# w/out this step `docker run` will create said directory and files w/ `root` ownerhips
mkdir .aws && touch .aws/config && touch .aws/credentials

# generate configuration and credentials
docker run --rm -v $PWD/.aws:/root/.aws -ti aws-cli configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```
Where:
- `-v $PWD/.aws` mount local file system `.aws` directory (typically `$HOME/.aws`) in Read Write mode (implicit)
- `-ti` terminal and interactive mode
- `configure` aws cli configure command [Configuring the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)


# AWS CLI Lambda

This is a full working example of executing the AWS CLI script in a Lambda.

> Yup, there's boto and a AWS SDK in most languages, but I needed the AWS CLI specifically.

## Build/Deploy

The build and deploy steps are done in Docker so files are compiled with an environment like where
it will be deployed to. Assuming you've configured your `local.env`, just use `docker-compose` to
kick off a build _and_ a deploy to AWS (SAM app).

### Configure `docker/build/local.env`

Edit `docker/build/local.env` to taste using
[docker/build/local.dist.env](docker/build/local.dist.env) as a template.

```
AWS_ACCESS_KEY_ID=ABC123
AWS_DEFAULT_REGION=us-east-1
AWS_SECRET_ACCESS_KEY=000111222333444555666778899aaabbcccddee

ENV_NAME=dev
APP_NAME=awscli

# Create with `aws s3 mb <bucketname>` if you don't have a S3 bucket handy.
# This is used to push the zip'ed Lambda code to S3 so a Lambda can be deployed.
S3_BUCKET=my-scratch-foo
```

### Kick of Build/Deploy

```shell
cd docker/build
docker-compose up --build
```

## Invoke Lambda

To test, invoke the Lambda and check Cloud Watch logs if you did not receive output resembling
the expected output for `s3 ls` output.

```shell
aws lambda invoke \
    --function-name dev-aws-cli \
    --payload '{"cmd": "s3 ls"}' \
    /dev/stdout
```
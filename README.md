# AWS CLI Lambda

This is a full working example of executing the AWS CLI script in a Lambda.

> Yup, there's boto and a AWS SDK in most languages, but I needed the AWS CLI specifically.

## Build/Deploy

The build and deploy steps are done in Docker so files are compiled with an environment like where
it will be deployed to.

> Edit `docker/build/local.env` to taste using
  [docker/build/local.dist.env](docker/build/local.dist.env) as a template.

```shell
cd docker/build

# 

docker-compose up --build
```

## Invoke Lambda

To test, invoke the Lambda and check Cloud Watch logs.

```shell
aws lambda invoke \
    --function-name dev-aws-cli \
    --payload '{"cmd": "s3 ls"}' \
    /dev/stdout
```
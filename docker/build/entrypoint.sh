#!/usr/bin/env bash

set -ex

# Make sure required variables are set.
[[ -z "${ENV_NAME}" ]] && echo "Set ENV_NAME" && exit 1
[[ -z "${S3_BUCKET}" ]] && echo "Set S3_BUCKET" && exit 2
[[ -z "${APP_NAME}" ]] && echo "Set APP_NAME" && exit 3
[[ -z "${AWS_ACCESS_KEY_ID}" ]] && echo "Set AWS_ACCESS_KEY_ID" && exit 4
[[ -z "${AWS_DEFAULT_REGION}" ]] && echo "Set AWS_DEFAULT_REGION" && exit 5
[[ -z "${AWS_SECRET_ACCESS_KEY}" ]] && echo "Set AWS_SECRET_ACCESS_KEY" && exit 6

# Package up the Lambda artifacts in a .zip and ship to S3.
aws cloudformation package \
    --template-file infra/formation.yml \
    --s3-bucket ${S3_BUCKET} \
    --s3-prefix ${ENV_NAME}-${APP_NAME} \
    --output-template-file infra/formation.compiled.yml

# Deploy the SAM app based on the S3 .zip archive.
aws cloudformation deploy \
    --template-file infra/formation.compiled.yml \
    --s3-bucket ${S3_BUCKET} \
    --s3-prefix ${ENV_NAME}-${APP_NAME} \
    --capabilities CAPABILITY_NAMED_IAM \
    --stack-name ${ENV_NAME}-${APP_NAME} \
    --parameter-overrides \
        "EnvName=${ENV_NAME}" \
        "AwsAccessKey=${AWS_ACCESS_KEY_ID}" \
        "AwsDefaultRegion=${AWS_DEFAULT_REGION}" \
        "AwsSecretAccessKey=${AWS_SECRET_ACCESS_KEY}"

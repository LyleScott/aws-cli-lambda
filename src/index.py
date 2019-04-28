import os
from subprocess import Popen, PIPE

import aws_lambda_logging


# The ENV vars that will be set when the `aws` command is executed.
AWS_CLI_ENV = {
    'AWS_ACCESS_KEY_ID': os.getenv('ACCESS_KEY_ID'),
    'AWS_SECRET_ACCESS_KEY': os.getenv('SECRET_ACCESS_KEY'),
    'AWS_DEFAULT_REGION': os.getenv('DEFAULT_REGION'),
    'PYTHONPATH': '/var/task:/var/lang/lib/' + os.getenv('AWS_EXECUTION_ENV').rsplit('_', 1)[1],
}


def aws_cli_command(cmd):
    """Run an AWS CLI command."""
    cmd = ['./bin/aws'] + cmd.split(' ')
    process = Popen(cmd, stdout=PIPE, stderr=PIPE, env=AWS_CLI_ENV)
    stdout, stderr = process.communicate()

    return stdout, stderr


def lambda_handler(event, context):
    """Entrypoint when the Lambda runs."""
    aws_lambda_logging.setup(level='DEBUG', boto_level='CRITICAL')
    stdout, stderr = aws_cli_command(event['cmd'])

    return {'stdout': stdout.decode('utf8'), 'stderr': stderr.decode('utf8')}

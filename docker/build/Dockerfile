FROM lambci/lambda:build-python3.7

ENV PYTHONUNBUFFERED 0

COPY . /code
WORKDIR /code
RUN pip3.7 install --quiet --target src/ -r requirements.txt &&\
    cd src/ &&\
    python -m compileall -q /code &&\
    zip -q -r lambda_handler.zip *

ENTRYPOINT /code/docker/build/entrypoint.sh
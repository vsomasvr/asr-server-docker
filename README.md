# asr-server-docker

Dockerfile to build asr-server (https://github.com/dialogflow/asr-server.)
Use the following commands to build and run the container

1) docker build -t asr-svr .
2) docker run -it -d -p 8080:80 asr-svr
you will find the asr-server running @ port 8080

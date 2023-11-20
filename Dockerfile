FROM nginx:latest

WORKDIR /app

# RUN apt-get update && apt-get install -y
# RUN apt-get install vim -y
RUN apt-get update && \
    apt-get install vim -y

COPY html/ /usr/share/nginx/html

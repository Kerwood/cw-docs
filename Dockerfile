FROM node:10-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY . /usr/src/app/

RUN npm -g install pm2 && npm install

CMD ["pm2-docker", "server.js"]

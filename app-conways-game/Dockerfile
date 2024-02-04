# syntax = docker/dockerfile:1

FROM node:latest

LABEL author="Brena Monteiro"
LABEL email="monteirobrena@gmail.com"

RUN mkdir -p /opt/app

# App lives here
WORKDIR /

# Copy package.json to install dependencies
COPY package.json .

# Install packages
RUN npm install

# Copy built artifacts
COPY . ./

# Start the server by default, this can be overwritten at runtime
EXPOSE 3001
CMD [ "npm", "start"]
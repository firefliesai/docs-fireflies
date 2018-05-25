FROM node:latest

RUN mkdir app
ADD . /app
WORKDIR /app
RUN npm install

EXPOSE 4000

CMD ["npm", "start" ]

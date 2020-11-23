FROM node:14

COPY package.json .
RUN npm install --only=prod
COPY app.js .
COPY ./public ./public
COPY ./views ./views
CMD ["node", "./app.js"]
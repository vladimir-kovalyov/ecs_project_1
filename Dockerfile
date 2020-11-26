FROM node:14

COPY package.json .
RUN npm install --only=prod
COPY app.js .
COPY ./public ./public
COPY ./views ./views
EXPOSE 80
CMD ["node", "./app.js"]
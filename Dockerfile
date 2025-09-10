FROM node:20-alpine
WORKDIR /myapp
COPY package*.json ./
COPY . .
RUN  npm install 
CMD ["npm", "start"]

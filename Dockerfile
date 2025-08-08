# build environment  
FROM node:20-alpine as build  

ENV PATH node_modules/.bin:$PATH  
COPY package.json ./
COPY package-lock.json ./

RUN npm ci 
RUN npm install react-scripts@3.4.1 -g --silent  
COPY . ./
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build  

FROM nginx:stable-alpine  
COPY --from=build /build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
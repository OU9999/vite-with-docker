FROM --platform=linux/amd64 node:18.12.0-alpine as build

WORKDIR /app

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm ci

COPY . .

RUN npm run build

FROM --platform=linux/amd64 nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY /server/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

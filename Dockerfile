FROM node:iron-alpine AS build

WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .

RUN npm ci

COPY . .

ARG VITE_API_URL=https://api.quizforge.ilyabikmeev.ru
ENV VITE_API_URL=${VITE_API_URL}

ENV NODE_ENV=production
RUN npm run build
RUN npm run build


FROM nginx:alpine AS app

WORKDIR /www

RUN rm /etc/nginx/conf.d/*

COPY ./nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /www
RUN chown -R nginx:nginx /www

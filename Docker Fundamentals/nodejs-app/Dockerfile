FROM node:20-alpine

WORKDIR /usr/src/app

# No third-party packages are needed; the built-in http module is enough.
COPY package.json app.js ./

ENV PORT=3000
EXPOSE 3000

CMD ["node", "app.js"]

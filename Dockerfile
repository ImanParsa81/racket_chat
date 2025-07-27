FROM node:12

ENV RC_VERSION=3.18.1

RUN apt-get update && \
    apt-get install -y python g++ make curl && \
    curl -L https://releases.rocket.chat/${RC_VERSION}/download -o rocket.chat.tgz && \
    tar -xzf rocket.chat.tgz && \
    mv bundle /app && \
    cd /app/programs/server && \
    npm install

WORKDIR /app

EXPOSE 3000

CMD ["node", "main.js"]

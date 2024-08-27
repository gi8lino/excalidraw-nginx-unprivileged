FROM node:18 AS builder

# Install git to clone the repository
RUN apt-get update && apt-get install -y git

# Clone the Excalidraw repository
RUN git clone https://github.com/excalidraw/excalidraw.git /opt/node_app

WORKDIR /opt/node_app

# do not ignore optional dependencies:
# Error: Cannot find module @rollup/rollup-linux-x64-gnu
RUN yarn --network-timeout 600000

ARG NODE_ENV=production

RUN yarn build:app:docker

FROM ghcr.io/nginxinc/nginx-unprivileged:1.27.1

COPY --from=builder /opt/node_app/excalidraw-app/build /usr/share/nginx/html

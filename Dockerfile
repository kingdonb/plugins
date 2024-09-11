FROM docker.io/library/node:18@sha256:d0bbfdbad0bff8253e6159dcbee42141db4fc309365d5b8bcfce46ed71569078 as builder

WORKDIR /headlamp-plugins

COPY ./flux-plugin /headlamp-plugins/flux-plugin

RUN mkdir -p /headlamp-plugins/build

RUN cd /headlamp-plugins/flux-plugin && npm install

# Build the plugin
RUN npx @kinvolk/headlamp-plugin build /headlamp-plugins

# Extract the built plugin files to the build directory
RUN npx @kinvolk/headlamp-plugin extract /headlamp-plugins/ /headlamp-plugins/build


FROM alpine:latest

# Copy the built plugin files from the base image to /plugins directory
COPY --from=builder /headlamp-plugins/build/ /plugins/

CMD ["/bin/sh -c 'mkdir -p /build/plugins && cp -r /plugins/* /build/plugins/'"]

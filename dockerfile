FROM nginx:alpine as build
# Update the package repository
# Install necessary packages
RUN apk add --update \
    wget

ARG HUGO_VERSION=0.122.0

# Downloadd and install Hugo
RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/bin && \
    chmod 755 /usr/bin/hugo

## Hugo source code
# Set the working directory to '/src'
WORKDIR /src
# Copy the current directory contents into the container at '/src'
COPY ./ /src
# Build the hugo site
RUN hugo --environment production

# create a new stage with the nginx Alpine image

FROM nginx:alpine

# Copy the public directory from the previous stage to the new stage
COPY --from=build /src/public /usr/share/nginx/html
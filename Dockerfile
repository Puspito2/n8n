# Use official lightweight node base image with Alpine for minimal size
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /usr/src/app

# Install necessary build tools for native dependencies
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++ \
    libc6-compat

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install production dependencies only for smaller image size
RUN npm ci --only=production

# Copy the rest of your source code
COPY . .

# Expose the default n8n port
EXPOSE 5678

# Use environment variables for configuration - can be overridden in Render dashboard
ENV N8N_PORT=5678
ENV N8N_HOST=0.0.0.0
ENV NODE_ENV=production

# Run n8n with limited privileges (best practice)
USER node

# Start n8n process
CMD ["npx", "n8n", "start", "--tunnel"]

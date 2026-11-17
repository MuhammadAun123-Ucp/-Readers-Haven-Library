# Stage 1: Build the website using Node.js and Parcel
# Use a specific Node.js version for consistent builds
FROM node:22-alpine AS builder

# Set the working directory inside the builder container
WORKDIR /app

# Copy package files first to optimize dependency installation
COPY package*.json ./

# Install exact dependencies from package-lock.json
RUN npm ci

# Copy website source files and shared stylesheet
COPY src/ ./src/
COPY styles/ ./styles/

# Build all HTML pages into the dist directory
RUN npm run build


# Stage 2: Serve the website using Nginx
# Use a specific lightweight Nginx version
FROM nginx:1.27-alpine

# Copy the built website from the builder stage to Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Keep Nginx running in the foreground
CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Building the code
FROM node:16-alpine as builder

WORKDIR /app

# Copy the package.json and package-lock.json (or yarn.lock) files first
# This layer is rebuilt only if these files change
COPY package*.json yarn.lock* ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the rest of your app's source code
COPY . .

# Build your Next.js app
RUN npm run build

# Stage 2: Running the app
FROM node:16-alpine

WORKDIR /app

# Copy the build artifacts from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Expose the port your app runs on
EXPOSE 3000

# Command to run your app
CMD ["npm", "run", "dev"]

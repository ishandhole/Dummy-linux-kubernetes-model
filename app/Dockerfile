# ── Stage 1: Use official lightweight Node.js on Linux Alpine ──────────────
FROM node:20-alpine

# Set working directory inside the container
WORKDIR /app

# Copy application file
COPY server.js .

# Expose port 3000
EXPOSE 3000

# Command to run when container starts
CMD ["node", "server.js"]

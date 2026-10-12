# Default CMD runs the HTTP checker service on port 4000.
# For one-off CLI checks, override the command, e.g.:
#   docker run --rm -v "$PWD/proofs:/proofs" geo-checker-ts npm run --silent checkProof -- /proofs/foo.txt
FROM node:23-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ENV PORT=4000
EXPOSE 4000
CMD ["npm", "run", "checker-server"]

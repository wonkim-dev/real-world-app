# Dependency
FROM node:19-alpine AS dependency
WORKDIR /app
RUN chown -R node:node /app
USER node
COPY --chown=node:node . .
RUN npm ci && npm audit --audit-level=high --omit=dev && npm run lint && npm run test

# Build
FROM node:19-alpine AS build
WORKDIR /app
RUN chown -R node:node /app
USER node
COPY --chown=node:node package*.json ./
COPY --chown=node:node tsconfig.json ./
COPY --chown=node:node --from=dependency /app/node_modules ./node_modules
COPY --chown=node:node --from=dependency /app/src ./src
RUN npm run build && npm ci --omit=dev

# Production
FROM node:19-alpine
WORKDIR /app
RUN chown -R node:node /app
USER node
COPY --chown=node:node --from=build /app/dist ./dist
COPY --chown=node:node --from=build /app/node_modules ./node_modules
EXPOSE 3000
CMD [ "node", "dist/main.js" ]

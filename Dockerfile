FROM node:14-alpine AS BUILD_DEPS_IMAGE

# Install dependencies (prod only)
COPY package*.json ./
RUN npm ci --only=production

# Pruning dependencies
# https://github.com/yarnpkg/yarn/issues/6373#issuecomment-487149026
RUN npm prune --production
RUN apk add curl && \
    curl -sf https://gobinaries.com/tj/node-prune | sh
RUN /usr/local/bin/node-prune

FROM node:14-alpine AS BUILD_APP_IMAGE

# Install dependencies (including dev ones)
COPY package*.json ./
COPY tsconfig.json ./
RUN npm ci

# Build application code
COPY ./src ./src
RUN npm run build

FROM amazon/aws-lambda-nodejs:14

# Copy pre-built dependencies
COPY --from=BUILD_DEPS_IMAGE ./node_modules ${LAMBDA_TASK_ROOT}/node_modules
COPY --from=BUILD_DEPS_IMAGE ./package.json ${LAMBDA_TASK_ROOT}/package.json

# Copy pre-built application code
COPY --from=BUILD_APP_IMAGE ./dist ${LAMBDA_TASK_ROOT}

CMD [ "index.handler" ]

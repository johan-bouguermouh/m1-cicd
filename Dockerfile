# Mono-container: one Express process serves both the API and the built
# React frontend (backend/app.ts already has an express.static line for
# this — see the SPA-fallback addition alongside this Dockerfile). This is
# the simplest thing to teach and deploy first; a split frontend/backend
# image is a legitimate later evolution, not needed for this demonstration.

# --- Build stage: only used to produce the frontend's static bundle ---
FROM node:22-alpine AS builder
WORKDIR /app

COPY package.json yarn.lock ./
# --ignore-scripts: skips the "husky install" postinstall hook, which
# fails outside a git repository (no .git dir in a build context). The
# patch this repo needs (react-virtualized) is applied explicitly below
# instead of relying on husky/patch-package's own postinstall wiring.
RUN yarn install --frozen-lockfile --ignore-scripts
RUN npx patch-package

COPY . .
# Plain build, not build:ci — no Cypress coverage instrumentation in a
# runtime image.
RUN yarn build

# --- Runtime stage: just the Express backend + the already-built frontend ---
FROM node:22-alpine AS runtime
WORKDIR /app

COPY package.json yarn.lock ./
# Full install (including devDependencies): the backend runs through
# ts-node (see package.json's tsnode scripts), not a compiled JS build,
# so typescript/ts-node are needed at runtime too. Known simplification —
# a leaner image would compile the backend to plain JS and install
# --production only; out of scope for this demonstration.
#
# NODE_ENV=production is set only *after* this install, deliberately —
# yarn classic (v1) treats NODE_ENV=production exactly like --production
# and silently skips devDependencies, which would have removed ts-node/
# typescript here. Caught by the smoke test job in delivery.yml (it
# actually boots the image), not by the build succeeding.
RUN yarn install --frozen-lockfile --ignore-scripts
ENV NODE_ENV=production

COPY backend ./backend
COPY src ./src
COPY tsconfig.json tsconfig.tsnode.json ./
COPY .env ./
COPY data/database-seed.json ./data/database.json
COPY --from=builder /app/build ./public

# Un-instrumented backend runner (no nyc coverage) — same script already
# used for external hosting (CodeSandbox) in this repo.
RUN chown -R node:node /app
USER node

# VITE_BACKEND_PORT in .env — the single port serving both the API and
# the static frontend.
EXPOSE 3001
CMD ["yarn", "codesandbox:start:api"]

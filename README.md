# Real World Application

This project is a backend application that provides REST APIs for manipulating articles and their related tags and comments. This was inspired and motivated by [RealWorld](https://github.com/gothinkster/realworld) project, and thus it adheres to the [RealWorld backend REST API specification](https://realworld-docs.netlify.app/docs/specs/backend-specs/introduction).

## Project Overview

### Features

The application provides REST APIs to perform the following operations:

- authenticate users via JWT
- CRU- users
- CRUD articles
- CR-D comments on articles
- fetch paginated lists of articles
- favorite articles
- follow other users

In addition to features described in RealWorld project, the following features were additionally implemented:

- update user information including password and avatar picture
- extend the current user session using refresh token
- cache refresh token in redis for faster access and retrieve

### Stacks

Stacks used to build the application are:

- NestJS: NodeJS backend framework to implement endpoints
- Keycloak: identity and access management
- PostgreSQL: database system to store user accounts and articles
- MinIO: object storage to store avatar picture

## Installation

1. Clone the repository to local machine.

2. Run all services locally except for NestJS backend service using docker compose. Variables defined in `.env` are used for running the services in docker compose. Change the variables if necessary.

   ```bash
   cp .env.local .env
   docker compose --profile=backend-dev up
   ```

3. Run NestJS backend that exposes Rest APIs.

   ```bash
   cd nestjs-backend
   cp .env.local .env
   npm run start:dev
   ```

4. Swagger APIs are available in `http://localhost:3000/swagger`.

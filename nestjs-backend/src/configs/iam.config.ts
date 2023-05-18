import { registerAs } from '@nestjs/config';

export default registerAs('iam', () => ({
  host: process.env.KEYCLOAK_HOST,
  realm: process.env.KEYCLOAK_REALM,
  clientId: process.env.KEYCLOAK_CLIENT,
  clientSecret: process.env.KEYCLOAK_CLIENT_SECRET,
}));

export async function onRequestGet({ env }) {
  return Response.json({
    database_connected: !!env.DB,
    admin_token_configured: !!env.ADMIN_TOKEN
  });
}

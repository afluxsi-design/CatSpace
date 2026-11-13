export async function onRequestGet({ request, env }) {
  const expected = env.ADMIN_TOKEN;
  const supplied = request.headers.get("Authorization") || "";
  if (!expected || supplied !== `Bearer ${expected}`) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }
  if (!env.DB) return Response.json({ error: "Database binding DB is missing." }, { status: 503 });
  const { results } = await env.DB.prepare(`
    SELECT p.product_id, p.name, p.brand, p.asin, p.status,
           p.verification_status, c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON c.category_id = p.category_id
    ORDER BY p.category_id, p.product_id
  `).all();
  return Response.json({ products: results }, {
    headers: { "Cache-Control": "no-store" }
  });
}

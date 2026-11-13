export async function onRequestGet({ env }) {
  if (!env.DB) return Response.json({ error: "Database binding DB is missing." }, { status: 503 });
  const { results } = await env.DB.prepare(`
    SELECT p.product_id, p.name, p.brand, p.category_id, c.name AS category_name,
           p.short_description, p.status, p.verification_status
    FROM products p
    LEFT JOIN categories c ON c.category_id = p.category_id
    WHERE p.status = 'active' AND p.verification_status = 'verified'
    ORDER BY p.category_id, p.name
  `).all();
  return Response.json({ products: results }, {
    headers: { "Cache-Control": "public, max-age=60", "Access-Control-Allow-Origin": "*" }
  });
}

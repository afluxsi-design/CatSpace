
export async function onRequestGet({ env }) {
  if (!env.DB) {
    return Response.json(
      { error: "Database binding DB is missing." },
      { status: 503 }
    );
  }

  try {
    const { results } = await env.DB.prepare(`
      SELECT
        p.product_id,
        p.name,
        p.brand,
        p.asin,
        p.status,
        p.verification_status,
        c.name AS category_name
      FROM products p
      LEFT JOIN categories c
        ON c.category_id = p.category_id
      WHERE p.status = 'published'
        AND p.verification_status = 'verified'
      ORDER BY p.category_id, p.product_id
    `).all();

    return Response.json(
      { products: results },
      {
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Cache-Control": "no-store"
        }
      }
    );
  } catch (error) {
    return Response.json(
      {
        error: "Could not retrieve products.",
        details: error.message
      },
      { status: 500 }
    );
  }
}

export async function onRequestGet({ env }) {
  if (!env.DB) {
    return Response.json(
      { error: "Database connection unavailable." },
      { status: 503 }
    );
  }

  try {
    const { results } = await env.DB.prepare(`
      SELECT
        p.product_id,
        p.name,
        p.brand,
        p.category_id,
        p.subcategory,
        p.variant,
        p.short_description,
        p.editorial_summary,
        p.amazon_url,
        c.name AS category_name
      FROM products p
      LEFT JOIN categories c
        ON c.category_id = p.category_id
      WHERE p.status = 'active'
        AND p.verification_status = 'verified'
        AND c.active = 1
      ORDER BY c.sort_order, p.name
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
      { error: "Could not retrieve catalog." },
      { status: 500 }
    );
  }
}

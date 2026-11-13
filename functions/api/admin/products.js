
function authorize(request, env) {
  const expected = env.ADMIN_TOKEN;
  const supplied = request.headers.get("Authorization") || "";

  return Boolean(expected && supplied === `Bearer ${expected}`);
}

function json(data, status = 200) {
  return Response.json(data, {
    status,
    headers: { "Cache-Control": "no-store" }
  });
}

const editableFields = [
  "name",
  "brand",
  "category_id",
  "subcategory",
  "asin",
  "marketplace",
  "variant",
  "manufacturer_url",
  "amazon_url",
  "short_description",
  "editorial_summary",
  "status",
  "verification_status"
];

const allowedStatuses = [
  "active", "review", "unavailable", "replaced", "archived"
];

const allowedVerification = [
  "pending", "verified", "needs_review", "rejected"
];

export async function onRequestGet({ request, env }) {
  if (!authorize(request, env)) {
    return json({ error: "Unauthorized" }, 401);
  }

  if (!env.DB) {
    return json({ error: "Database binding DB is missing." }, 503);
  }

  try {
    const { results } = await env.DB.prepare(`
      SELECT p.*, c.name AS category_name
      FROM products p
      LEFT JOIN categories c ON c.category_id = p.category_id
      ORDER BY p.category_id, p.product_id
    `).all();

    return json({ products: results });
  } catch {
    return json({ error: "Could not retrieve catalog." }, 500);
  }
}

export async function onRequestPost({ request, env }) {
  if (!authorize(request, env)) {
    return json({ error: "Unauthorized" }, 401);
  }

  if (!env.DB) {
    return json({ error: "Database binding DB is missing." }, 503);
  }

  try {
    const body = await request.json();

    const productId = String(body.product_id || "").trim();
    const name = String(body.name || "").trim();
    const categoryId = String(body.category_id || "").trim();

    if (!/^[A-Za-z0-9_-]{3,60}$/.test(productId)) {
      return json({ error: "Invalid product ID." }, 400);
    }

    if (!name || !categoryId) {
      return json({ error: "Name and category are required." }, 400);
    }

    const values = {
      product_id: productId,
      name,
      brand: body.brand || null,
      category_id: categoryId,
      subcategory: body.subcategory || null,
      asin: body.asin || null,
      marketplace: body.marketplace || "US",
      variant: body.variant || null,
      manufacturer_url: body.manufacturer_url || null,
      amazon_url: body.amazon_url || null,
      short_description: body.short_description || null,
      editorial_summary: body.editorial_summary || null
    };

    await env.DB.prepare(`
      INSERT INTO products (
        product_id, name, brand, category_id, subcategory,
        asin, marketplace, variant, manufacturer_url, amazon_url,
        short_description, editorial_summary, status, verification_status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'review', 'pending')
    `).bind(
      values.product_id,
      values.name,
      values.brand,
      values.category_id,
      values.subcategory,
      values.asin,
      values.marketplace,
      values.variant,
      values.manufacturer_url,
      values.amazon_url,
      values.short_description,
      values.editorial_summary
    ).run();

    await env.DB.prepare(`
      INSERT INTO product_history
        (product_id, action, new_data, changed_by)
      VALUES (?, 'created', ?, 'admin')
    `).bind(productId, JSON.stringify(values)).run();

    await env.DB.prepare(`
      INSERT INTO audit_log
        (actor, action, entity_type, entity_id, details)
      VALUES ('admin', 'product_created', 'product', ?, ?)
    `).bind(productId, JSON.stringify(values)).run();

    return json({ success: true, product_id: productId }, 201);
  } catch (error) {
    return json({
      error: "Could not create product. Check the ID and category."
    }, 400);
  }
}

export async function onRequestPut({ request, env }) {
  if (!authorize(request, env)) {
    return json({ error: "Unauthorized" }, 401);
  }

  if (!env.DB) {
    return json({ error: "Database binding DB is missing." }, 503);
  }

  try {
    const body = await request.json();
    const productId = String(body.product_id || "").trim();

    if (!productId) {
      return json({ error: "Product ID is required." }, 400);
    }

    const current = await env.DB.prepare(`
      SELECT * FROM products WHERE product_id = ?
    `).bind(productId).first();

    if (!current) {
      return json({ error: "Product not found." }, 404);
    }

    const updates = {};
    for (const field of editableFields) {
      if (Object.prototype.hasOwnProperty.call(body, field)) {
        updates[field] = body[field];
      }
    }

    if (Object.keys(updates).length === 0) {
      return json({ error: "No editable fields supplied." }, 400);
    }

    const nextStatus = updates.status ?? current.status;
    const nextVerification =
      updates.verification_status ?? current.verification_status;

    if (!allowedStatuses.includes(nextStatus)) {
      return json({ error: "Invalid product status." }, 400);
    }

    if (!allowedVerification.includes(nextVerification)) {
      return json({ error: "Invalid verification status." }, 400);
    }

    if (nextStatus === "active" && nextVerification !== "verified") {
      return json({
        error: "A product must be verified before publication."
      }, 400);
    }

    if (updates.name !== undefined && !String(updates.name).trim()) {
      return json({ error: "Product name cannot be empty." }, 400);
    }

    const fields = Object.keys(updates);
    const assignments = fields.map(field => `${field} = ?`).join(", ");
    const values = fields.map(field => updates[field]);

    await env.DB.prepare(`
      UPDATE products
      SET ${assignments}, updated_at = CURRENT_TIMESTAMP
      WHERE product_id = ?
    `).bind(...values, productId).run();

    const updated = { ...current, ...updates };

    await env.DB.prepare(`
      INSERT INTO product_history
        (product_id, action, previous_data, new_data, changed_by)
      VALUES (?, 'updated', ?, ?, 'admin')
    `).bind(
      productId,
      JSON.stringify(current),
      JSON.stringify(updated)
    ).run();

    await env.DB.prepare(`
      INSERT INTO audit_log
        (actor, action, entity_type, entity_id, details)
      VALUES ('admin', 'product_updated', 'product', ?, ?)
    `).bind(productId, JSON.stringify(updates)).run();

    return json({ success: true, product_id: productId });
  } catch {
    return json({ error: "Could not update product." }, 400);
  }
}

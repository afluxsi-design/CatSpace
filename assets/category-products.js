async function loadCategory(categoryId) {
  const container = document.getElementById("products");
  if (!container) return;
  try {
    const response = await fetch("/api/products", { headers: { Accept: "application/json" } });
    if (!response.ok) throw new Error("Catalog unavailable");
    const data = await response.json();
    const products = Array.isArray(data.products)
      ? data.products.filter(item => item.category_id === categoryId)
      : [];
    container.replaceChildren();
    if (!products.length) {
      const note = document.createElement("article");
      note.className = "product-placeholder";
      const title = document.createElement("h3");
      title.textContent = "Verified comparisons are being prepared";
      const body = document.createElement("p");
      body.textContent = "There are no products approved for publication in this category yet. We will not display unverified candidates as recommendations.";
      note.append(title, body);
      container.append(note);
      return;
    }
    products.forEach(product => {
      const card = document.createElement("article");
      card.className = "product-placeholder";
      const title = document.createElement("h3");
      title.textContent = product.name || "Cat furniture";
      const brand = document.createElement("p");
      brand.textContent = product.brand || "";
      const description = document.createElement("p");
      description.textContent = product.editorial_summary || product.short_description || "See the product details.";
      card.append(title, brand, description);
      if (product.amazon_url) {
        const link = document.createElement("a");
        link.className = "text-link";
        link.href = product.amazon_url;
        link.target = "_blank";
        link.rel = "nofollow sponsored noopener";
        link.textContent = "View on Amazon →";
        card.append(link);
      }
      container.append(card);
    });
  } catch (error) {
    container.textContent = "The product catalog is temporarily unavailable. Please try again later.";
  }
}

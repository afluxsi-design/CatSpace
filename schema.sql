PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS categories (
  category_id TEXT PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
  product_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  brand TEXT,
  category_id TEXT NOT NULL,
  subcategory TEXT,
  asin TEXT,
  marketplace TEXT NOT NULL DEFAULT 'US',
  variant TEXT,
  manufacturer_url TEXT,
  amazon_url TEXT,
  short_description TEXT,
  editorial_summary TEXT,
  status TEXT NOT NULL DEFAULT 'review'
    CHECK(status IN ('active','review','unavailable','replaced','archived')),
  verification_status TEXT NOT NULL DEFAULT 'pending'
    CHECK(verification_status IN ('pending','verified','needs_review','rejected')),
  verified_at TEXT,
  replacement_product_id TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(category_id) REFERENCES categories(category_id),
  FOREIGN KEY(replacement_product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS product_specs (
  spec_id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id TEXT NOT NULL,
  spec_key TEXT NOT NULL,
  spec_value TEXT,
  unit TEXT,
  notes TEXT,
  source_id INTEGER,
  verified_at TEXT,
  FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS product_sources (
  source_id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id TEXT NOT NULL,
  source_type TEXT NOT NULL
    CHECK(source_type IN ('manufacturer','amazon','customer_review','editorial','other')),
  source_name TEXT,
  source_url TEXT NOT NULL,
  notes TEXT,
  checked_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS product_history (
  history_id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id TEXT NOT NULL,
  action TEXT NOT NULL,
  previous_data TEXT,
  new_data TEXT,
  changed_by TEXT,
  changed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS product_replacements (
  replacement_id INTEGER PRIMARY KEY AUTOINCREMENT,
  old_product_id TEXT NOT NULL,
  new_product_id TEXT NOT NULL,
  reason TEXT,
  effective_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  changed_by TEXT,
  FOREIGN KEY(old_product_id) REFERENCES products(product_id),
  FOREIGN KEY(new_product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS articles (
  article_id TEXT PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  meta_description TEXT,
  article_type TEXT NOT NULL DEFAULT 'guide',
  category_id TEXT,
  status TEXT NOT NULL DEFAULT 'draft'
    CHECK(status IN ('draft','review','published','archived')),
  published_at TEXT,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS article_products (
  article_id TEXT NOT NULL,
  product_id TEXT NOT NULL,
  display_order INTEGER NOT NULL DEFAULT 0,
  editorial_label TEXT,
  PRIMARY KEY(article_id, product_id),
  FOREIGN KEY(article_id) REFERENCES articles(article_id) ON DELETE CASCADE,
  FOREIGN KEY(product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS amazon_settings (
  setting_key TEXT PRIMARY KEY,
  setting_value TEXT,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit_log (
  audit_id INTEGER PRIMARY KEY AUTOINCREMENT,
  actor TEXT,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  details TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status, verification_status);
CREATE INDEX IF NOT EXISTS idx_products_asin ON products(asin);
CREATE INDEX IF NOT EXISTS idx_sources_product ON product_sources(product_id);
CREATE INDEX IF NOT EXISTS idx_article_products_product ON article_products(product_id);

INSERT OR IGNORE INTO categories(category_id, slug, name, description, sort_order) VALUES
('CAT-TREE','large-cat-trees','Large Cat Trees','Tall, sturdy and spacious indoor cat trees.',1),
('CAT-WALL','cat-wall-furniture','Cat Wall Furniture','Wall shelves, steps and climbing systems.',2),
('CAT-WINDOW','window-perches','Window Perches','Window hammocks, beds and sill platforms.',3);

-- Initial candidate bank. These are NOT approved recommendations.
INSERT OR IGNORE INTO products(product_id,name,brand,category_id,asin,marketplace,amazon_url,status,verification_status,short_description) VALUES
('TREE-001','Globlazer F70 Pro','Globlazer','CAT-TREE','B0DGKR5MMP','US','https://www.amazon.com/dp/B0DGKR5MMP','review','pending','Initial candidate. Verify current ASIN, variant and manufacturer specifications.'),
('TREE-002','Feandrea UPCT190G01','Feandrea','CAT-TREE','B08MQ7ZD4G','US','https://www.amazon.com/dp/B08MQ7ZD4G','review','pending','Initial candidate. Verify current ASIN, variant and manufacturer specifications.'),
('TREE-003','Heybly HCT034G 71-inch','Heybly','CAT-TREE','B0D2VVHS5F','US','https://www.amazon.com/dp/B0D2VVHS5F','review','pending','Initial candidate. Verify current ASIN, variant and manufacturer specifications.'),
('WALL-001','FUKUMARU 4-in-1 Beige','FUKUMARU','CAT-WALL','B0GSFG68GB','US','https://www.amazon.com/dp/B0GSFG68GB','review','pending','Initial candidate. Confirm that this is a complete wall furniture system.'),
('WALL-002','FUKUMARU 5-in-1 Beige','FUKUMARU','CAT-WALL','B0DX75TKSB','US','https://www.amazon.com/dp/B0DX75TKSB','review','pending','Initial candidate. Verify included components and installation specifications.'),
('WALL-003','Cat Wall Shelves 6-in-1 Black','Unconfirmed brand','CAT-WALL','B0FJDY749J','US','https://www.amazon.com/dp/B0FJDY749J','review','pending','Initial candidate. Verify brand, product identity and system completeness.'),
('WINDOW-001','Zakkart SnugCloud Large','Zakkart','CAT-WINDOW','B0F9FB86V8','US','https://www.amazon.com/dp/B0F9FB86V8','review','pending','Initial candidate. Verify size variant and mounting instructions.'),
('WINDOW-002','Zakkart Windowsill Bolster 24-inch','Zakkart','CAT-WINDOW','B0CBTXSBFW','US','https://www.amazon.com/dp/B0CBTXSBFW','review','pending','Initial candidate. Verify current variant and dimensions.'),
('WINDOW-003','AMOSIJOY Cordless Window Perch','AMOSIJOY','CAT-WINDOW','B09WDDGP2V','US','https://www.amazon.com/dp/B09WDDGP2V','review','pending','Initial candidate. Verify current variant and installation details.');

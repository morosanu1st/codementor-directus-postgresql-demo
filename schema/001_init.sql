-- Directus + PostgreSQL mentoring demo schema
-- Small products/categories model that maps cleanly to Directus collections.

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL,
    slug        TEXT NOT NULL UNIQUE,
    description TEXT,
    date_created TIMESTAMPTZ NOT NULL DEFAULT now(),
    date_updated TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS products (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name         TEXT NOT NULL,
    sku          TEXT NOT NULL UNIQUE,
    price        NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,
    category     UUID REFERENCES categories (id) ON DELETE SET NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT now(),
    date_updated TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_products_category ON products (category);
CREATE INDEX IF NOT EXISTS idx_products_active ON products (is_active);

INSERT INTO categories (name, slug, description) VALUES
    ('Hardware', 'hardware', 'Physical devices and accessories'),
    ('Software', 'software', 'Licenses and digital goods')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (name, sku, price, is_active, category)
SELECT
    'USB-C Hub',
    'SKU-HUB-01',
    49.99,
    TRUE,
    c.id
FROM categories c
WHERE c.slug = 'hardware'
ON CONFLICT (sku) DO NOTHING;

INSERT INTO products (name, sku, price, is_active, category)
SELECT
    'Editor Pro License',
    'SKU-ED-PRO',
    129.00,
    TRUE,
    c.id
FROM categories c
WHERE c.slug = 'software'
ON CONFLICT (sku) DO NOTHING;

-- Useful read model for mentoring: expose as a Directus read-only collection or view.
CREATE OR REPLACE VIEW products_with_category AS
SELECT
    p.id,
    p.name,
    p.sku,
    p.price,
    p.is_active,
    c.name AS category_name,
    c.slug AS category_slug
FROM products p
LEFT JOIN categories c ON c.id = p.category;

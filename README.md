# Directus PostgreSQL Demo

Minimal, practical examples showing how I help with **Directus + PostgreSQL**: collections modeling, schema, config, and common query/setup patterns.

## What this demo shows

- A small PostgreSQL schema that maps cleanly to Directus collections
- Example Directus `snapshot`/collection YAML for products & categories
- Environment config sketch for connecting Directus to Postgres
- Mentoring notes: how we'd set up, model, and query together

## Layout

```
schema/
  001_init.sql           — Postgres tables + indexes + sample rows
config/
  .env.example           — Directus ↔ Postgres connection knobs
  collections-snapshot.yaml — illustrative Directus collection definitions
```

## How I'd help you set up / model / query

### 1. Setup
- Provision Postgres (local Docker or managed)
- Point Directus at it with `DB_CLIENT=pg` and a dedicated app user
- Run migrations / apply SQL first when you already have a schema; or let Directus create collections when greenfield
- Confirm Admin UI comes up, then lock down public role permissions

### 2. Modeling habits
- One collection ≈ one clear business entity (products, categories, orders)
- Prefer real FK relationships over loose UUID strings without constraints
- Use Directus relations (M2O / O2M / M2M) that mirror Postgres FKs
- Keep display templates and interfaces sensible for editors (not just API consumers)

### 3. Query patterns
- REST: `/items/products?filter[category][slug][_eq]=hardware&fields=*,category.*`
- GraphQL when the client needs nested shapes in one round-trip
- For heavy analytics, query Postgres directly (views) and expose read-only collections
- Always page (`limit`/`offset` or cursor) — never dump whole tables

### 4. Typical session flow
1. Clarify your data model on a whiteboard (entities + cardinality)
2. Write/review SQL or Directus snapshot for the core collections
3. Wire env + start Directus against your DB
4. Set roles/permissions for the API consumer
5. Hit one real endpoint together and adjust fields/filters

## Quick start (sketch)

```bash
# 1) Start Postgres and apply schema
psql "$DATABASE_URL" -f schema/001_init.sql

# 2) Copy env and fill secrets
cp config/.env.example .env

# 3) Run Directus (Docker example)
# docker compose up -d
# Then import or recreate collections to match schema/collections-snapshot.yaml
```

## Sample REST filter (after collections exist)

```http
GET /items/products?filter[is_active][_eq]=true&fields=id,name,price,category.name&sort=name
```

## Who this is for

Builders wiring Directus as a headless CMS / internal admin on PostgreSQL who want clean schema design, relations, and practical query help — without a giant boilerplate app.

---

*Codementor demo — topic/skill sample only.*

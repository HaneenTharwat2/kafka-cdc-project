CREATE SCHEMA IF NOT EXISTS test_db;

CREATE TABLE IF NOT EXISTS test_db.users (
    _id TEXT PRIMARY KEY,
    data JSONB,
    createdat TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS test_db.orders (
    _id TEXT PRIMARY KEY,
    data JSONB,
    createdat TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE test_db.users OWNER TO admin;
ALTER TABLE test_db.orders OWNER TO admin;

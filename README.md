#  Kafka CDC: PostgreSQL → Kafka → Snowflake

This project demonstrates a real-time **Change Data Capture (CDC)** pipeline using **Debezium**, **Apache Kafka**, and **Snowflake**. Changes in PostgreSQL are streamed to Kafka topics, then delivered into Snowflake for analytics.

---

##  Technologies Used

* Apache Kafka + Kafka Connect
* Debezium PostgreSQL Source Connector
* Snowflake Sink Connector
* PostgreSQL
* Docker Compose

---

##  Quick Start

###  1. Start All Services

```bash
docker compose -f dc.yaml up -d
```

---

### 2. Access PostgreSQL

Connect using any SQL client or the VS Code PostgreSQL extension:

* **Host**: `localhost`
* **Port**: `5432`
* **User**: `admin`
* **Password**: `password`

---

### 3. Create Schema and Tables

You can either run [`init/ed-pg.sql`](./init/ed-pg.sql) or manually execute:

```sql
CREATE SCHEMA IF NOT EXISTS test_db;

CREATE TABLE test_db.users (
  _id TEXT PRIMARY KEY,
  data JSONB,
  createdat TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE test_db.orders (
  _id TEXT PRIMARY KEY,
  data JSONB,
  createdat TIMESTAMPTZ DEFAULT now()
);
```

---

### 4. Register Connectors

#### PostgreSQL Source Connector

```bash
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @connectors/pg/debezium-postgres-source.json
```

#### Snowflake Sink Connector

```bash
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @connectors/snowflake/snowflake-sink-connector.json
```

---

##  Sample Insert

```sql
INSERT INTO test_db.users (_id, data)
VALUES ('u1', '{"name": "Haneen", "email": "haneen@example.com"}');

INSERT INTO test_db.orders (_id, data)
VALUES ('order1', '{
  "_id": "order1",
  "userId": "u1",
  "status": "processing",
  "orderDate": "2025-07-08",
  "totalAmount": 199.99,
  "paymentMethod": "credit_card",
  "lineItems": [
    {
      "name": "Keyboard",
      "price": 49.99,
      "quantity": 1,
      "subtotal": 49.99,
      "productId": "p1001"
    }
  ],
  "billingAddress": {
    "city": "Cairo",
    "state": "EG",
    "street": "Tahrir",
    "zipCode": "11511"
  },
  "shippingAddress": {
    "city": "Cairo",
    "state": "EG",
    "street": "Zamalek",
    "zipCode": "11211"
  }
}');
```

---



🖼️ Result Snapshots
🟢 Kafka Topic: Users

🟢 Kafka Topic: Orders

🟦 Snowflake Table: Users

🟦 Snowflake Table: Orders




---

##  Security Notice

All secrets (e.g., private keys, passphrases) are **redacted** from this repo. Do not share credentials publicly.

---


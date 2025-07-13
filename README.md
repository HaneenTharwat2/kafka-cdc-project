# Kafka CDC: PostgreSQL → Kafka → Snowflake

This project demonstrates a real-time **Change Data Capture (CDC)** pipeline using **Debezium**, **Apache Kafka**, and **Snowflake**. Changes in PostgreSQL are captured, streamed to Kafka topics, and finally delivered into Snowflake for analytics — all orchestrated via Docker Compose.

---

## Technologies Used

* Apache Kafka + Kafka Connect
* Debezium PostgreSQL Source Connector
* Snowflake Kafka Sink Connector
* PostgreSQL
* Docker Compose

---

## Quick Start

### 1. Start All Services

```bash
docker compose -f dc.yaml up -d
```

---

### 2. Access PostgreSQL

You can connect using VS Code PostgreSQL extension or any SQL client:

* Host: `localhost`
* Port: `5432`
* User: `admin`
* Password: `password`

---

### 3. Create Schema and Tables

Run the script in [`init/ed-pg.sql`](./init/ed-pg.sql) or manually:

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

### 4. Register Kafka Connectors

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

## Plugin Setup

Kafka Connect loads custom plugins from the mounted path:

```yaml
CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components,/tmp/ext-plugins"
```

In this project, plugins are located in the `plugins/` folder:

```

Alternatively, install them manually using:

```bash
confluent-hub install debezium/debezium-connector-postgresql:latest
confluent-hub install snowflakeinc/snowflake-kafka-connector:3.2.0
```

---

## Sample Data Insert

```sql
INSERT INTO test_db.users (_id, data)
VALUES ('u1', '{"name": "Haneen", "email": "haneen@example.com"}');

INSERT INTO test_db.orders (_id, data)
VALUES (
  'order1',
  '{
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
  }'
);
```

---

## Key Files

* `dc.yaml`: Docker Compose configuration
* `init/ed-pg.sql`: SQL schema and table creation script
* `connectors/pg/debezium-postgres-source.json`: Debezium source connector config
* `connectors/snowflake/snowflake-sink-connector.json`: Snowflake sink connector config
* `plugins/`: Contains required Kafka Connect plugins

---

## Security Notice

All secrets (e.g., Snowflake private keys, passwords) are redacted for security. Please replace them with your own credentials securely in your local environment.

---



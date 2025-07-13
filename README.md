Here is your complete and professional `README.md` file with the plugin section and updated structure:

---

# Kafka CDC: PostgreSQL → Kafka → Snowflake

This project demonstrates a real-time **Change Data Capture (CDC)** pipeline using **Debezium**, **Apache Kafka**, and **Snowflake**. Changes in PostgreSQL are captured, streamed to Kafka topics, and finally delivered into Snowflake for analytics — all orchestrated via Docker Compose.

---

## 🧰 Technologies Used

* Apache Kafka + Kafka Connect
* Debezium PostgreSQL Source Connector
* Snowflake Kafka Sink Connector
* PostgreSQL
* Docker Compose

---

## 🚀 Quick Start

### 1. Start All Services

```bash
docker compose -f dc.yaml up -d
```

---

### 2. Access PostgreSQL

You can connect using VS Code PostgreSQL extension or any SQL client:

* **Host:** `localhost`
* **Port:** `5432`
* **User:** `admin`
* **Password:** `password`

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

## 🔌 Plugin Setup

Kafka Connect loads custom plugins from the mounted path:

```yaml
CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components,/tmp/ext-plugins"
```

In this project, plugins are located in the `plugins/` folder:

```
plugins/
├── debezium-connector-postgres
└── snowflakeinc-snowflake-kafka-connector-3.2.0
```

> If you're cloning this repo, ensure these plugin directories exist. Otherwise, you can install them using:

```bash
confluent-hub install debezium/debezium-connector-postgresql:latest
confluent-hub install snowflakeinc/snowflake-kafka-connector:3.2.0
```

---

## 📁 Project Structure

```
kafka-cdc-project/
│
├── dc.yaml                         # Docker Compose setup
├── README.md
│
├── init/
│   └── ed-pg.sql                   # SQL script to create schema & tables
│
├── connectors/
│   ├── pg/
│   │   └── debezium-postgres-source.json
│   └── snowflake/
│       └── snowflake-sink-connector.json
│
├── plugins/
│   ├── debezium-connector-postgres/
│   └── snowflakeinc-snowflake-kafka-connector-3.2.0/
│
├── ResultSnapshots/
│   ├── users-topic-messages.png
│   ├── orders-topic-messages.png
│   ├── snowflake-users-table.png
│   └── snowflake-orders-table.png
│
└── diagram/
    └── architecture.drawio.png
```

---

## 🧪 Sample Data Insert

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

## 📸 Output Snapshots

| Kafka Topic Messages                             | Snowflake Table Results                           |
| ------------------------------------------------ | ------------------------------------------------- |
| ![](./ResultSnapshots/users-topic-messages.png)  | ![](./ResultSnapshots/snowflake-users-table.png)  |
| ![](./ResultSnapshots/orders-topic-messages.png) | ![](./ResultSnapshots/snowflake-orders-table.png) |

---

## 🔒 Security Notice

All secrets such as private keys, passwords, and credentials are **redacted** or excluded for security reasons.

---

Let me know if you'd like a downloadable `.md` version or if you'd like to tailor this for PDF or GitHub Pages.

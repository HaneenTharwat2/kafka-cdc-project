Sure! Here's your **complete `README.md`** including the updated **image paths** for your result snapshots:

---

# 📡 Kafka CDC: PostgreSQL → Kafka → Snowflake

This project demonstrates a real-time **Change Data Capture (CDC)** pipeline using **Debezium**, **Apache Kafka**, and **Snowflake**. Changes in PostgreSQL are streamed to Kafka topics and then delivered into Snowflake for analytics.

---

## 🚀 Technologies Used

* Apache Kafka + Kafka Connect
* Debezium PostgreSQL Source Connector
* Snowflake Sink Connector
* PostgreSQL
* Docker Compose

---

## ⚙️ Quick Start

### 1️⃣ Start All Services

```bash
docker compose -f dc.yaml up -d
```

---

### 2️⃣ Access PostgreSQL

You can connect using VS Code, DBeaver, or any PostgreSQL client:

* **Host**: `localhost`
* **Port**: `5432`
* **User**: `admin`
* **Password**: `password`

---

### 3️⃣ Initialize the Database

You can run the initialization script:

```sql
-- File: init/ed-pg.sql

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

### 4️⃣ Register the Connectors

#### 🔌 PostgreSQL Source Connector

```bash
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @connectors/pg/debezium-postgres-source.json
```

#### ❄️ Snowflake Sink Connector

```bash
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @connectors/snowflake/snowflake-sink-connector.json
```

---

## 🗃️ Key Files

* `dc.yaml` — Docker Compose configuration.
* `connectors/pg/debezium-postgres-source.json` — Debezium source connector config.
* `connectors/snowflake/snowflake-sink-connector.json` — Snowflake sink connector config.
* `init/ed-pg.sql` — PostgreSQL schema and tables creation.

---

## 📝 Sample Data Insert

```sql
INSERT INTO test_db.users (_id, data)
VALUES ('u1', '{"name": "Haneen", "email": "haneen@example.com"}');
```

---

## 🖼️ Result Snapshots

### 🟢 Kafka Topic: Users

![Users Topic Messages](./ResultSnapshots/users-topic-messages.png)

### 🟢 Kafka Topic: Orders

![Orders Topic Messages](./ResultSnapshots/orders-topic-messages.png)

### ❄️ Snowflake Table: Users

![Snowflake Users Table](./ResultSnapshots/snowflake-users-table.png)

### ❄️ Snowflake Table: Orders

![Snowflake Orders Table](./ResultSnapshots/snowflake-orders-table.png)

---

## 🔐 Security Notice

> All credentials, private keys, and sensitive information have been **redacted** from this repository for security.

---

Let me know if you'd like a downloadable version or a different formatting style!

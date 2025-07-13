# 📡 Kafka CDC: PostgreSQL → Kafka → Snowflake

This project demonstrates a real-time **Change Data Capture (CDC)** pipeline using **Debezium**, **Apache Kafka**, and **Snowflake**. It captures changes from PostgreSQL tables, streams them into Kafka topics, and sinks them into Snowflake for analytics and reporting.

---

## 🚀 Technologies Used

* **Apache Kafka** (event streaming platform)
* **Kafka Connect** (connector framework)
* **Debezium PostgreSQL Source Connector**
* **Snowflake Sink Connector**
* **PostgreSQL**
* **Docker Compose**

---

## ⚙️ Quick Start

### 1. Start All Services

```bash
docker compose -f dc.yaml up -d
```

---

### 2. Access PostgreSQL

You can connect using a PostgreSQL client (DBeaver, VS Code extension, etc.):

* **Host:** `localhost`
* **Port:** `5432`
* **Username:** `admin`
* **Password:** `password`

---

### 3. Create Schema and Tables

Execute the SQL in [`init/ed-pg.sql`](./init/ed-pg.sql), or paste manually:

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

#### 🔗 PostgreSQL Source Connector

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

## 🗂️ Project Structure

```
📁 connectors/
  ├── 📁 pg/
  │   └── debezium-postgres-source.json
  └── 📁 snowflake/
      └── snowflake-sink-connector.json

📁 init/
  └── ed-pg.sql

📁 Result-Snapshots/
  ├── users-topic.png
  ├── orders-topic.png
  ├── snowflake-users.png
  └── snowflake-orders.png

📄 dc.yaml
📄 README.md
📄 diagram.png (optional architecture diagram)
```

---

## 🖼️ Result Snapshots

### 🟢 Kafka Topic: Users

![Users Topic](./ResultSnapshots/users-topic-messages.png)

### 🟢 Kafka Topic: Orders

![Orders Topic](./ResultSnapshots/orders-topic-messages.png)

### 🟦 Snowflake Table: Users

![Snowflake Users](./ResultSnapshots/snowflake-users-table.png)

### 🟦 Snowflake Table: Orders

![Snowflake Orders](./ResultSnapshots/snowflake-orders-table.png)

---

## 🔐 Security Notice

All credentials (e.g. passwords, private keys) have been redacted from this repo. Never commit sensitive credentials to version control.

---

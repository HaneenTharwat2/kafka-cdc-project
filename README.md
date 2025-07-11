# Kafka CDC: PostgreSQL → Kafka → Snowflake

This project demonstrates a **Change Data Capture (CDC)** pipeline using **Debezium**, **Apache Kafka**, and **Snowflake**. Changes in a PostgreSQL database are streamed through Kafka and delivered into Snowflake for analysis.

---

## 🛠 Technologies

- Apache Kafka + Kafka Connect
- Debezium PostgreSQL Source Connector
- Snowflake Sink Connector
- PostgreSQL
- Docker Compose

---

## 🚀 Quick Start

1. **Start services**  
   ```bash
   docker compose -f dc.yaml up -d
````

2. **Access PostgreSQL**
   Connect using:

   * Host: `localhost`
   * Port: `5432`
   * User: `admin`
   * Password: `password`

3. **Create schema & tables**
   Run SQL in [`init/ed-pg.sql`](./init/ed-pg.sql) or manually:

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

4. **Register connectors**

   * Postgres Source:

     ```bash
     curl -X POST http://localhost:8083/connectors \
       -H "Content-Type: application/json" \
       -d @connectors/pg/debezium-postgres-source.json
     ```

   * Snowflake Sink:

     ```bash
     curl -X POST http://localhost:8083/connectors \
       -H "Content-Type: application/json" \
       -d @connectors/snowflake/snowflake-sink-connector.json
     ```

---

## 🔗 Key Files

* [`docker-compose.yaml`](./docker-compose.yaml) – Kafka, Connect, PostgreSQL
* [`debezium-postgres-source.json`](./connectors/pg/debezium-postgres-source.json) – Debezium config
* [`snowflake-sink-connector.json`](./connectors/snowflake/snowflake-sink-connector.json) – Snowflake sink config

---

## 📌 Example Data Insert

```sql
INSERT INTO test_db.users (_id, data)
VALUES ('u1', '{"name": "Haneen", "email": "haneen@example.com"}');
```

---

## 🔐 Security Notice

Snowflake credentials and private keys are **redacted** in configuration files for safety.

---

## 👩‍💻 Author

**Haneen**
Kafka CDC Project — ITI Big Data Lab

```

---

This version keeps it simple and clean while covering all the core parts.  
Let me know if you want a **PDF version** or want this in **Arabic** too!
```

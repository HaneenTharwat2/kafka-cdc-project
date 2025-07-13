

### Access PostgreSQL

Connect using any SQL client or VS Code extension:

* Host: localhost
* Port: 5432
* User: admin
* Password: password

### Create schema and tables

Run the script in [init/ed-pg.sql](./init/ed-pg.sql), or manually:

sql
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


### Register connectors

#### PostgreSQL Source Connector

bash
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @connectors/pg/debezium-postgres-source.json


#### Snowflake Sink Connector

bash
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @connectors/snowflake/snowflake-sink-connector.json


---

##  Key Files

* [dc.yaml](./dc.yaml) – Docker Compose configuration
* [connectors/pg/debezium-postgres-source.json](./connectors/pg/debezium-postgres-source.json) – Debezium source connector config
* [connectors/snowflake/snowflake-sink-connector.json](./connectors/snowflake/snowflake-sink-connector.json) – Snowflake sink connector config (credentials redacted)

---

##  Sample Data Insert

sql
INSERT INTO test_db.users (_id, data)
VALUES ('u1', '{"name": "Haneen", "email": "haneen@example.com"}');


---

##  Security Notice

All secrets such as private keys and passwords are **redacted**.

# Part 5 — Data Lake

## Architecture Recommendation

### Scenario
A fast-growing food delivery startup collects GPS location logs, customer text reviews, payment transactions, and restaurant menu images. The question is which storage architecture to recommend — Data Warehouse, Data Lake, or Data Lakehouse.

---

### Recommendation: Data Lakehouse

A **Data Lakehouse** is the right choice for this startup, and the reasoning comes directly from the nature of the data being collected.

**Reason 1 — The data is fundamentally multi-format and unstructured.**
The startup collects four completely different types of data: GPS logs (time-series), text reviews (unstructured), payment transactions (structured), and menu images (binary/blob). A traditional Data Warehouse like Redshift or BigQuery is designed exclusively for structured, relational data. It cannot store GPS streams, raw text, or images natively. A pure Data Lake (like S3 or HDFS) can store all these formats but offers no query engine, schema enforcement, or ACID transactions — making reliable analytics difficult. A Data Lakehouse combines both: it stores raw multi-format data like a lake while supporting SQL queries, schema management, and ACID compliance like a warehouse.

**Reason 2 — The startup needs both real-time operational queries and long-term analytics.**
Payment transactions require ACID guarantees — a failed payment must not be partially recorded. GPS logs need fast ingestion at high volume. Text reviews need NLP pipelines. A Lakehouse architecture (using tools like Delta Lake or Apache Iceberg) supports streaming ingestion, batch processing, and SQL analytics on the same platform, eliminating the need to maintain separate systems.

**Reason 3 — Cost and scalability at startup scale.**
A Data Warehouse requires pre-defined schemas and is expensive to restructure as the business evolves. A startup's data model changes rapidly — new cities, new features, new metrics. A Lakehouse on cloud object storage (S3 + Delta Lake) scales cheaply, allows schema evolution, and supports machine learning workloads (e.g., sentiment analysis on reviews, ETA prediction from GPS) directly on the same data — without copying data between systems.


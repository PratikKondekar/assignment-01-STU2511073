# Part 6 — Capstone Architecture Design

## Storage Systems

The hospital AI system has four distinct goals, each requiring a different storage solution chosen specifically for the nature of its data and access patterns.

**Goal 1 — Predict patient readmission risk** uses a **Data Warehouse (Snowflake)**. Readmission prediction requires running complex analytical queries over large volumes of historical structured data — past diagnoses, treatment outcomes, lab results, and discharge records. Snowflake's columnar storage and massively parallel processing make it ideal for this kind of batch analytical workload. The data is cleaned, structured, and loaded via an ETL pipeline from the raw Data Lake.

**Goal 2 — Allow doctors to query patient history in plain English** uses a **Vector Database (Pinecone)**. When a doctor asks "Has this patient had a cardiac event before?", a keyword search would fail because medical records use inconsistent terminology across different doctors and time periods. The solution is to embed all patient history documents as vectors using a model like all-MiniLM-L6-v2, store them in Pinecone, and retrieve the semantically closest records to the doctor's natural language query. This is the only storage type capable of supporting semantic similarity search at scale.

**Goal 3 — Generate monthly reports for hospital management** also uses **Snowflake (Data Warehouse)**. Monthly reports on bed occupancy and department-wise costs are classic OLAP workloads — aggregations, GROUP BY queries, and time-series summaries over structured transactional data. Snowflake's separation of storage and compute means reporting dashboards can run heavy queries without impacting operational systems.

**Goal 4 — Stream and store real-time vitals from ICU devices** uses a **Time-Series Database (InfluxDB)**. ICU monitoring devices emit readings every few seconds — heart rate, blood pressure, oxygen saturation. Relational databases cannot ingest this volume efficiently. InfluxDB is purpose-built for high-frequency time-stamped data, supports downsampling for long-term retention, and enables real-time alerting when a vital crosses a threshold.

All raw data from every source is first landed in a **Data Lake (Amazon S3)**, which acts as the single source of truth before being routed to the appropriate specialized store.

---

## OLTP vs OLAP Boundary

The **OLTP boundary** ends at the source systems — the EHR (Electronic Health Records) system, the billing platform, and the ICU monitoring devices. These systems handle transactional writes: recording a new diagnosis, processing a payment, or logging a vital sign. They are optimized for low-latency individual record reads and writes with full ACID compliance.

The **OLAP boundary begins at the Data Lake**. Once raw data lands in S3, it enters the analytical pipeline. From there, cleaned and transformed data flows into Snowflake for aggregation and reporting. The ETL pipeline between the Data Lake and the Data Warehouse is the precise boundary — on the left side, systems write individual records; on the right side, systems read and aggregate millions of records for insights. The Vector Database and Time-Series Database also sit on the OLAP side, serving analytical and AI workloads rather than operational transactions.

---

## Trade-offs

The most significant trade-off in this design is **complexity vs specialization**. Using four different storage systems (Data Lake, Data Warehouse, Vector Database, Time-Series Database) means each system is optimally suited to its workload — but it also means the engineering team must maintain four different technologies, manage four sets of credentials and access controls, and build ETL pipelines to keep data synchronized across them.

A simpler alternative would be to store everything in a single relational database like PostgreSQL. This would be far easier to manage but would perform poorly for semantic search (no vector indexing), real-time streaming (no time-series optimization), and large-scale analytics (row-based storage is slow for aggregations).

**Mitigation strategy**: The complexity can be managed by adopting a **Data Lakehouse architecture** using Apache Iceberg or Delta Lake on top of S3. This reduces the number of systems by unifying the Data Lake and Data Warehouse layers into a single query able platform, while keeping the specialized Vector DB and Time-Series DB only where truly necessary. Additionally, a unified data catalog (such as AWS Glue) can provide a single metadata layer across all storage systems, reducing operational overhead significantly.


# Part 2 — NoSQL Databases

## Database Recommendation

### Scenario
A healthcare startup is building a patient management system. One engineer recommends MySQL; another recommends MongoDB. Given ACID vs BASE properties and the CAP theorem, which is the better choice — and would that change if a fraud detection module were added?

---

### Recommendation: MySQL (Relational Database)

For a patient management system, **MySQL is the stronger choice**, and the reasoning comes directly from the fundamental properties of each database type.

Healthcare data is among the most sensitive and strictly regulated data in existence. Patient records must be **accurate, consistent, and never partially written**. This is precisely what ACID guarantees — Atomicity ensures a transaction either completes fully or not at all, Consistency ensures data always moves from one valid state to another, Isolation ensures concurrent operations do not interfere with each other, and Durability ensures committed data survives system failures. If a doctor updates a patient's medication dosage and the system crashes mid-write, ACID ensures the old value is preserved rather than leaving corrupt data. MongoDB's BASE model (Basically Available, Soft state, Eventually consistent) explicitly trades this reliability for availability and speed — an acceptable trade-off for a product catalog, but not for patient records.

The CAP theorem states that a distributed system can only guarantee two of three properties: Consistency, Availability, and Partition tolerance. MySQL prioritizes **Consistency and Partition tolerance (CP)**, meaning it will refuse to return stale data even under network failure. MongoDB prioritizes **Availability and Partition tolerance (AP)** by default, meaning it may return outdated data during a partition. For healthcare, returning an outdated medication record is far more dangerous than briefly being unavailable.

Additionally, patient data has **well-defined, structured relationships** — patients have appointments, appointments have doctors, doctors belong to departments. This relational structure maps naturally to normalized SQL tables with foreign key constraints, which enforces referential integrity automatically.

### Would this change for fraud detection?

**Yes, partially.** A fraud detection module requires analyzing large volumes of rapidly changing transactional patterns in real time — a workload where MongoDB's flexible schema, horizontal scaling, and fast document reads offer genuine advantages. A practical architecture would use **both**: MySQL for the core patient records where ACID compliance is mandatory, and MongoDB (or a time-series database) for the high-volume event logs that the fraud detection model consumes. This hybrid approach is common in production healthcare systems and avoids forcing one database to serve two fundamentally different workloads.


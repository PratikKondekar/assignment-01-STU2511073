# Part 1 — Relational Databases

## Anomaly Analysis

This section identifies three data anomalies found in `orders_flat.csv` — a denormalized flat file that stores order, customer, product, and sales representative data all in a single table.

---

### 1. Insert Anomaly

**Definition:**
An insert anomaly occurs when a new record cannot be added for one entity without also creating an unrelated entity.

**Example from `orders_flat.csv`:**

A new Sales Representative **cannot be added** to the system without simultaneously creating a dummy/fake order row.

**Why:**
Columns `sales_rep_id`, `sales_rep_name`, `sales_rep_email`, and `office_address` only exist inside order rows. There is no standalone Sales Rep table.

**Columns affected:**

| Column | Description |
|---|---|
| `sales_rep_id` | Sales rep identifier |
| `sales_rep_name` | Sales rep full name |
| `sales_rep_email` | Sales rep email |
| `office_address` | Office location |

**Scenario:**
If the company hires a new sales rep SR04, there is no way to record SR04's details until SR04 is assigned to an actual order. Their data simply cannot exist in this schema independently.

> The same anomaly applies to **products** — a new product (e.g., P009) cannot be recorded until at least one customer orders it.

---

### 2. Update Anomaly

**Definition:**
An update anomaly occurs when changing one fact requires updating multiple rows, and failing to update all of them causes inconsistency.

**Example from `orders_flat.csv`:**

Sales Representative **SR01 (Deepak Joshi)** has two different `office_address` values stored across different order rows:

| `order_id` | `sales_rep_id` | `office_address` |
|---|---|---|
| ORD1114 | SR01 | `Mumbai HQ, Nariman Point, Mumbai - 400021` |
| ORD1091 | SR01 | `Mumbai HQ, Nariman Point, Mumbai - 400021` |
| ORD1180 | SR01 | `Mumbai HQ, Nariman Pt, Mumbai - 400021`  |
| ORD1173 | SR01 | `Mumbai HQ, Nariman Pt, Mumbai - 400021`  |
| ORD1170 | SR01 | `Mumbai HQ, Nariman Pt, Mumbai - 400021`  |

**Column affected:** `office_address`

**Rows affected:** ORD1180, ORD1173, ORD1170, ORD1171, ORD1172, ORD1174, ORD1175, ORD1176, ORD1177, ORD1178, ORD1179, ORD1181, ORD1182, ORD1183, ORD1184

**Root cause:**
Because SR01's office address is repeated in every order row, a partial update (only some rows were changed) left the data inconsistent — the same office now appears to have two different addresses (`Nariman Point` vs `Nariman Pt`).

---

### 3. Delete Anomaly

**Definition:**
A delete anomaly occurs when deleting one record unintentionally destroys information about a completely different entity.

**Example from `orders_flat.csv`:**

Product **P008 (Webcam)** exists in exactly **one row** in the entire dataset:

| `order_id` | `product_id` | `product_name` | `category` | `unit_price` |
|---|---|---|---|---|
| ORD1185 | P008 | Webcam | Electronics | 2100 |

**Row affected:** `ORD1185`

**Columns at risk:** `product_id`, `product_name`, `category`, `unit_price`

**Scenario:**
If order `ORD1185` is deleted (e.g., the customer cancels it or the record is archived), **all knowledge of the Webcam product is permanently lost** — its name, category, and price disappear with it. There is no separate Products table to preserve this information.

Normalization Justification:

A manager might argue that keeping all data in one flat table like `orders_flat.csv` is simpler — fewer tables, no joins, easier to query at a glance. While this sounds appealing for very small datasets, it quickly breaks down in practice, as the anomalies we identified in this very dataset demonstrate.
Consider what actually happened in `orders_flat.csv`: Sales representative SR01 (Deepak Joshi) ended up with two different office addresses stored across rows — `Nariman Point` in some rows and `Nariman Pt` in others. This is not a hypothetical risk; it is a real inconsistency that exists in the data right now. In a normalized schema, SR01's address is stored exactly once in the `sales_reps` table. Updating it requires changing a single row, and inconsistency becomes impossible by design.
The delete anomaly makes the one-table argument even weaker. Product P008 (Webcam, ₹2,100) exists in only one order — ORD1185. If that order is cancelled and deleted, the company permanently loses all knowledge of that product. In the normalized schema, the `products` table preserves P008 independently of any order. No business would accept losing product catalog data simply because one order was removed.
The insert anomaly is equally damaging. Suppose the company hires a new sales representative before they are assigned any orders. In the flat file, there is simply no way to record that person — their data can only exist attached to an order row. This forces either fake data entry or delayed onboarding records, both of which undermine data integrity.
Normalization is not over-engineering — it is the minimum structure needed to prevent data corruption. The flat file approach trades short-term simplicity for long-term unreliability. Once the dataset grows beyond a few hundred rows, the cost of fixing inconsistencies far outweighs the minor inconvenience of writing JOIN queries. The three anomalies found in this dataset prove that the one-table approach had already failed before the data even reached 200 rows.

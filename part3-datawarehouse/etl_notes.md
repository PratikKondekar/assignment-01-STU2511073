# Part 3 — Data Warehouses

## ETL Decisions

This section documents three specific transformation decisions made while cleaning `retail_transactions.csv` before loading data into the `retail_dw` star schema.

---

### Decision 1 — Standardizing Inconsistent Date Formats

**Problem:**
The `date` column in `retail_transactions.csv` contained three different date formats mixed across rows:
- `29/08/2023` (DD/MM/YYYY)
- `20-02-2023` (DD-MM-YYYY)
- `2023-02-05` (YYYY-MM-DD)

This made it impossible to sort, filter, or perform date arithmetic directly on the raw data. MySQL would also reject non-standard formats when inserting into a `DATE` column.

**Resolution:**
All dates were converted to the ISO standard format `YYYY-MM-DD` before loading. For example, `29/08/2023` became `2023-08-29` and `20-02-2023` became `2023-02-20`. The `dim_date` dimension table was then populated with derived attributes (month, quarter, year, day_of_week, is_weekend) from these cleaned dates, enabling rich time-based analysis.

---

### Decision 2 — Fixing Inconsistent Category Casing and Naming

**Problem:**
The `category` column had two types of inconsistencies:
- **Casing:** `electronics` and `Electronics` were treated as different values
- **Naming:** `Grocery` and `Groceries` referred to the same category but were spelled differently

This meant queries grouping by category would return duplicate rows for the same category, producing incorrect totals.

**Resolution:**
All category values were standardized to Title Case (`Electronics`, `Clothing`, `Groceries`). The variant `Grocery` was merged into `Groceries` as the canonical name. This clean value was stored in `dim_product.category`, ensuring consistent grouping in all analytical queries.

---

### Decision 3 — Filling NULL Store City Values

**Problem:**
Several rows in `retail_transactions.csv` had a blank/NULL value in the `store_city` column, even though the `store_name` column was populated. For example, rows with `store_name = 'Delhi South'` sometimes had an empty `store_city`. This would cause incomplete results in any query filtering or grouping by city.

**Resolution:**
Since each store name maps to exactly one city (e.g., `Delhi South` → `Delhi`, `Mumbai Central` → `Mumbai`), the missing city values were filled by looking up the city from the store name. The correct city was then stored in `dim_store.store_city`, ensuring no NULL values exist in the dimension table and all location-based queries return complete results.


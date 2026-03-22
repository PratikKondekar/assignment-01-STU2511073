Part 1 — Relational Databases
Anomaly Analysis
This section identifies three data anomalies found in orders_flat.csv — a denormalized flat file that stores order, customer, product, and sales representative data all in a single table.

1. Insert Anomaly
Definition: An insert anomaly occurs when a new record cannot be added for one entity without also creating an unrelated entity.
Example from orders_flat.csv:
A new Sales Representative cannot be added to the system without simultaneously creating a dummy/fake order row.

Why: Columns sales_rep_id, sales_rep_name, sales_rep_email, and office_address only exist inside order rows. There is no standalone Sales Rep table.
Columns affected: sales_rep_id, sales_rep_name, sales_rep_email, office_address
Scenario: If the company hires a new sales rep SR04, there is no way to record SR04's details until SR04 is assigned to an actual order. Their data simply cannot exist in this schema independently.

The same anomaly applies to products — a new product (e.g., P009) cannot be recorded until at least one customer orders it.

2. Update Anomaly
Definition: An update anomaly occurs when changing one fact requires updating multiple rows, and failing to update all of them causes inconsistency.
Example from orders_flat.csv:
Sales Representative SR01 (Deepak Joshi) has two different office_address values stored across different order rows:
order_idsales_rep_idoffice_addressORD1114SR01Mumbai HQ, Nariman Point, Mumbai - 400021ORD1091SR01Mumbai HQ, Nariman Point, Mumbai - 400021ORD1180SR01Mumbai HQ, Nariman Pt, Mumbai - 400021ORD1173SR01Mumbai HQ, Nariman Pt, Mumbai - 400021ORD1170SR01Mumbai HQ, Nariman Pt, Mumbai - 400021

Column affected: office_address
Rows affected: ORD1180, ORD1173, ORD1170, ORD1171, ORD1172, ORD1174, ORD1175, ORD1176, ORD1177, ORD1178, ORD1179, ORD1181, ORD1182, ORD1183, ORD1184 (use abbreviated Nariman Pt)  vs. all other SR01 rows (use full Nariman Point)
Root cause: Because SR01's office address is repeated in every order row they are associated with, a partial update (only some rows were changed) left the data in an inconsistent state — the same physical office now appears to have two different addresses.


3. Delete Anomaly
Definition: A delete anomaly occurs when deleting one record unintentionally destroys information about a completely different entity.
Example from orders_flat.csv:
Product P008 (Webcam) exists in exactly one row in the entire dataset:
order_idproduct_idproduct_namecategoryunit_priceORD1185P008WebcamElectronics2100

Row affected: ORD1185
Columns at risk: product_id, product_name, category, unit_price
Scenario: If order ORD1185 is deleted (e.g., the customer cancels, or the record is archived), all knowledge of the Webcam product is permanently lost — its ID, name, category, and price disappear with it. There is no separate Products table to preserve this information.

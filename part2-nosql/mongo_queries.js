// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  { "category": "Electronics", "name": "Sony WH-1000XM5", "brand": "Sony", "price": 29999, "in_stock": true },
  { "category": "Clothing", "name": "Oxford Shirt", "brand": "Arrow", "price": 1499, "in_stock": true },
  { "category": "Groceries", "name": "Organic Rolled Oats", "brand": "True Elements", "price": 349, "in_stock": true }
])

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({ "category": "Electronics", "price": { "$gt": 20000 } })

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({ "category": "Groceries", "expiry.expiry_date": { "$lt": new Date("2025-01-01") } })

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne({ "name": "Sony WH-1000XM5" }, { "$set": { "discount_percent": 10 } })


// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ "category": 1 })

# Part 4 — Vector Databases

## Vector DB Use Case

### Scenario
A law firm wants to build a system where lawyers can search 500-page contracts by asking questions in plain English, such as "What are the termination clauses?" The question is whether a traditional keyword-based database search would suffice, and what role a vector database would play.

---

A traditional keyword-based search would **not suffice** for this use case, and the limitation is fundamental rather than technical. Keyword search works by matching exact words or phrases. If a lawyer searches for "termination clauses", a keyword system will only return paragraphs that contain the literal words "termination" or "clauses". However, contracts are written in complex legal language where the same concept can be expressed in many different ways — "conditions for contract dissolution", "grounds for early exit", "circumstances permitting cancellation", or "events of default leading to agreement termination" all describe termination conditions but share no common keywords. A keyword search would miss every one of these variations, forcing lawyers to manually guess every possible phrasing — defeating the purpose of the search tool entirely.

A vector database solves this by working at the level of **semantic meaning** rather than literal words. When a sentence like "What are the termination clauses?" is passed through an embedding model such as all-MiniLM-L6-v2, it is converted into a high-dimensional numerical vector that captures its meaning. Every paragraph of the contract is similarly converted into vectors and stored in the vector database. When a lawyer submits a query, the system finds the contract paragraphs whose vectors are closest to the query vector — meaning they are semantically similar — regardless of whether they share any words. This is precisely what cosine similarity measures, as demonstrated in this notebook.

The practical result is a system where lawyers can ask natural questions and receive the most relevant contract sections instantly, even across 500 pages of dense legal text.

**Would this answer change with a fraud detection module?**
No — a vector database would remain valuable. Fraud detection often relies on finding transactions or documents that are semantically similar to known fraud patterns, even when the exact wording differs. The same embedding-based similarity approach applies directly.


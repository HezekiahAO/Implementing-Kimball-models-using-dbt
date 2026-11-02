# Star Schema Pipeline

Data engineering is the job of moving data from messy sources into a clean, trusted shape that analysts can use. This project does that in miniature.

## How it works

1. **Load**: Raw files are read with pandas and loaded into Postgres.
2. **Staging**: dbt staging models clean each raw table.
3. **Dimensions**: Dimension tables describe accounts, customers, orders and dates.
4. **Fact table**: One row per transaction. LEFT JOINs attach the dimension keys so no transaction is lost.
5. **Outputs** (both built from the fact table):
   - **OBT (one big table)**: everything joined back into one wide table. Same rows, more columns.
   - **Aggregate**: `GROUP BY` totals and averages per account, day and currency. Fewer rows, summarized.
6. **Tests**: dbt tests check that row counts and amounts match at every layer.

## Joins vs. aggregations

- **Joins** reconnect tables that were split apart. The fact table stores only keys; joins look up the details behind them.
- **Aggregations** (`SUM`, `COUNT`, `AVG`, `GROUP BY`) shrink many rows into a summary, for when you want totals rather than individual events.

## In one sentence

I split messy raw data into descriptive dimensions and a transaction-level fact table using left joins so no rows are lost, then used `GROUP BY` to summarize it, and dbt tests proved the numbers still match.

I will give a detailed breakdown of the project shortly.
# Banking-Dashboard-Using-AI-Tools

## Problem Statement

This dashboard was created to help a bank analyze its customer transactions, account activity, and demographics effectively. The goal is to provide insights into customer behavior, account balances, transaction patterns, and inactive accounts, enabling the bank to make data-driven decisions.

The dataset (10,000+ records) was created using MYSQL and AI tools (Perplexity), with built-in inconsistencies for practicing **data cleaning and transformation in Power Query Editor**. The dashboard highlights **10 KPIs across 2 pages** (5 KPIs each), focusing on transactions, account balances, and customer segmentation.

Through this dashboard, banks can:

* Identify inactive accounts and customer retention issues.
* Monitor balance distribution across account types.
* Track transactions over time by type and month.
* Understand customer demographics by age and gender.
* Pinpoint top customers by transaction amount.

---

### Steps followed

* **Step 1**: Created a synthetic banking dataset (\~10,000 records) in **MYSQL** using AI-generated queries and schema design.
* **Step 2**: Introduced intentional inconsistencies in date columns to simulate real-world data cleaning.
* **Step 3**: Wrote SQL queries to fix date formats and remove nulls/invalid values.
* **Step 4**: Combined data from **3 related tables** (Customers, Accounts, Transactions) using SQL joins.
* **Step 5**: Loaded the cleaned dataset into **Power BI Desktop**.
* **Step 6**: Used **Power Query Editor** to perform additional data cleaning (date corrections, null removal, formatting).
* **Step 7**: Designed a **2-page Power BI Dashboard** with 10 KPIs (5 per page).
* **Step 8**: Implemented **DAX measures** for KPI calculations (e.g., Total Transactions, Average Balance, Customer Count).
* **Step 9**: Added visualizations (bar charts, line charts, tree maps, cards) to represent KPIs effectively.
* **Step 10**: Formatted the dashboard with slicers (by month, account type, gender) for interactive filtering.

---

## KPIs & Visualizations

### Page 1 (Transaction Insights)

1. **Number of Transactions by Type** → Clustered Bar Chart
2. **Transactions by Month** → Line Chart
3. **Top 2 Transactions by Customer Name** → Table/Bar Chart
4. **Total Balance by Account Type** → Donut Chart
5. **Inactive Accounts by Year & Month** → Stacked Column Chart

### Page 2 (Customer Insights)

6. **Customer Count by Gender** → Clustered Column Chart
7. **Customer Distribution by Age Group** → Pie Chart
8. **Number of Transactions by Age Group** → Tree Map
9. **Average Balance per Customer** → Card Visual
10. **Total Customers** → Card Visual

---

## Sample DAX Measures

```DAX
-- Total Number of Customers
Total Customers = COUNT(Customers[CustomerID])

-- Total Transactions
Total Transactions = COUNT(Transactions[TransactionID])

-- Total Balance
Total Balance = SUM(Accounts[Balance])

-- Average Balance
Average Balance = AVERAGE(Accounts[Balance])

-- Transactions by Month
Transactions by Month = COUNTROWS(Transactions)
```

---

# Snapshots of Dashboard (Power BI Desktop)

![Page1](https://github.com/user-attachments/assets/429d129e-a92c-4acd-973d-0f8bda3eedf8)

![Page2](https://github.com/user-attachments/assets/373e5178-1051-4ee3-9868-24947a34cf21)

---

# Insights

From the Banking Dashboard, the following insights can be drawn:

### \[1] Transaction Patterns

* Highest number of transactions were observed in **Q4 months**.
* **Transfer transactions** contribute the largest share compared to deposits/withdrawals.

### \[2] Account Insights

* **Savings and Current accounts** hold equal balance share.

### \[3] Customer Demographics

* Majority of customers belong to the **36–50 age group**.
* Customer base is almost evenly split by gender, with slightly higher male representation.

### \[4] High-Value Customers

* Top 2 customers contribute significantly higher transaction values compared to average customers.

---

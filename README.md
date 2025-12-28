# Ecommerce Sales & Profit Dashboard (Sigma + Snowflake)

## Overview
Built an interactive Ecommerce Sales & Profit Dashboard in Sigma Computing.
Used Snowflake for the sample ecommerce datasets (customers, orders, products), and added a separate 50K Sales Records CSV as an additional Sigma data source to extend analysis.

## Dashboard Link
- Sigma Published Dashboard: <PASTE_YOUR_SIGMA_PUBLISHED_LINK_HERE>

## What’s Included
- `data/` → CSV files used in Sigma (sample ecommerce + 50K sales records)
- `sql/` → Snowflake SQL used to create tables/views for the sample ecommerce dataset and the 50K dataset setup
- `images/` → Dashboard overview screenshot

## Key KPIs & Visuals
- Orders (Count Distinct of Order Id)
- Total Revenue
- Total Profit
- Margin %
- Revenue Trend over time
- Revenue by Category

## Filters / Interactivity
- Category (multi-select)
- Channel (multi-select)
- Order Date (date range)

## How It Was Built (Process)
1. Loaded sample ecommerce CSVs into Snowflake and created a joined view for analysis.
2. Connected Sigma to Snowflake and used the view as the primary dataset.
3. Added an extra Sigma data source using the 50,000 Sales Records CSV to extend analysis.
4. Built KPI tiles and charts in Sigma.
5. Added interactive controls (Category, Channel, Order Date) and configured control targets so all elements respond correctly.
6. Published the Sigma workbook and generated a share link.

## Screenshot
![Dashboard Overview](images/dashboard_overview.png)

## Tech Stack
- Sigma Computing
- Snowflake (Snowsight)
- CSV data sources

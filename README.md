# Royal Enfield Uptime Centre Dashboard

A mock service analytics dashboard for Royal Enfield-style Uptime Centre operations. The project uses PostgreSQL views for the analysis layer and Streamlit for the dashboard interface.
view app - https://royal-enfield-uptime-analytics-yswkjwwtjscek9aftmnqjs.streamlit.app

## Features

- KPI cards for open, pending, resolved, and SLA-breached job cards
- Region filter
- Open job cards by bike model
- Open card aging buckets
- Issue type breakdown
- Connected vs traditional bike backlog
- Service centre backlog table

## Tech Stack

- PostgreSQL
- SQL views
- Python
- Streamlit
- Pandas
- Matplotlib

## Project Files

- `Re_query.sql` creates the mock job card table, inserts sample data, and creates dashboard views.
- `Re_streamlit.py` reads from the SQL views and displays the dashboard.
- `requirements.txt` lists Python dependencies.

## How To Run

Install Python dependencies:

```bash
python3 -m pip install -r requirements.txt
```

Create the database table and views:

```bash
psql -d postgres -f Re_query.sql
```

Run the Streamlit dashboard:

```bash
python3 -m streamlit run Re_streamlit.py
```

## Note

This project uses synthetic mock data only. It is intended as a service analytics portfolio project and does not use any real Royal Enfield customer or vehicle data.

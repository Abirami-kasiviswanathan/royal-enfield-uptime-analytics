import streamlit as st
import pandas as pd
import psycopg2
import matplotlib.pyplot as plt
import numpy as np

# -----------------------------
# Page setup
# -----------------------------
st.set_page_config(page_title="RE Uptime Centre", page_icon="RE", layout="wide")

# -----------------------------
# Royal Enfield colors
# -----------------------------
RE_RED = "#C8102E"
RE_DARK = "#1A1A1A"
RE_GOLD = "#B8860B"
RE_WHITE = "#FFFFFF"

# -----------------------------
# Page styling
# -----------------------------
st.markdown(f"""
<style>
  html, body, [class*="css"] {{
    background-color: {RE_DARK};
    color: #F5F5F0;
  }}

  .re-header {{
    background: linear-gradient(135deg, {RE_DARK} 0%, #2a0a0e 60%, {RE_RED} 100%);
    border-bottom: 3px solid {RE_RED};
    padding: 24px 32px 18px;
    margin-bottom: 28px;
    border-radius: 0 0 8px 8px;
  }}

  .re-header h1 {{
    color: {RE_WHITE};
    text-transform: uppercase;
    margin: 0;
  }}

  .re-header p {{
    color: #aaa;
    font-size: 0.85rem;
    letter-spacing: 1px;
    text-transform: uppercase;
  }}

  .kpi-card {{
    background: #242424;
    border: 1px solid #333;
    border-top: 3px solid {RE_RED};
    border-radius: 6px;
    padding: 18px;
    text-align: center;
  }}

  .kpi-value {{
    color: {RE_WHITE};
    font-size: 2rem;
    font-weight: 700;
  }}

  .kpi-label {{
    color: #888;
    font-size: 0.72rem;
    text-transform: uppercase;
    margin-top: 6px;
  }}

  .section-title {{
    color: {RE_WHITE};
    letter-spacing: 1px;
    text-transform: uppercase;
    border-left: 4px solid {RE_RED};
    padding-left: 12px;
    margin: 28px 0 16px;
  }}

  .alert-box {{
    background: #2a0a0e;
    border: 1px solid {RE_RED};
    border-radius: 6px;
    color: #f5a0a0;
    padding: 14px 18px;
    margin: 16px 0;
  }}

  [data-testid="stSidebar"] {{
    background-color: #141414 !important;
  }}
</style>
""", unsafe_allow_html=True)

# -----------------------------
# Database connection
# @st.cache_resource means the connection is created once and reused
# across all reruns — so every filter click does not open a new connection
# -----------------------------
@st.cache_resource
def get_connection():
    return psycopg2.connect(
        host=st.secrets["postgres"]["host"],
        dbname=st.secrets["postgres"]["database"],
        user=st.secrets["postgres"]["user"],
        password=st.secrets["postgres"]["password"],
        port=st.secrets["postgres"]["port"],
        sslmode="require"
    )

# -----------------------------
# read_view: one reusable function to query any view
# it runs: SELECT * FROM <view_name> WHERE region = <selected_region>
# returns a pandas DataFrame that each chart uses directly
# -----------------------------
def read_view(view_name, selected_region):
    """Read one dashboard view for the selected region."""
    conn = get_connection()

    return pd.read_sql_query(
        f"SELECT * FROM {view_name} WHERE region = %s;",
        conn,
        params=[selected_region]
    )

# -----------------------------
# base_fig: sets up a dark-themed matplotlib chart
# called before every chart so we don't repeat the same 5 lines each time
# returns fig and ax — ax is where the actual chart is drawn
# -----------------------------
def base_fig(size=(6, 3.5)):
    fig, ax = plt.subplots(figsize=size)
    fig.patch.set_facecolor("#1e1e1e")
    ax.set_facecolor("#1e1e1e")
    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.tick_params(colors="#aaa", labelsize=9)
    return fig, ax

# -----------------------------
# Header
# -----------------------------
st.markdown("""
<div class="re-header">
  <h1>RE Uptime Centre - Service Dashboard</h1>
  <p>Job Card Analytics · Connected Vehicle Monitoring · Regional Backlog Tracker</p>
</div>
""", unsafe_allow_html=True)

# -----------------------------
# Sidebar filter
# user picks a region — this value is passed to every read_view() call
# so all charts update together when region changes
# -----------------------------
with st.sidebar:
    st.markdown("### FILTER")
    selected_region = st.selectbox(
        "Region",
        ["All Regions", "North", "South", "East", "West"]
    )

# -----------------------------
# KPI FLASH CARDS
# source: vw_kpi_summary
# shows 6 numbers at the top: open, pending, resolved, avg days, % resolved, SLA breached
# .iloc[0] picks the first (and only) row from the view
# -----------------------------
kpi = read_view("vw_kpi_summary", selected_region).iloc[0]

kpi_cards = [
    ("Open Cards",    int(kpi["total_open"])),
    ("Pending",       int(kpi["total_pending"])),
    ("Resolved",      int(kpi["total_closed"])),
    ("Avg Days Open", float(kpi["avg_days_open"] or 0)),
    ("% Resolved",    f'{float(kpi["percentage_resolved"] or 0)}%'),
    ("SLA > 7 Days",  int(kpi["sla_breached"])),
]

for col, (label, value) in zip(st.columns(6), kpi_cards):
    with col:
        st.markdown(
            f'<div class="kpi-card"><div class="kpi-value">{value}</div><div class="kpi-label">{label}</div></div>',
            unsafe_allow_html=True
        )

# -----------------------------
# SLA ALERT BANNER
# only appears when SLA breached cards exceed 3
# threshold of 3 avoids false alarms for one-off delays
# -----------------------------
if int(kpi["sla_breached"]) > 3:
    st.markdown(
        f'<div class="alert-box"><strong>{int(kpi["sla_breached"])} open job cards</strong> have crossed the 7-day SLA threshold.</div>',
        unsafe_allow_html=True
    )

st.markdown("---")

# -----------------------------
# SECTION 1: BACKLOG ANALYSIS
# -----------------------------
st.markdown('<div class="section-title">Backlog Analysis</div>', unsafe_allow_html=True)
c1, c2 = st.columns(2)

# CHART 1: HORIZONTAL BAR — OPEN CARDS BY BIKE MODEL
# source: vw_open_by_model
# shows which bike model has the most open job cards
# horizontal bar is used so model names are readable without rotation
with c1:
    df = read_view("vw_open_by_model", selected_region)

    fig, ax = base_fig()
    bars = ax.barh(df["bike_model"], df["open_cards"], color=RE_RED, height=0.6)

    # add the count number at the end of each bar
    for bar, value in zip(bars, df["open_cards"]):
        ax.text(bar.get_width() + 0.1, bar.get_y() + bar.get_height() / 2,
                int(value), va="center", color="#ccc", fontsize=9)

    ax.set_xlabel("Open Cards", color="#888")
    ax.set_title("Open Job Cards by Bike Model", color=RE_WHITE, loc="left")
    ax.xaxis.grid(True, color="#333", linewidth=0.5)
    st.pyplot(fig)
    plt.close(fig)

# CHART 2: COLOR-CODED BAR — AGING BUCKETS
# source: vw_aging_buckets
# shows how long open cards have been sitting: 0-5, 6-10, 11-15, 15+ days
# color goes green → gold → orange → red to visually signal urgency
# sort_values("sort_key") ensures bars appear in correct time order
with c2:
    df = read_view("vw_aging_buckets", selected_region).sort_values("sort_key")

    fig, ax = base_fig()
    colors = ["#2ecc71", RE_GOLD, "#e67e22", RE_RED][:len(df)]
    bars = ax.bar(df["aging_bucket"], df["card_count"], color=colors, width=0.5)

    # add count number above each bar
    for bar, value in zip(bars, df["card_count"]):
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.1,
                int(value), ha="center", color="#ccc", fontsize=10, fontweight="bold")

    ax.set_ylabel("Cards", color="#888")
    ax.set_title("Open Card Aging Buckets", color=RE_WHITE, loc="left")
    ax.yaxis.grid(True, color="#333", linewidth=0.5)
    st.pyplot(fig)
    plt.close(fig)

# -----------------------------
# SECTION 2: ISSUE & FLEET INTELLIGENCE
# -----------------------------
st.markdown('<div class="section-title">Issue & Fleet Intelligence</div>', unsafe_allow_html=True)
c3, c4 = st.columns(2)

# CHART 3: GROUPED BAR — ISSUE TYPE BREAKDOWN
# source: vw_issue_breakdown
# shows open, pending, closed counts side by side for each issue type
# np.arange creates evenly spaced x positions for each issue group
# width=0.28 spaces the 3 bars so they sit next to each other without overlap
with c3:
    df = read_view("vw_issue_breakdown", selected_region)

    fig, ax = base_fig()
    x = np.arange(len(df))
    width = 0.28

    ax.bar(x - width, df["open_cards"],    width=width, label="Open",    color=RE_RED)
    ax.bar(x,         df["pending_cards"], width=width, label="Pending", color=RE_GOLD)
    ax.bar(x + width, df["closed_cards"],  width=width, label="Closed",  color="#2ecc71")

    ax.set_xticks(x)
    ax.set_xticklabels(df["issue_type"], rotation=15, ha="right", color="#aaa", fontsize=8)
    ax.set_title("Issue Type Breakdown", color=RE_WHITE, loc="left")
    ax.yaxis.grid(True, color="#333", linewidth=0.5)
    ax.legend(facecolor="#2a2a2a", edgecolor="#444", labelcolor="#ccc", fontsize=8)
    st.pyplot(fig)
    plt.close(fig)

# CHART 4: PIE CHART — CONNECTED vs TRADITIONAL FLEET
# source: vw_connected_features_deep_dive
# shows what proportion of open backlog comes from IoT-connected bikes vs traditional bikes
# connected bikes (Himalayan 450, Meteor, Shotgun) have extra software/firmware issues
# pie makes the proportion instantly visible without reading numbers
with c4:
    df = read_view("vw_connected_features_deep_dive", selected_region)

    fig, ax = base_fig()
    ax.pie(
        df["open_backlog"],
        labels=df["bike_type"],
        autopct="%1.0f%%",
        colors=[RE_RED, "#3498db"],
        startangle=90,
        wedgeprops=dict(edgecolor="#1e1e1e", linewidth=2)
    )

    ax.set_title("Open Backlog: Connected vs Traditional", color=RE_WHITE)
    st.pyplot(fig)
    plt.close(fig)

# -----------------------------
# SERVICE CENTRE BACKLOG TABLE
# source: vw_service_centre_backlog
# shows only service centres with open cards ABOVE their regional average
# not all centres — only the ones that need attention
# the view already does the filtering in SQL using a CTE + JOIN to regional average
# -----------------------------
st.markdown('<div class="section-title">Service Centre Backlog</div>', unsafe_allow_html=True)

backlog_df = read_view("vw_service_centre_backlog", selected_region)
st.dataframe(
    backlog_df[["service_centre", "open_cards"]],
    use_container_width=True,
    hide_index=True
)
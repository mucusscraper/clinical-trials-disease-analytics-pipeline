"""
This module provides utility functions for report generation.
"""
import os
import argparse
import re
from pathlib import Path
from datetime import datetime
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import country_converter as coco
from sqlalchemy import create_engine
from dotenv import load_dotenv
from jinja2 import Environment, FileSystemLoader
from plotly.subplots import make_subplots


def connect():
    """ Func to connect to database"""
    load_dotenv()
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    db_name = os.getenv("DB_NAME")
    connstr = f"postgresql+psycopg2://{user}:{password}@postgres:5432/{db_name}"
    conn= create_engine(connstr)
    return conn

def query_exec(conn, conditions):
    """ Func to execute query in connected database"""
    queries = {
        "countries": "SELECT * FROM gold.country_participation WHERE condition=ANY(%s)",
        "eligibility": "SELECT * FROM gold.eligibility WHERE condition=ANY(%s)",
        "enrollment": "SELECT * FROM gold.enrollment_phase_startdate WHERE condition=ANY(%s)",
        "many": "SELECT * FROM gold.many_studies WHERE condition=ANY(%s)",
        "results": "SELECT * FROM gold.studies_by_has_results_and_overall WHERE condition=ANY(%s)",
        "collab": "SELECT * FROM gold.studies_collaborators_presence WHERE condition=ANY(%s)",
        "design": "SELECT * FROM gold.studies_design_details WHERE condition=ANY(%s)",
        "intervention": "SELECT * FROM gold.study_by_intervention_type WHERE condition=ANY(%s)",
        "over_time": ("SELECT condition, start_year, study_count "
        "FROM gold.studies_by_phase_over_time "
        "WHERE condition=ANY(%s)"),
        "many_studies": "SELECT * FROM gold.many_studies WHERE condition=ANY(%s)",
    }

    data = {}
    for key, query in queries.items():
        data[key] = pd.read_sql(query, conn, params=(conditions,))
    return data

def normalize_country(name):
    """ Func to normalize country name using coco"""
    cc = coco.CountryConverter()
    result = cc.convert(names=name,to="name_short")
    if result != "not found":
        return result
    return name

def clean_country(df):
    """ Func to apply the normalized country names in a new df"""
    mapping = {}
    for country in df["country"]:
        normalized = normalize_country(country)
        if country not in mapping:
            mapping[country] = normalized
    df = df.copy()
    df["country_clean"] = df["country"].replace(mapping)
    return df

def apply_layout(fig, title):
    """ Func to apply layout"""
    fig.update_layout(
        title={
            "text": f"<b>{title}</b>",
            "x": 0.5,
            "xanchor": "center",
            "font": {"size": 22}
        },
        font={
            "size": 14 
        },
        legend={
            "title": {"text": "<b>Legend</b>"},
            "font": {"size": 13}
        },
        margin= {"l":40, "r":40, "t":80, "b":40}
    )

    fig.update_xaxes(title_font={"size": 16})
    fig.update_yaxes(title_font={"size": 16})

    return fig



def build_filename(conditions):
    """ Func to build filename"""
    def clean(text):
        text = text.strip().replace(" ", "_")
        text = re.sub(r"[^\w_]", "", text)
        return text

    cleaned_conditions = [clean(c) for c in conditions]

    conditions_part = "_".join(cleaned_conditions)

    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M")

    return f"{conditions_part}_{timestamp}.html"


def plot_world_map(df):
    """ Func to plot world map"""
    df = df[df["country"] != "No Locations"]
    df = clean_country(df)

    conditions = df["condition"].unique()

    fig = make_subplots(
        rows=1,
        cols=len(conditions),
        subplot_titles=conditions,
        specs=[[{"type": "choropleth"}] * len(conditions)]
    )

    for i, cond in enumerate(conditions):
        df_cond = df[df["condition"] == cond]

        fig.add_trace(
            go.Choropleth(
                locations=df_cond["country_clean"],
                locationmode="country names",
                z=df_cond["total_studies"],
                colorscale="RdBu",
                colorbar_title="Studies" if i == 0 else None,
                showscale=(i == 0)
            ),
            row=1, col=i+1
        )

    fig.update_layout(
        title="<b>Global Distribution of Clinical Trials</b>",
        title_x=0.5,
        margin={"t":80},
        font={"size":14}
    )

    return fig.to_html(full_html=False)

def plot_studies_over_time(df):
    """ Func to plot studies over time"""
    df_grouped = (
        df.groupby(["condition", "start_year"])["study_count"]
        .sum()
        .reset_index()
    )

    fig = px.line(
        df_grouped,
        x="start_year",
        y="study_count",
        color="condition",
        markers=True,
    )

    fig.update_layout(
        xaxis_title="Year",
        yaxis_title="Total Studies",
        legend_title="Condition"
    )
    fig = apply_layout(fig, "Number of Started Studies Over Years by Condition")
    fig.update_layout(
        legend_title_text="<b>Condition</b>"
    )
    return fig.to_html(full_html=False)

def plot_intervention(df):
    """ Func to plot studies intervention"""
    df_top = df.sort_values("total_studies", ascending=False).head(15)

    fig = px.bar(
        df_top,
        x="type",
        y="total_studies",
        color="study_type",
        facet_col="condition",
        barmode="group",
    )
    fig = apply_layout(fig, "Intervention Types by Condition")
    fig.update_layout(
        legend_title_text="<b>Study Type</b>"
    )
    return fig.to_html(full_html=False)


def plot_enrollment_simple(df):
    """ Func to plot the studies enrollment"""
    df_grouped = (
        df.groupby(["condition", "enrollment_class"])
        .size()
        .reset_index(name="total_studies")
    )

    fig = px.bar(
        df_grouped,
        x="enrollment_class",
        y="total_studies",
        color="condition",
        barmode="group",
        category_orders={
            "enrollment_class": [
                "Not Specified", "0", "1-10", "11-50",
                "51-500", "501-1000", ">1000"
            ]
        },
    )
    fig = apply_layout(fig, "Study Size Distribution by Condition")
    fig.update_layout(
        legend_title_text="<b>Condition</b>"
    )
    return fig.to_html(full_html=False)


def plot_results(df):
    """ Func to plot the studies results"""
    fig = px.bar(
        df,
        x="overall_status",
        y="total",
        color="has_results",
        facet_col="condition",
        barmode="stack",
    )
    fig = apply_layout(fig, "Results Availability by Status")
    fig.update_layout(
        legend_title_text="<b>Has Results</b>"
    )
    return fig.to_html(full_html=False)


def plot_collaborators(df):
    """ Func to plot the studies collaborators"""
    fig = px.pie(
        df,
        names="collaborator_class",
        values="total_studies",
    )
    fig = apply_layout(fig, "Collaborators")
    return fig.to_html(full_html=False)


def plot_design(df):
    """ Func to plot the studies designs"""
    df_top = df.sort_values("total_studies", ascending=False).head(10)

    df_top["design"] = (
        df_top["allocation"] + " | " +
        df_top["intervention_model"] + " | " +
        df_top["primary_purporse"]
    )

    fig = px.bar(
        df_top,
        x="design",
        y="total_studies",
        color="condition",
    )
    fig = apply_layout(fig, "Top Study Designs")
    return fig.to_html(full_html=False)

def plot_total_studies(df):
    """ Func to plot total studies"""
    fig = px.pie(
        df,
        names="condition",
        values="total_studies",
    )
    fig = apply_layout(fig, "Proportion of Studies by Condition")
    fig.update_layout(
        legend_title_text="<b>Condition</b>"
    )
    fig.update_layout(
        legend_title_text="<b>Condition</b>"
    )
    return fig.to_html(full_html=False)

def build_plots(data):
    """ Func to build the plots designed"""
    return {
        "country_plot": plot_world_map(data["countries"]),
        "intervention_plot": plot_intervention(data["intervention"]),
        "enrollment_plot": plot_enrollment_simple(data["enrollment"]),
        "results_plot": plot_results(data["results"]),
        "collab_plot": plot_collaborators(data["collab"]),
        "design_plot": plot_design(data["design"]),
        "time_plot":plot_studies_over_time(data["over_time"]),
        "total_plot":plot_total_studies(data["many_studies"])
    }

def render_html(plots,conditions):
    """ Func to render HTMLs"""
    base_dir = Path(__file__).resolve().parent
    template_dir = base_dir.parent / "templates"
    output_dir = base_dir.parent / "outputs"
    output_dir.mkdir(parents=True, exist_ok=True)
    env = Environment(loader=FileSystemLoader(template_dir),autoescape=True)
    template = env.get_template("report.html")
    html = template.render(**plots,
                           conditions=", ".join(conditions,),
                           generated_at=datetime.now().strftime("%Y-%m-%d %H:%M"))
    filename = build_filename(conditions)
    output_path = output_dir / filename
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Report saved to: {output_path}")

def main():
    """ Main func"""
    parser = argparse.ArgumentParser()
    parser.add_argument("--conditions", nargs="+", required=True)
    args = parser.parse_args()
    conditions = args.conditions
    conn = connect()
    data = query_exec(conn, conditions)
    plots = build_plots(data)
    render_html(plots,conditions)

if __name__ == "__main__":
    main()

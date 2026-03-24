## License
MIT License © 2026 Daniel Lacerda Oliveira

# Clinical Trials Analyzer
**End-to-end data pipeline for clinical trials analytics with interactive reporting**
![Report Preview](reports/assets/newplot.png)
![Report Preview](reports/assets/newplot2.png)

Clinical Trials Analyzer is an interactive Command-Line Interface (CLI) tool built in Go that automates the extraction, transformation, and analysis of clinical trials data.

It integrates a full ETL pipeline with a PostgreSQL database and generates interactive HTML reports using Python, Pandas, and Plotly.

## 🤔 Motivation

This project was designed to solve common challenges when working with clinical trial data:

- Clinical trial datasets are large, fragmented, and difficult to explore manually  
- There is a lack of simple tools that combine data ingestion, transformation, and visualization  
- Generating insights (e.g., intervention types, study sizes, global distribution) often requires multiple tools   

This tool provides an end-to-end pipeline:

Fetch → Store → Transform → Analyze → Visualize

All accessible through a simple CLI.

## ⛁ Architecture Overview

The project follows a modern data engineering structure:

- Go → CLI + ETL orchestration
- PostgreSQL → Bronze → Silver → Gold layers
- Python → analytics + report generation
- Plotly → interactive visualizations
- Jinja2 → HTML templating

## 🚀 Quick Start
### Requirements
Before using Clinical Trials Analyzer, it's necessary to install some dependencies:

- [GO 1.20+](https://go.dev/)
- [PostgreSQL](https://www.postgresql.org/)
- [Python 3.10+](https://www.python.org/)

### 1. Clone the repository
After installing the software above, navigate to the folder where you would like to install Clinical Trials Analyzer and run:
```bash
git clone https://github.com/mucusscraper/clinical-trials-disease-analytics-pipeline.git
cd clinical-trials-disease-analytics-pipeline
```
### 2. Installing Python dependencies and Goose for database migrations
Install Python's necessary dependencies:
```bash
pip install -r requirements.txt
```
and install Goose for the Database migrations:
```bash
go install github.com/pressly/goose/v3/cmd/goose@latest
```

### 3. Configure the Database
Create a .env file:
```bash
DATABASE_URL=postgresql://{username}:{password}@localhost:5432/clinical_trials?sslmode=disable
```
and create a Database in PostgreSQL named "clinical_trials".

### 4. Setup database schema
Execute the Database migrations:
```bash
goose -dir sql/schema postgres "postgres://{username}:{password}@localhost:5432/clinical_trials?sslmode=disable" up
```

### 5. Build the CLI
Execute to build:
```bash
go build -o trial-analyzer ./cmd/trial-analyzer
```

### 6. Execute the program
Run:
```bash
./trial-analyzer
```

## 📖 Usage
Once running, the CLI provides the following commands:
```bash
fetch   → Fetch clinical trial data for a condition
list    → List all stored conditions
report  → Generate interactive HTML report (max 2 conditions)
help    → Show available commands
quit    → Exit the program
```

### Example Workflow
#### 1. Fetch data
```bash
fetch
```
Then input:
```bash
Trachoma
Right Ventricular Dysfunction
done
``` 
#### 2. List stored conditions
```bash
list
``` 
#### 3. Generate Report
```bash
report
```
Then input:
```bash
Trachoma
Right Ventricular Dysfunction
done
```
#### 4. View Report
The tool generates interactive HTML dashboards located in:
```bash
reports/outputs/
```
Example filename:
```bash
Trachoma_Right_Ventricular_Dysfunction_2026-03-23_17-45.html
```

## 📊 Visualizations
- 🌍 Global distribution of studies (interactive world map)
- 📈 Studies over time by condition
- 🧪 Intervention types by study type
- 👥 Collaborator distribution
- 📊 Study size distribution (enrollment classes)
- 📋 Study design combinations
- ✅ Results availability vs study status
- 🧮 Total studies comparison between conditions

All graphs are interactive (hover, zoom, filter).
Reports are fully self-contained HTML files and can be easily shared or used in presentations and publications.

## 🤝 Contributing

If you'd like to contribute, feel free to fork the repo and submit pull requests with new features or improvements! 
Also, you are welcome to open issues or contact me so we can discuss about ideas and suggestions.

## 💡 Future Improvements
- Docker support for reproducible environments  
- Parallelized API requests for faster data ingestion  
- Web-based dashboard (Streamlit or FastAPI)
---

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/daniel-oliveira-30785b1ba)
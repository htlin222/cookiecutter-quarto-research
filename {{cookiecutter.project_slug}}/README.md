# {{ cookiecutter.project_name }}

{{ cookiecutter.project_short_description }}

## Project Structure

```
{{ cookiecutter.project_slug }}/
├── _quarto.yml           # Quarto configuration
├── index.qmd             # Main report (HTML output)
├── manuscript/           # Manuscript files
│   ├── manuscript.qmd    # Main manuscript (DOCX output)
│   ├── references.bib    # Bibliography file
│   ├── ama.csl          # AMA citation style
│   └── reference.docx    # Word template (optional)
├── data/
│   ├── raw/             # Original data files (CSV)
│   ├── processed/       # Cleaned data files
│   └── external/        # External data sources
├── R/                   # R scripts
│   ├── 01_data_import.R
│   ├── 02_data_cleaning.R
│   ├── 03_analysis.R
│   └── 04_visualization.R
├── output/
│   ├── figures/         # Generated figures
│   └── tables/          # Generated tables
└── docs/                # Additional documentation
```

## Getting Started

1. **Install Dependencies**
   ```r
   # Install required R packages
   install.packages(c("tidyverse", "quarto", "renv", "here", 
                      "janitor", "naniar", "broom", "rstatix", 
                      "effectsize", "patchwork", "knitr", "kableExtra"))
   ```

2. **Initialize renv (if selected)**
   ```r
   {% if cookiecutter.use_renv == 'y' %}
   renv::init()
   renv::snapshot()
   {% endif %}
   ```

3. **Place Data Files**
   - Add your CSV files to the `data/raw/` directory
   - Keep original data files unchanged

4. **Run Analysis**
   - Execute R scripts in order (01-04)
   - Or source them from the Quarto document

5. **Generate Reports**
   ```bash
   # Generate HTML report
   quarto render index.qmd
   
   # Generate DOCX manuscript
   quarto render manuscript/manuscript.qmd
   
   # Generate both
   quarto render
   ```

## Workflow

1. **Data Import** (`R/01_data_import.R`)
   - Load raw CSV files
   - Basic data validation

2. **Data Cleaning** (`R/02_data_cleaning.R`)
   - Handle missing values
   - Create derived variables
   - Data quality checks

3. **Analysis** (`R/03_analysis.R`)
   - Descriptive statistics
   - Statistical tests
   - Model fitting

4. **Visualization** (`R/04_visualization.R`)
   - Create publication-ready figures
   - Generate tables

## Output Formats

- **HTML Report** (`index.qmd` → `_site/index.html`)
  - Interactive report with code folding
  - Suitable for sharing results with collaborators
  
- **DOCX Manuscript** (`manuscript/manuscript.qmd` → `manuscript/manuscript.docx`)
  - Formatted for journal submission
  - Uses AMA citation style
  - Ready for final editing

## Citation Style

This project uses the American Medical Association (AMA) citation style. To add references:

1. Add entries to `manuscript/references.bib`
2. Cite in text using `[@key]` or `@key`
3. References will be automatically formatted

## Author

**{{ cookiecutter.author_name }}**  
Email: {{ cookiecutter.author_email }}

## License

Copyright © {{ cookiecutter.year }} {{ cookiecutter.author_name }}. All rights reserved.

---

*Project created with cookiecutter-quarto-research template*
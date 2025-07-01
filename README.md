# Cookiecutter Quarto Research Template

A cookiecutter template for creating reproducible research projects using Quarto, R, and the AMA citation style. Perfect for clinical research, medical studies, and academic papers.

## 🚀 Quick Start

### Option 1: Automated Installation (Recommended)

```bash
# Clone or download this template
git clone https://github.com/htlin222/cookiecutter-quarto-research.git
cd cookiecutter-quarto-research

# Install all dependencies automatically
make install

# Install R packages (requires R to be installed first)
make install-r-packages

# Test the installation with full rendering
make test-full

# Create your project
cookiecutter .
```

### Option 2: Manual Installation

```bash
# Install cookiecutter
pip install cookiecutter

# Create a new project
cookiecutter https://github.com/your-username/cookiecutter-quarto-research.git
# OR if using locally:
cookiecutter /path/to/cookiecutter-quarto-research/
```

## ✨ Features

- 📊 **Quarto-based reporting**: Generate both HTML reports and DOCX manuscripts
- 📈 **R for statistical analysis**: Complete R workflow with modular scripts
- 📚 **AMA citation style**: Pre-configured for medical/clinical research
- 📁 **Organized structure**: Clear separation of data, code, and outputs
- 🔄 **Reproducible**: Optional renv support for package management
- 📝 **Ready-to-use templates**: Pre-built report and manuscript templates

## 📋 Prerequisites

### Required Software

1. **Python 3.6+** (for cookiecutter)

   ```bash
   # Check Python version
   python --version
   ```

2. **R 4.0+**

   ```bash
   # Check R version
   R --version
   ```

3. **Quarto CLI**

   ```bash
   # Check Quarto installation
   quarto --version

   # Install Quarto (if needed)
   # Visit: https://quarto.org/docs/get-started/
   ```

4. **Git** (optional but recommended)

   ```bash
   git --version
   ```

### Automated Installation with Makefile

The included Makefile provides robust, cross-platform installation:

```bash
# See all available commands
make help

# Install all dependencies (pipx, cookiecutter, quarto)
make install

# Check what's installed
make check-deps

# Test the template
make test

# Install R packages (after R is installed)
make install-r-packages
```

### Manual Installation Guide

#### Install Python & Cookiecutter

**Option A: Using pipx (Recommended)**

```bash
# macOS (Homebrew)
brew install pipx
pipx install cookiecutter

# Linux/Windows (pip)
pip install --user pipx
pipx install cookiecutter
```

**Option B: Using pip**

```bash
# macOS (Homebrew)
brew install python
pip install cookiecutter

# Windows
# Download Python from https://python.org
pip install cookiecutter

# Linux (Ubuntu/Debian)
sudo apt update
sudo apt install python3 python3-pip
pip3 install cookiecutter
```

#### Install R

**macOS:**

```bash
brew install r
```

**Windows:** Download from <https://cran.r-project.org/>

**Linux:**

```bash
sudo apt update
sudo apt install r-base
```

#### Install Quarto

**macOS:**

```bash
brew install quarto
```

**Other platforms:** Visit [Quarto's installation page](https://quarto.org/docs/get-started/)

## 🎯 Usage

### Step 1: Create New Project

```bash
cookiecutter cookiecutter-quarto-research/
```

### Step 2: Answer the Prompts

```
project_name [My Research Project]: Clinical Trial Analysis
project_slug [clinical-trial-analysis]:
author_name [Your Name]: Dr. Jane Smith
author_email [your.email@example.com]: jane.smith@university.edu
project_short_description [A brief description]: Analysis of Phase II clinical trial data
version [0.1.0]:
year [2024]:
use_git [y]: y
use_renv [y]: y
data_format [csv]: csv
output_formats [html]: html
citation_style [ama]: ama
```

### Step 3: Navigate to Your Project

```bash
cd clinical-trial-analysis
```

### Step 4: Set Up R Environment

```bash
# Option A: Use Makefile (if you cloned the template)
cd /path/to/cookiecutter-quarto-research
make install-r-packages

# Option B: Manual installation
Rscript -e "install.packages(c('tidyverse', 'quarto', 'here', 'janitor', 'naniar', 'broom', 'rstatix', 'effectsize', 'patchwork', 'knitr', 'kableExtra'))"

# If using renv (recommended)
Rscript -e "renv::restore()"
```

### Step 5: Add Your Data & Run Analysis

```bash
# 1. Place your CSV files in data/raw/
cp your_data.csv data/raw/

# 2. Run analysis scripts
Rscript R/01_data_import.R
Rscript R/02_data_cleaning.R
Rscript R/03_analysis.R
Rscript R/04_visualization.R

# 3. Generate reports
quarto render                    # Generate both HTML and DOCX
quarto render index.qmd          # Generate HTML report only
quarto render manuscript/manuscript.qmd  # Generate DOCX manuscript only
```

## 📁 Generated Project Structure

```
your-project-name/
├── _quarto.yml           # Quarto configuration
├── index.qmd             # Main report (→ HTML)
├── manuscript/           # Manuscript files
│   ├── manuscript.qmd    # Main manuscript (→ DOCX)
│   ├── sections/         # Individual manuscript sections
│   │   ├── 00_abstract.qmd
│   │   ├── 01_introduction.qmd
│   │   ├── 02_methods.qmd
│   │   ├── 03_results.qmd
│   │   ├── 04_discussion.qmd
│   │   ├── 05_conclusions.qmd
│   │   └── 06_acknowledgments.qmd
│   ├── references.bib    # Bibliography
│   ├── ama.csl          # AMA citation style
│   └── reference.docx    # Word template (optional)
├── data/
│   ├── raw/             # Original CSV data
│   ├── processed/       # Cleaned data
│   └── external/        # External data
├── R/                   # Analysis scripts
│   ├── 01_data_import.R
│   ├── 02_data_cleaning.R
│   ├── 03_analysis.R
│   └── 04_visualization.R
├── output/
│   ├── figures/         # Generated plots
│   └── tables/          # Generated tables
└── docs/                # Additional documentation
```

## 📊 Output Formats

- **HTML Report** (`index.qmd` → `_site/index.html`): Interactive report with code folding for collaborators
- **DOCX Manuscript** (`manuscript/manuscript.qmd` → `manuscript.docx`): Journal-ready manuscript with AMA citations

### 📝 Manuscript Structure (IMRaD Format)

The manuscript follows the standard IMRaD (Introduction, Methods, Results, and Discussion) format with modular sections:

- **`00_abstract.qmd`**: Structured abstract with Background, Methods, Results, Conclusions
- **`01_introduction.qmd`**: Literature review, study rationale, objectives, and hypotheses
- **`02_methods.qmd`**: Study design, population, data collection, statistical analysis
- **`03_results.qmd`**: Baseline characteristics, primary/secondary outcomes, subgroup analyses
- **`04_discussion.qmd`**: Key findings, literature comparison, strengths/limitations, implications
- **`05_conclusions.qmd`**: Concise summary and clinical/scientific implications
- **`06_acknowledgments.qmd`**: Acknowledgments, author contributions, funding, conflicts

**Benefits of modular structure**:

- Better organization and version control
- Easier collaboration with co-authors
- Cleaner diffs when tracking changes
- Ability to work on individual sections independently

## 🔧 Customization

- **Quarto settings**: Modify `_quarto.yml` for project-wide configuration
- **Citation style**: Replace `manuscript/ama.csl` with other CSL files
- **Styling**: Edit `styles.css` for custom HTML appearance
- **Word template**: Add `manuscript/reference.docx` for DOCX formatting
- **R workflow**: Extend scripts in `R/` for your specific analyses

## 🐛 Troubleshooting

### Common Issues

**"Command not found: quarto"**

```bash
# Option A: Use Makefile
make install-quarto

# Option B: Manual installation
# Visit: https://quarto.org/docs/get-started/
```

**"Command not found: cookiecutter"**

```bash
# Option A: Use Makefile
make install-cookiecutter

# Option B: Manual installation
pipx install cookiecutter
# or
pip install cookiecutter
```

**R packages missing**

```bash
# Option A: Use Makefile
make install-r-packages

# Option B: Manual installation
Rscript -e "install.packages(c('tidyverse', 'quarto', 'here', 'janitor', 'naniar', 'broom', 'rstatix', 'effectsize', 'patchwork', 'knitr', 'kableExtra'))"
```

**Check all dependencies**

```bash
# Use Makefile to check what's installed
make check-deps
```

**Git not initialized**

```bash
cd your-project-name
git init
git add .
git commit -m "Initial commit"
```

## 📚 Examples

### Working with CSV Data

```r
# In R/01_data_import.R
library(tidyverse)
library(here)

# Load your CSV files
main_data <- read_csv(here("data", "raw", "study_data.csv"))
demographics <- read_csv(here("data", "raw", "demographics.csv"))

# Save processed data
saveRDS(main_data, here("data", "processed", "main_data.rds"))
```

### Creating Publication Figures

```r
# In R/04_visualization.R
library(ggplot2)

# Create a publication-ready plot
p1 <- ggplot(data, aes(x = treatment, y = outcome)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Treatment Effect on Primary Outcome",
       x = "Treatment Group",
       y = "Outcome Score")

# Save to output/figures/
ggsave(here("output", "figures", "figure1.png"), p1,
       width = 8, height = 6, dpi = 300)
```

### Working with Manuscript Sections

```bash
# Edit individual sections
vim manuscript/sections/01_introduction.qmd
vim manuscript/sections/03_results.qmd

# Compile manuscript to DOCX
quarto render manuscript/manuscript.qmd

# Compile specific section for review (optional)
quarto render manuscript/sections/02_methods.qmd --to html
```

```r
# Add tables to results section
# In manuscript/sections/03_results.qmd
baseline_table <- create_baseline_table(data)
kable(baseline_table, caption = "Table 1: Baseline Characteristics")
```

### Adding References from PubMed

The template includes real references from recent medical literature sourced via PubMed:

- **Clinical Trials**: Randomized controlled trials from anesthesiology and pulmonology
- **Biomarker Studies**: Research on diagnostic and prognostic biomarkers
- **Cohort Studies**: Large-scale epidemiological investigations
- **Methodology Papers**: Studies on causal inference and research methods

All references follow proper BibTeX format with DOI and PMID for easy verification and citation.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `cookiecutter .`
5. Submit a pull request

## 📄 License

This template is released under the MIT License.


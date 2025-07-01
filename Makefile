# Makefile for Cookiecutter Quarto Research Template
# Installs prerequisites: pipx, cookiecutter, and Quarto

.PHONY: help install install-pipx install-cookiecutter install-quarto check-deps clean test

# Default target
help:
	@echo "Cookiecutter Quarto Research Template - Installation"
	@echo ""
	@echo "Available targets:"
	@echo "  help              Show this help message"
	@echo "  install           Install all dependencies (pipx, cookiecutter, quarto)"
	@echo "  install-pipx      Install pipx package manager"
	@echo "  install-cookiecutter  Install cookiecutter via pipx"
	@echo "  install-quarto    Install Quarto CLI"
	@echo "  install-r-packages Install core R packages (fast)"
	@echo "  install-r-packages-full Install all R packages (complete)"
	@echo "  check-deps        Check if all dependencies are installed"
	@echo "  test              Test the template by creating a sample project"
	@echo "  test-full         Test template with R packages and Quarto rendering"
	@echo "  clean             Clean up test projects"
	@echo ""
	@echo "Quick start:"
	@echo "  make install      # Install everything"
	@echo "  make test-full    # Test template with full rendering"

# Install all dependencies
install: install-pipx install-cookiecutter install-quarto
	@echo "✅ All dependencies installed successfully!"
	@echo "Run 'make check-deps' to verify installation"

# Check if pipx exists, install if not
install-pipx:
	@echo "🔧 Checking for pipx..."
	@if command -v pipx >/dev/null 2>&1; then \
		echo "✅ pipx is already installed"; \
		pipx --version; \
	else \
		echo "📦 Installing pipx..."; \
		if command -v brew >/dev/null 2>&1; then \
			echo "Using Homebrew to install pipx..."; \
			brew install pipx; \
			pipx ensurepath; \
		elif command -v pip3 >/dev/null 2>&1; then \
			echo "Using pip3 to install pipx..."; \
			pip3 install --user pipx; \
			python3 -m pipx ensurepath; \
		elif command -v pip >/dev/null 2>&1; then \
			echo "Using pip to install pipx..."; \
			pip install --user pipx; \
			python -m pipx ensurepath; \
		else \
			echo "❌ Error: No pip or brew found. Please install Python first."; \
			echo "Visit: https://python.org or install via package manager"; \
			exit 1; \
		fi; \
		echo "✅ pipx installed. You may need to restart your shell or run:"; \
		echo "   export PATH=\"\$$PATH:\$$HOME/.local/bin\""; \
	fi

# Install cookiecutter via pipx
install-cookiecutter: install-pipx
	@echo "🍪 Installing cookiecutter via pipx..."
	@if pipx list | grep -q cookiecutter; then \
		echo "✅ cookiecutter is already installed via pipx"; \
		pipx list | grep cookiecutter; \
	else \
		pipx install cookiecutter; \
		echo "✅ cookiecutter installed successfully"; \
	fi

# Install Quarto CLI
install-quarto:
	@echo "📊 Checking for Quarto..."
	@if command -v quarto >/dev/null 2>&1; then \
		echo "✅ Quarto is already installed"; \
		quarto --version; \
	else \
		echo "📦 Installing Quarto CLI..."; \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			if command -v brew >/dev/null 2>&1; then \
				echo "Using Homebrew to install Quarto..."; \
				brew install quarto; \
			else \
				echo "Installing Quarto manually on macOS..."; \
				echo "Please download and install from: https://quarto.org/docs/get-started/"; \
				echo "Or install Homebrew first: /bin/bash -c \"\$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""; \
				exit 1; \
			fi; \
		elif [[ "$$OSTYPE" == "linux-gnu"* ]]; then \
			echo "Installing Quarto on Linux..."; \
			echo "Please install Quarto manually from: https://quarto.org/docs/get-started/"; \
			echo "Or use your package manager if available"; \
			exit 1; \
		elif [[ "$$OSTYPE" == "msys" ]] || [[ "$$OSTYPE" == "cygwin" ]]; then \
			echo "Installing Quarto on Windows..."; \
			echo "Please download and install from: https://quarto.org/docs/get-started/"; \
			exit 1; \
		else \
			echo "Unknown OS type: $$OSTYPE"; \
			echo "Please install Quarto manually from: https://quarto.org/docs/get-started/"; \
			exit 1; \
		fi; \
		echo "✅ Quarto installed successfully"; \
	fi

# Check all dependencies
check-deps:
	@echo "🔍 Checking dependencies..."
	@echo ""
	@echo "Python:"
	@if command -v python3 >/dev/null 2>&1; then \
		echo "  ✅ python3: $$(python3 --version)"; \
	elif command -v python >/dev/null 2>&1; then \
		echo "  ✅ python: $$(python --version)"; \
	else \
		echo "  ❌ Python not found"; \
	fi
	@echo ""
	@echo "Package Managers:"
	@if command -v pipx >/dev/null 2>&1; then \
		echo "  ✅ pipx: $$(pipx --version)"; \
	else \
		echo "  ❌ pipx not found"; \
	fi
	@if command -v brew >/dev/null 2>&1; then \
		echo "  ✅ brew: $$(brew --version | head -n1)"; \
	else \
		echo "  ℹ️  brew not found (optional)"; \
	fi
	@echo ""
	@echo "Required Tools:"
	@if command -v cookiecutter >/dev/null 2>&1; then \
		echo "  ✅ cookiecutter: $$(cookiecutter --version)"; \
	else \
		echo "  ❌ cookiecutter not found"; \
	fi
	@if command -v quarto >/dev/null 2>&1; then \
		echo "  ✅ quarto: $$(quarto --version)"; \
	else \
		echo "  ❌ quarto not found"; \
	fi
	@echo ""
	@echo "Optional Tools:"
	@if command -v R >/dev/null 2>&1; then \
		echo "  ✅ R: $$(R --version | head -n1)"; \
	else \
		echo "  ⚠️  R not found (required for analysis)"; \
	fi
	@if command -v git >/dev/null 2>&1; then \
		echo "  ✅ git: $$(git --version)"; \
	else \
		echo "  ⚠️  git not found (recommended)"; \
	fi

# Test the template
test: check-deps
	@echo "🧪 Testing cookiecutter template..."
	@echo "Creating test project in /tmp/cookiecutter-test..."
	@cd /tmp && \
	rm -rf cookiecutter-test && \
	cookiecutter --no-input $(PWD) \
		project_name="Test Research Project" \
		author_name="Test Author" \
		author_email="test@example.com" \
		project_short_description="Test project for template validation" \
		use_git=n \
		use_renv=n && \
	cd test-research-project && \
	echo "✅ Template created successfully!" && \
	echo "📁 Project structure:" && \
	find . -type f -name "*.qmd" -o -name "*.R" -o -name "*.yml" | head -10 && \
	echo "..." && \
	echo "🧹 Cleaning up test project..." && \
	cd /tmp && rm -rf test-research-project
	@echo "✅ Template test completed successfully!"

# Test template with R packages and rendering
test-full: check-deps install-r-packages
	@echo "🧪 Testing cookiecutter template with full rendering..."
	@echo "Creating test project in /tmp/cookiecutter-test..."
	@cd /tmp && \
	rm -rf cookiecutter-test test-research-project && \
	cookiecutter --no-input $(PWD) \
		project_name="Test Research Project" \
		author_name="Test Author" \
		author_email="test@example.com" \
		project_short_description="Test project for template validation" \
		use_git=n \
		use_renv=n && \
	cd test-research-project && \
	echo "✅ Template created successfully!" && \
	echo "🔧 Testing Quarto rendering..." && \
	quarto render index.qmd --to html && \
	echo "✅ HTML rendering successful!" && \
	echo "🧹 Cleaning up test project..." && \
	cd /tmp && rm -rf test-research-project
	@echo "✅ Full template test completed successfully!"

# Clean up any test projects
clean:
	@echo "🧹 Cleaning up test projects..."
	@rm -rf /tmp/cookiecutter-test /tmp/test-research-project
	@echo "✅ Cleanup completed"

# Show installation status
status: check-deps

# Install core R packages (fast installation)
install-r-packages:
	@echo "📦 Installing core R packages..."
	@if command -v R >/dev/null 2>&1; then \
		echo "Installing essential packages..."; \
		Rscript -e " \
			packages <- c('tidyverse', 'here', 'knitr', 'janitor'); \
			repos <- 'https://cloud.r-project.org'; \
			new_packages <- packages[!(packages %in% installed.packages()[,'Package'])]; \
			if(length(new_packages) > 0) { \
				cat('Installing:', paste(new_packages, collapse=', '), '\n'); \
				install.packages(new_packages, repos=repos, dependencies=FALSE); \
			} else { \
				cat('All core packages already installed\n'); \
			}; \
			cat('✅ Core R packages installation completed\n')"; \
	else \
		echo "❌ R not found. Please install R first."; \
		echo "Visit: https://cran.r-project.org/"; \
		exit 1; \
	fi

# Install all R packages (complete installation)
install-r-packages-full:
	@echo "📦 Installing all R packages (may take several minutes)..."
	@if command -v R >/dev/null 2>&1; then \
		echo "Installing complete package set..."; \
		Rscript -e " \
			packages <- c('tidyverse', 'here', 'janitor', 'naniar', 'broom', 'rstatix', 'effectsize', 'patchwork', 'knitr', 'kableExtra', 'DT', 'gt', 'flextable'); \
			repos <- 'https://cloud.r-project.org'; \
			new_packages <- packages[!(packages %in% installed.packages()[,'Package'])]; \
			if(length(new_packages) > 0) { \
				cat('Installing:', paste(new_packages, collapse=', '), '\n'); \
				install.packages(new_packages, repos=repos, dependencies=TRUE); \
			} else { \
				cat('All packages already installed\n'); \
			}; \
			cat('✅ All R packages installation completed\n')"; \
	else \
		echo "❌ R not found. Please install R first."; \
		echo "Visit: https://cran.r-project.org/"; \
		exit 1; \
	fi
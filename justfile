set shell := ["bash", "-cu"]

# Default: list recipes
default:
    @just --list

# Build the PDF (incremental, uses Tectonic.toml workspace)
build:
    tectonic -X build

# Force a full rebuild (clear cache, then build)
rebuild: clean build

# Build and open the PDF (macOS)
view: build
    open build/main/main.pdf

# Live-rebuild on file changes (requires: brew install watchexec)
watch:
    watchexec -w src -e tex,bib -r 'just build'

# Remove build artifacts
clean:
    rm -rf build

# Type/lint check with chktex if available
lint:
    @if command -v chktex >/dev/null 2>&1; then \
        find src -name '*.tex' -print0 | xargs -0 chktex -q; \
    else \
        echo "chktex not installed; skipping (brew install chktex)"; \
    fi

# Print the resolved doc path
info:
    @echo "Workspace: $(pwd)"
    @echo "Output:    build/main/main.pdf"
    @tectonic --version

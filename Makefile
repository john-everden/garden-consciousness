.PHONY: help test docs clean

help:
    @echo "Garden of Consciousness Development Tools"
    @echo ""
    @echo "Available commands:"
    @echo "  make test      - Run ethical content checks"
    @echo "  make docs      - Build documentation"
    @echo "  make clean     - Clean temporary files"
    @echo "  make serve     - Serve documentation locally"
    @echo ""

test:
    @echo "🔍 Running ethical content checks..."
    @python scripts/check_ethical_content.py *.md

docs:
    @echo "📚 Building documentation..."
    @echo "Documentation structure complete."

clean:
    @echo "🧹 Cleaning temporary files..."
    @find . -name "*.pyc" -delete
    @find . -name "__pycache__" -delete
    @find . -name ".DS_Store" -delete

serve:
    @echo "🌐 Serving documentation..."
    @echo "Visit: http://localhost:8000"
    @python -m http.server 8000

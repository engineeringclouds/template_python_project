"""Template Python Project.

A modern Python project template with CI/CD and best practices.

This template provides:
- Automated CI/CD with GitHub Actions
- Security scanning and dependency management
- Code quality tools (Black, Ruff, MyPy, pytest)
- Automated semantic versioning and releases
- Community health files and documentation
- Container support with Docker
- GitHub repository configuration automation

Use this template:
https://github.com/engineeringclouds/template_python_project/generate
"""

from .main import hello

__version__ = "1.0.1"
__all__ = ["hello"]

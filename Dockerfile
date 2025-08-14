# Use official Python image as a parent image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY src/ ./src/
COPY pyproject.toml ./
COPY README.md ./

# Install dependencies
RUN pip install --upgrade pip && \
    pip install -e ./src

# Set default command
CMD ["python", "-m", "template_python_project"]

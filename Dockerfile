# Use official Python image as a parent image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Create a non-root user for security
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

# Copy project files
COPY src/ ./src/
COPY pyproject.toml ./
COPY README.md ./

# Install dependencies
RUN pip install --upgrade pip && \
    pip install -e .

# Change ownership of the app directory
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set default command
CMD ["python", "-m", "template_python_project"]

# Contributing to template_python_project

Thank you for considering contributing to this project!  
We welcome contributions of all kinds, including bug reports, feature requests, documentation improvements, and code.

## How to Contribute

1. **Fork the repository**  
   Click the "Fork" button at the top right of the repository page.

2. **Clone your fork**

    ```sh
    git clone https://github.com/yourusername/template_python_project.git
    cd template_python_project
    ```

3. **Create a new branch**

    ```sh
    git checkout -b my-feature-branch
    ```

4. **Install development dependencies**  
   It is recommended to use a virtual environment:

    ```sh
    python -m venv .venv
    source .venv/bin/activate  # On Windows: .venv\Scripts\activate
    pip install -e ".[dev]"
    ```

5. **Make your changes**  
   Follow the code style enforced by Black and Ruff.  
   Add or update tests as needed.

6. **Run pre-commit hooks and tests**

    ```sh
    pre-commit run --all-files
    pytest
    ```

7. **Commit and push your changes**

    ```sh
    git add .
    git commit -m "Describe your changes"
    git push origin my-feature-branch
    ```

8. **Open a Pull Request**  
   Go to the repository on GitHub and open a pull request from your branch.

## Code Style

-   Use [Black](https://black.readthedocs.io/) for formatting.
-   Use [Ruff](https://docs.astral.sh/ruff/) for linting.
-   Type annotations are encouraged.
-   Write clear, concise commit messages.

## Reporting Issues

-   Use the [issue tracker](https://github.com/yourusername/template_python_project/issues) to report bugs or request features.
-   Please provide as much detail as possible.

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).  
By participating, you are expected to uphold this code.

## Containerization

You can build and run the Hello World app in a container using Docker:

```sh
docker build -t template-python-project .
docker run --rm template-python-project
```

---

Thank you for helping make

# Contributing to template_python_project

Thank you for considering contributing to this project!  
We welcome contributions of all kinds, including bug reports, feature requests, documentation improvements, and code.

This project embodies a collaborative "vibe coding" philosophy - we believe the best solutions emerge through iterative conversation and real-world testing, whether that's human-to-human or human-to-AI collaboration. We value the process of building something useful together.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior by opening an issue or contacting the project maintainers.

This project adheres to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

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

4. **Bootstrap your development environment**  
   Run the appropriate bootstrap script for your operating system:

    - Linux/macOS:
        ```sh
        ./scripts/bootstrap.sh
        ```
    - Windows (PowerShell):
        ```powershell
        .\scripts\bootstrap.ps1
        ```

   Alternatively, you can set up manually:
    ```sh
    python -m venv .venv
    source .venv/bin/activate  # On Windows: .venv\Scripts\activate
    pip install -e ".[dev]"
    pre-commit install
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

## Containerization

You can build and run the Hello World app in a container using Docker:

```sh
docker build -t template-python-project .
docker run --rm template-python-project
```

---

Thank you for helping make this template better! We believe in collaborative development and appreciate every contribution, whether it's code, documentation, or ideas. Together, we can build something truly useful for the Python community.

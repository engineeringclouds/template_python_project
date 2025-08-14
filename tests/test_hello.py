import sys
import os

sys.path.insert(
    0,
    os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../src")
    )
)

from template_python_project import hello

def test_hello():
    assert hello() == "Hello, world!"

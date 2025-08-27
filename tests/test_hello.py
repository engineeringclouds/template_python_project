"""Tests for the hello function."""

from template_python_project import hello

def test_hello():
    """Test that hello returns the expected greeting."""
    assert hello() == "Hello, world!"


def test_hello_return_type():
    """Test that hello returns a string."""
    result = hello()
    assert isinstance(result, str)


def test_hello_not_empty():
    """Test that hello returns a non-empty string."""
    result = hello()
    assert len(result) > 0

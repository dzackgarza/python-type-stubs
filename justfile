set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

sympy-stubs := "stubs/sympy-stubs"
assumptions-file := "stubs/sympy-stubs/assumptions/assume.pyi"

default:
    @just --list

sympy-mypy-file:
    # Type-check one file with the repo stub configuration.
    uvx --with sympy --with numpy --with pytest --from mypy \
        mypy --config-file pyproject.toml {{assumptions-file}}

sympy-mypy:
    # Type-check the whole sympy stub package.
    uvx --with sympy --with numpy --with pytest --from mypy \
        mypy --config-file pyproject.toml {{sympy-stubs}}

sympy-pyright:
    # Mirror core pyright run on sympy stubs.
    uvx --from pyright pyright {{sympy-stubs}}

sympy-check:
    # Run the full sympy stub check stack.
    just sympy-mypy
    just sympy-pyright

# Run the fast commit check; the commit hook runs this
test-commit:
    @just -f ~/ai-review-ci/justfiles/python.just -d . test-commit

# Run the fast push check; the push hook runs this
test-push:
    @just -f ~/ai-review-ci/justfiles/python.just -d . test-push

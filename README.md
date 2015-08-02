linter-python-pep257
=============

A [Linter][] plugin to lint Python docstrings according to the semantics and conventions spec'd in [pep257][spec].
This is a fork of https://github.com/AtomLinter/linter-pep257 but rewritten to support the Atom-linter's new API.

In use side-by-side with the flake8 linter:

![Screenshot of pep257 feedback](https://github.com/sfodje/linter-python-pep256/blob/master/screenshot.png?raw=true)

## Installation

1. If Linter is not already installed, follow the [linter installation instructions][linter-install].

1. Configure linter to show "info" messages:

  * Open the config for Linter.
  * Check option "Show Info Messages".

1. Install python package [pep257][].

  Execute in a terminal:
  ```
  pip install pep257
  ```

1. Install plugin.

  Execute:
  ```
  apm install linter-python-pep257
  ```

## Configuration

setting | values
--- | ---
Error codes to ignore (comma separated) | Example: `D100,D101` - [all available error codes][pep257 codes]
Path to executable pep257 cmd | Default: pep257

If using python version management, like [pyenv][], the path configuration will need to be set.  For pyenv, the path for pep257 is discoverable by executing:
```
pyenv which pep257
```


[Linter]: https://github.com/AtomLinter/Linter
[linter-install]: https://github.com/AtomLinter/Linter#installation
[pep257]: https://pypi.python.org/pypi/pep257
[pep257 codes]:https://github.com/GreenSteam/pep257/#error-codes
[pyenv]: https://github.com/yyuu/pyenv
[spec]: http://legacy.python.org/dev/peps/pep-0257/

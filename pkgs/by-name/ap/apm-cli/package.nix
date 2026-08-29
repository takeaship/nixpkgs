{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "apm-cli";
  version = "0.28.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "apm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dQrbDvewO7rL1oFR2bWaxA1DjcLJqdn483tHPv4Lod4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"llm-github-models>=0.18.0",' ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    colorama
    filelock
    gitpython
    llm
    # Not in nixpkgs and the game is not worth the candle for this package.
    # llm-github-models
    python-frontmatter
    pyyaml
    requests
    rich
    rich-click
    ruamel-yaml
    toml
    tomlkit
    tomli
    truststore
    watchdog
    websockets
  ];

  optional-dependencies = with python3Packages; {
    build = [
      pyinstaller
    ];
    dev = [
      hypothesis
      jsonschema
      mypy
      # Not packaged in nixpkgs.
      # mutmut
      pylint
      pytest
      pytest-cov
      # Not packaged in nixpkgs.
      # pytest-split
      pytest-xdist
      ruff
    ];
  };

  pythonImportsCheck = [
    "apm_cli"
  ];

  meta = {
    description = "Agent Package Manager";
    homepage = "https://github.com/microsoft/apm";
    changelog = "https://github.com/microsoft/apm/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "apm";
  };
})

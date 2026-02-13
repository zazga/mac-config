#!/bin/bash

if command -v yamllint &>/dev/null; then
  echo "yamllint is already installed"
  return 0
fi

echo "Installing yamllint"

brew install yamllint

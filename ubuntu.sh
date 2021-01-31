#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/_functions.sh

./apt.sh

for script in $(find . -name "*.sh" | grep -v apt.sh | grep -v ubuntu.sh | grep -v "_"); do
  . $script
done

#!/usr/bin/env bash

set -euo pipefail

pushd test/output
rm -rf *
../../generate.awk ../fixture.input
popd

diff -bur test/expected test/output

#!/bin/bash

set -e

# ensure dependencies
dep ensure -v

# run test
go test -v ./test/ -timeout 30m | tee test_output.log
terratest_log_parser -testlog test_output.log -outputdir test_output
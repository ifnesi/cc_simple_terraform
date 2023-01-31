#!/bin/bash
set -e

# Output JSON result with all internal variables set
printf '{
    "AWS_ACCESS_KEY_ID": "%s",
    "AWS_SECRET_ACCESS_KEY": "%s"
}' "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY"

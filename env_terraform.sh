#!/bin/bash
set -e

# Output JSON result with all internal variables set
printf '{
    "AWS_ACCESS_KEY_ID": "%s",
    "AWS_SECRET_ACCESS_KEY": "%s",
    "MONGODB_ATLAS_PROJECT_ID": "%s",
    "MONGODB_ATLAS_PUBLIC_IP_ADDRESS": "%s"
}' "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" "$MONGODB_ATLAS_PROJECT_ID" "$MONGODB_ATLAS_PUBLIC_IP_ADDRESS"

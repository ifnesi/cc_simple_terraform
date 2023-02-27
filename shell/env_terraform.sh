#!/bin/bash
set -e

# Output JSON result with all internal variables set
printf '{
    "MONGODB_ATLAS_PROJECT_ID": "%s",
    "MONGODB_ATLAS_PUBLIC_IP_ADDRESS": "%s"
}' "$MONGODB_ATLAS_PROJECT_ID" "$MONGODB_ATLAS_PUBLIC_IP_ADDRESS"

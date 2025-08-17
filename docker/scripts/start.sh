#!/bin/sh
set -e

if [ -z "$DEV" ]; then 
    FRIZZANTE_USING_DOCKER=1 frizzante -y --welcome
else 
    frizzante -y --dev
fi
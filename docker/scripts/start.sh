#!/bin/sh
set -e

if [ -z "$DEV" ]; then 
    FRIZZANTE_USING_DOCKER=1 frizzante --welcome
else 
    FRIZZANTE_USING_DOCKER=1 frizzante --dev
fi
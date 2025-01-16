#!/bin/bash

if curl -f http://127.0.0.1:5050 > /dev/null 2>&1; then
    echo "Flask is running"
    exit 0
else
    echo "Flask is not running"
    exit 1
fi

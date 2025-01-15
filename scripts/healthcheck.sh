#!/bin/bash
if curl -f http://localhost:1010 > /dev/null 2>&1; then
    echo "Nginx is running"
    exit 0
else
    echo "Nginx is not running"
    exit 1
fi

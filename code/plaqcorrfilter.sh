#!/bin/bash

awk -F '=' 'BEGIN {count = 0} /read/ {count += 1; print count, $2}'

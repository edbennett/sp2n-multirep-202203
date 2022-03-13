#!/bin/bash

awk 'BEGIN {count = 0} /Plaquette/ {if ($1 == "[MAIN][0]Plaquette:") {count += 1; print count, $2}}'

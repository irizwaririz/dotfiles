#!/bin/bash

function check_version() {
    curl -s "https://unicode.org/Public/cldr/$1/" | grep -o "core.zip<" >/dev/null && echo 0 || echo 1
}

function cldr_versions() {
    curl -s "https://unicode.org/Public/cldr/" | grep -oP "(?<=<li><a href=\")\d+(\.\d+)*" | tac
}

echo "Downloading version list..."
for v in $(cldr_versions); do
    echo "Checking version $v..."
    if [[ $(check_version $v) -eq 0 ]]; then
        echo "Downloading CLDR v$v..."
        curl "https://unicode.org/Public/cldr/$v/core.zip" -o "cldr-core.zip"
        break
    fi
done

echo "Extracting zip contents..."
unzip "cldr-core.zip" common/annotations/en.xml -d .

echo "Formatting sequences..."
cat common/annotations/en.xml | 
    grep -shP "annotation cp=\".\">" | 
    sed -Ee "s/\s+<annotation cp=\"//g; s/\">/ /g; s|</annotation>||g; s/\s\|\s/, /g" > emoji_list

echo "Cleaning up CLDR files..."
rm -rf common cldr-core.zip

echo "Done."

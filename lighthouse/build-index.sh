#!/usr/bin/env bash
# Prints lighthouse/index.html, listing every report in the bucket under
# lighthouse/blog/ and lighthouse/website/, using index.template.
#
#   lighthouse/build-index.sh <bucket> > index.html
set -euo pipefail

bucket="$1"
here="$(dirname "$0")"

items() {
  aws s3 ls "s3://${bucket}/lighthouse/$1/" \
    | awk '{print $4}' \
    | grep -E '^(test-)?report-' \
    | sort \
    | sed "s#.*#            <li><a href=\"./$1/&\">&</a></li>#"
}

BLOG="$(items blog)" WEBSITE="$(items website)" awk '
  { print }
  /BLOG HISTORY START/ { print ENVIRON["BLOG"] }
  /WEBSITE HISTORY START/ { print ENVIRON["WEBSITE"] }
' "${here}/index.template"

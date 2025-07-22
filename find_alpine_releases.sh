#!/bin/sh

INPUT_FILE="alpine_raw.txt"
OUTPUT_FILE="alpine_expanded.txt"

[ -e ${INPUT_FILE} ] && truncate -s 0 ${INPUT_FILE}
[ -e ${OUTPUT_FILE} ] && truncate -s 0 ${OUTPUT_FILE}

xidel "https://www.alpinelinux.org/posts/" \
  --xpath '(//ul[@class="home-list"]/li[contains(translate(., "RELEASED", "released"), "released")])[position() <= 2]' \
  -e 'string(./time) || " " || substring-before(substring-after(./a, "Alpine "), " released")' > "$INPUT_FILE"

while IFS= read -r line; do
  date=$(echo "$line" | awk '{print $1}')
  versions=$(echo "$line" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]+Alpine[[:space:]]+//; s/ and /, /; s/ released.*//')
  for v in $(echo "$versions" | tr ',' '\n'); do
    echo "$date Alpine $v" >> "$OUTPUT_FILE"
  done
done < "$INPUT_FILE"

echo "✅ Risultato salvato in $OUTPUT_FILE"
cat "$OUTPUT_FILE"

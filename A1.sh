#!/bin/bash

mkdir -p ./_templates

touch ./_templates/datei-1.txt
touch ./_templates/datei-2.pdf
touch ./_templates/datei-3.doc

mkdir -p ./_schulklassen

schueler_namenTBZ=("Luca" "Yannik" "Albara" "Levi" "Levin" "Nicola" "Karin" "Jörg" "Ryan" "Leo" "Noah" "Amir")
schueler_namenSekundarstufe=("Luca" "Ryan" "Leo" "Levin" "Yannik" "Albara" "Nicola" "Karin" "Jörg" "Amir" "Noah" "Levi")
schueler_namenAusbildungszentrum=("Amir" "Luca" "Aldin" "Levin" "Luca" "Noah" "Levi" "Yannik" "Albara" "Nicola" "Jörg" "Ryan")

echo "${schueler_namenTBZ[@]}" | tr ' ' '\n' > ./_schulklassen/M122-AP23d.txt
echo "${schueler_namenSekundarstufe[@]}" | tr ' ' '\n' > ./_schulklassen/3A.txt
echo "${schueler_namenAusbildungszentrum[@]}" | tr ' ' '\n' > ./_schulklassen/RAU.txt
 

#!/bin/bash


SCHULKLASSEN_DIR="./_schulklassen"
TEMPLATES_DIR="./_templates"

for schulklasse_file in "$SCHULKLASSEN_DIR"/*.txt; do

  klasse_name=$(basename "$schulklasse_file" .txt)

  mkdir -p "$SCHULKLASSEN_DIR/$klasse_name"

  while IFS= read -r schueler_name; do

    schueler_dir="$SCHULKLASSEN_DIR/$klasse_name/$schueler_name"
    mkdir -p "$schueler_dir"

    cp -r "$TEMPLATES_DIR/"* "$schueler_dir/"
  done < "$schulklasse_file"
done

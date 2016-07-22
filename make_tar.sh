
set -e

DIRS="st2 st2mistral st2web"

for dir in $DIRS; do
  echo "Creating data/${dir}.tar.gz"
  rm -rf data/${dir}.tar.gz || :
  tar -czf data/${dir}.tar.gz -C data/$dir .
done

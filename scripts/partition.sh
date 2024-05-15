#!/usr/bin/env bash


echo -e "💎 Partitioning big shards...\n"

cd model

# Define an empty array to store unique filenames
ignored=()

for file_name in $(find . -type f -size +20M -name "*.bin" | sed 's/^\.\///'); do
    # Split the file into chunks using split command
    split -a 2 -d -b 20m "$file_name" "$file_name"_
    partitions=$(ls . | grep "$file_name"_ | wc -l | xargs echo -n)
    echo "shard=$file_name, partitions=$partitions"
    # for macOs: https://stackoverflow.com/questions/16745988/sed-command-with-i-option-in-place-editing-works-fine-on-ubuntu-but-not-mac
    sed -i '' "s/$file_name\"/$file_name?partitions=$partitions\"/g" ndarray-cache.json
    ignored+=("model/$file_name")
done

cd -

rm -f .gitignore
# Write unique filenames to .gitignore (append mode)
printf "%s\n" "${ignored[@]}" >> .gitignore

echo -e "\n🚀 Done"
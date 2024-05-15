#!/usr/bin/env bash


echo -e "⚙️ Pushing model files to Github...\n"

for index in {0..9}; do
    echo "> pushing batch $index/9..."
    git add model/params_shard_"$index"*
    git commit -m "feat(model): add batch #$index"
    git push origin master
done

echo -e "\n🚀 Done"
cd /Users/chenqq/Files/ChenQiqian.github.io
rm -rf ./Docs
hugo --minify
git add .
git commit -m "Build site on $(date +'%Y-%m-%d')"
git push
echo "[[Finish Deploy]]"

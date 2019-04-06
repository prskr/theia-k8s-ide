#!/usr/bin/env bash
exts=($VSCODE_EXTENSIONS)
for extension in "${exts[@]}";
do
    name="$(echo $extension | gawk 'match($0, /^.*\/vsextensions\/(.*)(\/.*\/vspackage){1}$/, a) {print a[1]}')"
    echo "Installing extension $name from URL $extension"
    mkdir -p "/home/theia/plugins/$name"
    wget "$extension" -O "/tmp/$name.zip.gz"
    gunzip "/tmp/$name.zip.gz"
    unzip "/tmp/$name.zip" -d /home/theia/plugins/$name
    rm -f "/tmp/$name.zip"
done

node /home/theia/src-gen/backend/main.js /home/project --hostname=0.0.0.0
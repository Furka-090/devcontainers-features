#!/bin/sh

set -e

echo "Activating feature 'alpine-nushell'"

apk --no-cache add nushell --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

CURRENT_USER=$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)
echo "Acting as $CURRENT_USER"
su $CURRENT_USER

mkdir -p ~/.config/nushell/
wget -q https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_config.nu -O ~/.config/nushell/config.nu
wget -q https://raw.githubusercontent.com/nushell/nushell/main/crates/nu-utils/src/sample_config/default_env.nu -O ~/.config/nushell/env.nu

if [[ $INITSTARSHIP == "true" ]]; then
  echo $'\nmkdir ~/.cache/starship\nstarship init nu | save -f ~/.cache/starship/init.nu' >> ~/.config/nushell/env.nu
  echo $'\nsource ~/.cache/starship/init.nu' >> ~/.config/nushell/config.nu
fi

echo 'Done!'
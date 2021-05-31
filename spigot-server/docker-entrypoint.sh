#!/bin/bash

# eula に同意していなければ、同意する
agree_eula() {
  echo "Automatically agree to eula."
  java -jar spigot.jar >/dev/null 2>&1
  sed -i -e "s/eula=false/eula=TRUE/g" eula.txt
}

# spigot を起動する
run_spigot() {
  screen -UAmdS spigot java -jar spigot.jar
  echo "Spigot is running."
}

# spigot の設定ファイルが展開されるまで待機する
wait_untill_deploy() {
  while [ -n "$(ls -1 | grep -o permissions.yml)" ]; do
    sleep 10
  done
  echo "Spigot is deployed."
}

# spigot の設定ファイルを配置する
install_config() {
  cp --force /usr/src/minecraft/config/* /var/minecraft
  echo "Spigot config is installed."
}

# spigot の設定ファイルを再読み込みする
reload_config() {
  screen -S spigot -X stuff "reload^M"
  echo "Spigot config is reloaded."
}

# spigot を終了する
stop_spigot() {
  screen -S spigot -Xr stuff "stop^M"
  echo "Spigot is stopping."
}

# spigot の終了まで待つ
wait_until_stop() {
  while [ -n "$(screen -list | grep -o spigot)" ]; do
    sleep 10
  done
  echo "Spigot is stopped."
}

# メインの処理
set -eu

if [ ! -e eula.txt ]; then
  agree_eula
  run_spigot
  wait_untill_deploy
  install_config
  reload_config
else
  install_config
  run_spigot
fi
trap "stop_spigot" SIGTERM # graceful に終了させる
wait_until_stop

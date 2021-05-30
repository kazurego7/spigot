#!/bin/bash

# eula に同意していなければ、同意する
agree_eula() {
  if [ ! -e eula.txt ]; then
    echo "Automatically agree to eula."
    java -jar spigot.jar >/dev/null 2>&1
    sed -i -e "s/eula=false/eula=TRUE/g" eula.txt
  fi
}

# spigot を起動する
run_spigot() {
  screen -UAmdS spigot java -jar spigot.jar
  echo "Spigot is running."
}

# spigot を終了する
stop_spigot() {
  screen -S spigot -Xr stuff "stop^M"
}

# spigot の終了まで待つ
wait_for_stop() {
  while [ -n "$(screen -list | grep -o spigot)" ]; do
    sleep 10
  done
  echo "Spigot is stopped."
}

# メインの処理
set -eu

agree_eula
run_spigot
trap "stop_spigot" SIGTERM # graceful に終了させる
wait_for_stop

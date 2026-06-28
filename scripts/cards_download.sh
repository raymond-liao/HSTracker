#!/bin/bash

BASEDIR="$(dirname "$0")"
HSJSON="https://api.hearthstonejson.com/v1"

download() {
	local url="$1"
	local output="$2"

	if command -v wget >/dev/null 2>&1; then
		wget "$url" -O "$output"
	else
		curl -L "$url" -o "$output"
	fi
}

for lang in deDE enUS esES esMX frFR itIT jaJP koKR plPL ptBR ruRU thTH zhCN zhTW; do
	echo "Downloading cards.$lang.json"
	download "$HSJSON/latest/$lang/cards.json" "$BASEDIR/../HSTracker/Resources/Cards/cardsDB.$lang.json"
done

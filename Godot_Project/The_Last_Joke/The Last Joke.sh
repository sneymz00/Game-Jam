#!/bin/sh
echo -ne '\033c\033]0;The Last Joke\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/The Last Joke.x86_64" "$@"

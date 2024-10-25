#!/usr/bin/env bash

docker build --pull --target=copy -t dotfiles-test . && docker run --rm -it dotfiles-test

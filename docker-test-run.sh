#!/usr/bin/env bash

docker build --pull -t dotfiles-test . && docker run --rm -it dotfiles-test

#!/bin/bash

# Script for encrypting folders

OPERATION=$1 # e = encrypt; d = decrypt

NAME=$2 # folder/file to encrypt/decrypt; a file/folder with this name should not exist

if [[ $OPERATION == "e" ]]; then
	tar czf "$NAME.tar.gz" "$NAME"
	openssl enc -aes-256-cbc -iter 10 -out "$NAME.dat" -in "$NAME.tar.gz"
	rm -rf "$NAME" "$NAME.tar.gz"
fi

if [[ $OPERATION == "d" ]]; then
	openssl enc -aes-256-cbc -d -iter 10 -out "$NAME.tar.gz" -in "$NAME.dat"
	tar xzf "$NAME.tar.gz"
	rm -rf "$NAME.dat" "$NAME.tar.gz"
fi

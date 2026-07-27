#!/bin/bash

echo "=== Custom MD5 Dictionary Cracker ==="

# Prompt for target hash
read -p "Enter the target MD5 hash: " target_hash
target_hash=$(echo "$target_hash" | tr '[:upper:]' '[:lower:]')

if [ ! -f "wordlist.txt" ]; then
    echo "Error: wordlist.txt not found!"
    exit 1
fi

found=0
attempts=0
start_time=$(date +%s)

while IFS= read -r word || [ -n "$word" ]; do
    # Clean up carriage returns
    word=$(echo "$word" | tr -d '\r')
    ((attempts++))

    # Generate MD5 hash of the current word
    computed_hash=$(echo -n "$word" | md5sum | awk '{print $1}')

    # Compare
    if [ "$computed_hash" = "$target_hash" ]; then
        end_time=$(date +%s)
        elapsed=$((end_time - start_time))
        echo ""
        echo "[+] Success! Password found: '$word'"
        echo "[+] Total attempts: $attempts"
        echo "[+] Time elapsed: ${elapsed} seconds"
        found=1
        break
    fi
done < wordlist.txt

if [ $found -eq 0 ]; then
    echo ""
    echo "[-] Password not found in wordlist after $attempts attempts."
fi

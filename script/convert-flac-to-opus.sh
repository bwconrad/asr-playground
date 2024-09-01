#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

input_dir="$1"
output_dir="$2"

mkdir -p "$output_dir"

# Find FLAC files in the input directory and convert them
find "$input_dir" -type f -name "*.flac" | while read -r flac_file; do
    # Get the relative path and filename without extension
    rel_path=$(realpath --relative-to="$input_dir" "$(dirname "$flac_file")")
    filename=$(basename "$flac_file" .flac)
    
    mkdir -p "${output_dir}/${rel_path}"
    
    ffmpeg -i "$flac_file" -c:a libopus -b:a 128k "${output_dir}/${rel_path}/${filename}.opus"
    
    echo "Converted: $flac_file to ${output_dir}/${rel_path}/${filename}.opus"
done

echo "Conversion complete!"

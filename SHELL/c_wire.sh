#!/bin/bash

CSV_FILE="c-wire.dat"
OUTPUT_DIR="output_file"
SEPARATOR=";"
COLUMNS=""

# Function help
function_help() {
    echo "To run code: $0 <path_to_dat_file> <station_type> <consumer_type> <ID> <-h>"
    echo ""
    echo "Description of parameters:"
    echo "<path_to_csv_file>: File path (e.g., c-wire.dat)"
    echo "<station_type>: hvb - hva - lv"
    echo "<consumer_type>: comp - indiv - all"
    echo "<ID>: ID of the station (1-5)"
    echo "Use '-h' to display this help."
}

# Function to verify arguments
argument_verifiaction() {
    local file_path=$1
    local station_type=$2
    local consumer_type=$3
    local ID=$4

    # Check if the data file exists
    if [ ! -f "$file_path" ]; then
        echo "Error: The data file '$file_path' does not exist."
        function_help
        exit 1
    fi

    # Validate station type
    if [[ "$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv" ]]; then
        echo "Error: Invalid station type. Allowed values are: hvb, hva, lv."
        function_help
        exit 2
    fi

    # Validate consumer type
    if [[ "$consumer_type" != "comp" && "$consumer_type" != "indiv" && "$consumer_type" != "all" ]]; then
        echo "Error: Invalid consumer type. Allowed values are: comp, indiv, all."
        function_help
        exit 3
    fi

    # Validate station ID
    if [ -z "$ID" ]; then
        echo "No station ID provided. Processing all stations of type '$station_type'."
    elif [ "$ID" -lt 1 ] || [ "$ID" -gt 5 ]; then
        echo "Error: Station ID must be between 1 and 5."
        function_help
        exit 4
    else
        echo "Processing station ID: $ID."
    fi
}

# Function to verify and compile the executable
veriffication_for_executable() {
    local source_file="c_wire.c"
    local executable="./c_wire"

    if [ ! -x "$executable" ]; then
        echo "Executable '$executable' not found. Attempting to compile..."
        if [ ! -f "$source_file" ]; then
            echo "Error: Source file '$source_file' not found."
            exit 5
        fi
        gcc "$source_file" -o "$executable"
        if [ $? -ne 0 ]; then
            echo "Error: Compilation of '$source_file' failed."
            exit 6
        fi
        echo "Compilation successful. Executable created: '$executable'."
    fi
    echo "Executing '$executable' with arguments: $@"
    "$executable" "$@"
    if [ $? -ne 0 ]; then
        echo "Error: Execution of '$executable' failed."
        exit 7
    fi
}

# Function to manage temp and graphs directories
verification_temp_graph() {
    local Graphs_path="Graphs"
    local Temps_path="temp"

    if [ -d "$Graphs_path" ]; then
        echo "Clearing the '$Graphs_path' directory."
        rm -r "$Graphs_path"/*
    else
        echo "Creating the '$Graphs_path' directory."
        mkdir -p "$Graphs_path"
    fi

    if [ -d "$Temps_path" ]; then
        echo "Clearing the '$Temps_path' directory."
        rm -r "$Temps_path"/*
    else
        echo "Creating the '$Temps_path' directory."
        mkdir -p "$Temps_path"
    fi
}

# Main script logic
if [ "$1" == "-h" ]; then
    function_help
    exit 0
fi

if [ $# -lt 4 ]; then
    echo "Error: Missing arguments."
    function_help
    exit 8
fi

argument_verifiaction "$1" "$2" "$3" "$4"
veriffication_for_executable "$@"
verification_temp_graph

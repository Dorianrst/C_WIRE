#!/bin/bash

# Record start time in seconds
start=$(date +%s)

# Dynamic relative paths
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
DATA_FILE="$SCRIPT_DIR/c-wire_v00.dat"
EXECUTABLE="$PROJECT_DIR/c_wire"
OUTPUT_FILE="$PROJECT_DIR/output.csv"

# Function to clean up spaces around a string
trim() {
    echo "$1" | xargs
}

# Help function
function_help() {
    echo "Usage: $0 <station_type> <consumer_type> [ID] [-h]"
    echo ""
    echo "Parameter description:"
    echo "<station_type>: hvb | hva | lv."
    echo "<consumer_type>: comp | indiv | all."
    echo "[ID]: (Optional) Station ID between 1 and 5. If not supplied, all stations will be processed."
    echo "-h: Displays this help message."
}

debug_arguments() {
    echo "DEBUG: Arguments received:"
    echo "  Station type: '$2'"
    echo "  Consumer type: '$3'"
    echo "  ID: '$4'"
    echo ""
}

# Argument verification
argument_verification() {
    local station_type=$(trim "$2")
    local consumer_type=$(trim "$3")
    local ID=$(trim "$4")

    # Check that the data file exists
    if [ ! -f "$DATA_FILE" ]; then
        echo "Error: The data file '$DATA_FILE' cannot be found."
        exit 1
    fi

    # Validation of station type
    if [[ "$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv" ]]; then
        echo "Error: Invalid station type. Allowed values: hvb, hva, lv."
        exit 2
    fi

    # Validation of consumer type
    if [[ "$consumer_type" != "comp" && "$consumer_type" != "indiv" && "$consumer_type" != "all" ]]; then
        echo "Error: Invalid consumer type. Allowed values: comp, indiv, all."
        exit 3
    fi

    # Validation of station ID
    if [ -z "$ID" ]; then
        echo "No station ID provided. All stations of type '$station_type' will be processed."
        process_all_stations "$station_type" "$consumer_type"
    else
        if [[ "$ID" =~ ^[0-9]+$ ]] && [ "$ID" -ge 1 ] && [ "$ID" -le 5 ]; then
            echo "Processing station ID: $ID."
            process_station "$station_type" "$consumer_type" "$ID"
        else
            echo "Error: The station ID must be a number between 1 and 5."
            exit 4
        fi
    fi
}

# Check and compile the executable
check_for_executable() {
    local script_dir=$(dirname "$0")          # Directory containing the script
    local project_dir="$script_dir/.."        # Root directory of the project
    local source_file="$project_dir/c_wire.c" # Source file
    local executable="$project_dir/c_wire"    # Executable

    # Verify if the executable exists
    if [ ! -x "$executable" ]; then
        echo "The executable '$executable' was not found. Attempting compilation..."

        # Verify if the source file exists
        if [ ! -f "$source_file" ]; then
            echo "Error: The source file '$source_file' cannot be found."
            exit 5
        fi

        # Compile the source file
        gcc "$source_file" -o "$executable"
        if [ $? -ne 0 ]; then
            echo "Error: Compilation of '$source_file' failed."
            exit 6
        fi
        echo "Compilation successful. Executable created: '$executable'."
    fi

    # Run the executable with the provided arguments
    echo "Running '$executable' with arguments: $@"
    "$executable" "$@" >"$PROJECT_DIR/output.csv" # Redirect output to a CSV file
    if [ $? -ne 0 ]; then
        echo "Error: Execution of '$executable' failed."
        exit 7
    fi

    echo "Execution successful. Results saved in '$PROJECT_DIR/output.csv'."
}

# Placeholder for processing all stations
process_all_stations() {
    local station_type=$1
    local consumer_type=$2
    echo "Processing all stations of type '$station_type' for consumer type '$consumer_type'."
}

# Placeholder for processing a specific station
process_station() {
    local station_type=$1
    local consumer_type=$2
    local ID=$3
    echo "Processing station ID $ID of type '$station_type' for consumer type '$consumer_type'."
}

# Placeholder for the function verification_temp_graph
verification_temp_graph() {
    # Paths relative to the main project
    local script_dir=$(dirname "$0")        # Directory containing the script (SHELL)
    local project_dir="$script_dir/.."      # Root directory of the project
    local Graphs_path="$project_dir/Graphs" # Path to the 'Graphs' directory in the project
    local Temps_path="$project_dir/temp"    # Path to the 'temp' directory in the project

    # Managing the 'Graphs' directory
    if [ -d "$Graphs_path" ]; then
        echo "Clearing the '$Graphs_path' directory."
        rm -rf "$Graphs_path"/* # Use 'rm -rf' to delete without error if the directory is empty
    else
        echo "Creating the '$Graphs_path' directory."
        mkdir -p "$Graphs_path"
    fi

    # Managing the 'temp' directory
    if [ -d "$Temps_path" ]; then
        echo "Clearing the '$Temps_path' directory."
        rm -rf "$Temps_path"/* # Use 'rm -rf' to delete without error if the directory is empty
    else
        echo "Creating the '$Temps_path' directory."
        mkdir -p "$Temps_path"
    fi
}

# Main logic
if [ "$1" == "-h" ]; then
    function_help
    exit 0
fi

if [ $# -lt 2 ]; then
    echo "Error: Missing arguments."
    function_help
    exit 8
fi

echo "Starting argument verification..."
argument_verification "$1" "$2" "$3"

check_for_executable "$@"
verification_temp_graph

# Record the end time in seconds
end=$(date +%s)
# Calculate the duration (in seconds)
duration=$((end - start))

# Output the execution time
echo "Execution time: $duration seconds"

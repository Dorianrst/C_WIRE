#!/bin/bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
# Icons
OK="${GREEN}✔️${RESET}"
ERROR="${RED}❌${RESET}"
INFO="${CYAN}ℹ️${RESET}"
ARROW="${BLUE}➡️${RESET}"
# Dividing Line
SEPARATOR="${CYAN}============================================${RESET}"
# Record start time in seconds
start=$(date +%s)
# Dynamic relative paths
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
DATA_FILE="$SCRIPT_DIR/Input/c-wire_v00.dat"
EXECUTABLE="$SCRIPT_DIR/CodeC/c_wire"
OUTPUT_FILE="$PROJECT_DIR/output.csv"
# Function for cleaning the spaces around a chain
trim() {
    echo "$1" | xargs
}
# Help function
function_help() {
    echo -e "${SEPARATOR}"
    echo -e "${INFO} Usage : $0 <station_type> <consumer_type> [ID] [-h]"
    echo -e "${INFO} Description of parameters :"
    echo -e "${ARROW} <station_type>: hvb | hva | lv."
    echo -e "${ARROW} <consumer_type>: comp | indiv | all."
    echo -e "${ARROW} [ID]: (Optional) Station ID between 1 and 5. If not provided, all stations will be processed."
    echo -e "${ARROW} -h: Displays this help message."
    echo -e "${ARROW} : he following options are prohibited because only companies are connected to the HV-B and HV-A stations :
hvb all
hvb indiv
hva all
hva indiv"
    echo -e "${SEPARATOR}"
}

# Checking arguments
argument_verification() {

    local station_type=$(trim "$2")
    local consumer_type=$(trim "$3")
    local ID_raw="$4"
    local ID=$(trim "$4")

    echo "DEBUG: station_type='$station_type', consumer_type='$consumer_type', ID='$ID'"
    # Check that the data file exists
    if [ ! -f "$DATA_FILE" ]; then
        echo -e "${ERROR} The data file '$DATA_FILE' cannot be found."
        exit 1
    fi

    #Validation of station type
    if [[ "$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv" ]]; then
        echo -e "${ERROR} Invalid station type. Allowed values: hvb, hva, lv."
        exit 2
    fi

    # Validation of consumer type
    if [[ "$consumer_type" != "comp" && "$consumer_type" != "indiv" && "$consumer_type" != "all" ]]; then
        echo -e "${ERROR} Invalid consumer type. Allowed values: comp, indiv, all."
        exit 3
    fi
    # Checking for specific restrictions
    if [[ "$station_type" == "hvb" || "$station_type" == "hva" ]]; then
        if [[ "$consumer_type" == "all" || "$consumer_type" == "indiv" ]]; then
            echo -e "${ERROR} The ‘all’ and ‘indiv’ options are prohibited for HV-B and HV-A stations."
            function_help
            exit 5
        fi
    fi

    #Validation of station ID
    if [ -z "$ID" ]; then
        echo -e "${INFO} No station ID provided. All stations of type '${station_type}' will be processed."
        process_all_stations "$station_type" "$consumer_type"
    else
        if [[ "$ID" =~ ^[0-9]+$ ]] && [ "$ID" -ge 1 ] && [ "$ID" -le 5 ]; then
            echo -e "${OK} Processing station ID: $ID."
            process_station "$station_type" "$consumer_type" "$ID"
        else
            echo -e "${ERROR} The station ID must be a number between 1 and 5."
            exit 4
        fi
    fi
}

# Checking and compiling the executable
veriffication_for_executable() {
    local script_dir=$(dirname "$0")                # Directory containing the script
    local project_dir="$script_dir/.."              # Project root directory
    local source_file="$SCRIPT_DIR/CodeC/c_wire.c"  # Source file
    local executable="$SCRIPT_DIR/CodeC/c_wire.exe" # Executable

    # Check if the executable exists
    if [ -f "$executable" ]; then
        # Delete the existing executable
        echo -e "${INFO} The '$executable' executable already exists. Delete the existing executable..."
        rm "$executable"
    fi

    # Compiling the source file
    echo -e "${INFO} Launching the Makefile..."

    # Check whether the Makefile exists in the directoryoire
    if [ ! -f "codeC/Makefile" ]; then
        echo "The Makefile does not exist in this directory."
        exit 5
    fi

    echo -e "${INFO}  Compile source file '$source_file'..."

    cd codeC
    make all
    # Check if the make command has failed
    if [ $? -ne 0 ]; then
        echo "${ERROR} Error during compilation in the Makefile."
        exit 6
    else
        echo "${ARROW}Successful compilation!"
    fi

    cd ..

    #if [ ! -f "$source_file" ]; then
    #    echo -e "${ERROR} Le fichier source '$source_file' est introuvable."
    #    exit 5
    #fi

    # Compiler le fichier source en exécutable
    #gcc -mconsole "$source_file" -o "$executable"
    #if [ $? -ne 0 ]; then
    #    echo -e "${ERROR} La compilation de '$source_file' a échoué."
    #    exit 6
    #fi
    #echo -e "${OK} Compilation réussie. Exécutable créé : '$executable'."

    # Run the executable with the arguments supplied
    echo "Running '$executable' with : $@"
    "$executable" "$@"
    if [ $? -ne 0 ]; then
        echo "Error : Execution of '$executable' has failed."
        exit 7
    fi

    echo "Successful execution. Results saved in '$project_dir/output.csv'."
}

# Placeholder to treat all stations
process_all_stations() {
    local station_type=$1
    local consumer_type=$2
    local ID=0
    echo "Process all stations of type'‘$station_type' for consumer type '$consumer_type'."
}

# Placeholder to treat a specific station
process_station() {
    local station_type=$1
    local consumer_type=$2
    local ID=$3
    echo "Processing of station ID $ID of type '$station_type' for consumer type '$consumer_type'."
}

verification_temp_graph() {
    # Paths relative to the project (assuming the script is in ‘Test’)
    local script_dir=$(dirname "$0")        # Directory containing the script (c_wire.sh)
    local project_dir="$script_dir"         # Project root directory, which is now ‘Test’.
    local Graphs_path="$project_dir/Graphs" # Absolute path to the ‘Graphs’
    local Temps_path="$project_dir/temp"    # Absolute path to the ‘temp’

    echo -e "${SEPARATOR}"
    echo -e "${INFO} Checking directories..."

    # Check that the project root directory exists
    if [ ! -d "$project_dir" ]; then
        echo "Error: The project root directory '$project_dir' does not exist."
        exit 1
    fi

    # Checking and managing the ‘Graphs’ directory
    if [ -d "$Graphs_path" ]; then
        echo -e "${INFO} Cleaning the directory '${Graphs_path}'."
        rm -rf "$Graphs_path"/* # Use ‘rm -rf’ to delete without error if the directory is empty
    else
        echo "Creating the directory '$Graphs_path'."
        mkdir -p "$Graphs_path" # Create a directory if it doesn't exist
        if [ $? -eq 0 ]; then
            echo "'$Graphs_path' directory created successfully."
        else
            echo "Error: Unable to create the '$Graphs_path' directory."
        fi
    fi

    # Checking and managing the ‘temp’ directory
    if [ -d "$Temps_path" ]; then
        echo -e "${INFO} Cleaning the directory '${Temps_path}'."
        rm -rf "$Temps_path"/* # Use ‘rm -rf’ to delete without error if the directory is empty
    else
        echo "Creating the directory '$Temps_path'."
        mkdir -p "$Temps_path" # Create a directory if it doesn't exist
        if [ $? -eq 0 ]; then
            echo "'$Temps_path' directory created successfully."
        else
            echo "Error: Unable to create the '$Temps_path' directory."
        fi
    fi
    echo -e "${SEPARATOR}"
}

# Main logic
if [ "$1" == "-h" ]; then
    function_help
    exit 0
fi

if [ $# -lt 2 ]; then
    echo "Error: Arguments missing"
    function_help
    exit 8
fi
echo -e "${SEPARATOR}"
echo -e "${INFO} Start argument verification..."

argument_verification "$1" "$2" "$3"
verification_temp_graph
veriffication_for_executable "$@"

# Record end time in seconds
end=$(date +%s)
# Calculate duration (in seconds)
duration=$((end - start))

# Convert nanoseconds to seconds with printf
echo -e "${OK} Runtime: ${duration} seconds."
echo -e "${SEPARATOR}"

cd codeC
make clean
cd ..

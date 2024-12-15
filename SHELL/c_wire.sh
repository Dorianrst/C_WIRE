#!/bin/bash

CSV_FILE="c-wire.dat"
OUTPUT_DIR="output_file"
SEPARATOR=";"
COLUMNS=""

#Function help
function_help() {
    echo "To run code :$0 <path_to_dat_file> <station_type> <consumer_type> <ID> <-h>"
    echo ""
    echo "Description of parameter: "
    echo ""
    echo "<path_to_csv_file>: File path(To find, it type the command 'ls' )"
    echo "<station_type>: hvb -hva -lv"
    echo "<consummer_type>: -comp -indiv -all"
    echo "<consummer_type> interdiction : -hvb all -hvb induv -hva all -hav indiv"
    echo "<ID>: ID of the station"
}
#Function A function that checks that all the arguments entered by the user are correct and that no arguments are missing.
argument_verifiaction() {
    local file_path=$1
    local station_type=$2
    local consumer_type=$3
    local ID=$4
    #We have to change this for the final test with c-wire_v25.dat

    if [ -f "data.dat" ]; then
        echo "Researching the dat file"
        echo "......................."
        echo "The file .dat exist"
    else
        echo "The file doesn't exist"
        echo "Please download the .dat file"
        function_help
        exit 0
    fi

    if [[ "$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv" ]]; then
        echo "Error : Invalid value" >&2
        function_help
        echo "You forgot to select the stations you want to process, e.g.: hva, hvb, lv"
        exit 0
    fi

    if [[ "$consumer_type" != "comp" && "$consumer_type" != "indiv" && "all" ]]; then
        echo "Error : Invalid value"
        function_help
        echo "You forgot to select the consumers you want to process: comp, indiv, all "
        exit 0
    fi

    if [ -z "$ID" ]; then
        #Put a fonction to analise all the data
        echo "The station ID was not specified at the time of processing, so we will process all the stations $station_type"

    elif ["$ID" -ge 5 ] || ["$ID" -le 1 ]; then
        echo "The ID of a central station is between 1 and 5"
        function_help
        exit 0

    else
        echo " Correct ID"
        echo "Processing will be done only with the control unit $ID"
    fi
}

veriffication_for_executable() {
    source_file="c_wire.c"
    executable="./c_wire"

    # Check if the executable exists
    if [ ! -x "$executable" ]; then
        echo "The executable '$executable' does not exist. Attempt to compile..."

        # Check if the source file exists
        if [ ! -f "$source_file" ]; then
            echo "Error: the source file '$source_file' cannot be found."
            exit 1
        fi

        # Compiling the source file
        gcc "$source_file" -o "$executable"
        if [ $? -ne 0 ]; then
            echo "Erreur : la compilation de '$source_file' a échoué."
            exit 2
        fi

        echo "Compilation successful: '$executable' has been created."
    fi

    # Exécuter l'exécutable avec les arguments fournis au script
    echo "Execution of '$executable' with the arguments: $@"
    "$executable" "$@"

    # Check that the run has been completed successfully
    if [ $? -ne 0 ]; then
        echo "Erreur : l'exécution de '$executable' a échoué."
        exit 3
    else
        echo 'The execution was completed successfully.'
    fi
}

verification_temp_graph() {
    #This function is used to check and, if necessary, create the temp and graphs files.
    if [ -n "$Graphs_path" ]; then
        echo "The image folders doesnt exist"
        rm -r "$Graphs_path"/*
        echo " The file has been emptied"
    else
        echo "The Graphs folder does not exist and will be created"
        mkdir -p "Graphs"
    fi

    # In this condition, I check whether the Time folder exists in my folders. If it does, I empty it with the command, if it doesn't exist, I create it with the command
    if [ -n "$Temps_path" ]; then
        echo "The temp File exists and will be emptied"
        rm -r "$Temps_path"/*
        echo " The file has been emptied"
    else
        echo "The temp folder does not exist and will be created"
        mkdir -p "temp"
    fi
}

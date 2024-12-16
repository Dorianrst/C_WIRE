#!/bin/bash

# Enregistrer le temps de début en secondes
start=$(date +%s)

# Chemins relatifs dynamiques
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
DATA_FILE="$SCRIPT_DIR/c-wire_v25.dat"
EXECUTABLE="$PROJECT_DIR/c_wire"
OUTPUT_FILE="$PROJECT_DIR/output.csv"

# Fonction pour nettoyer les espaces autour d'une chaîne
trim() {
    echo "$1" | xargs
}

# Fonction d'aide
function_help() {
    echo "Usage: $0 <station_type> <consumer_type> [ID] [-h]"
    echo ""
    echo "Description des paramètres :"
    echo "<station_type>: hvb | hva | lv."
    echo "<consumer_type>: comp | indiv | all."
    echo "[ID]: (Optionnel) ID de station entre 1 et 5. Si non fourni, toutes les stations seront traitées."
    echo "-h: Affiche ce message d'aide."
}

debug_arguments() {
    echo "DEBUG: Arguments reçus :"
    echo "  Station type: '$2'"
    echo "  Consumer type: '$3'"
    echo "  ID: '$4'"
    echo ""
}
# Vérification des arguments
argument_verification() {
    local station_type=$(trim "$2")
    local consumer_type=$(trim "$3")
    local ID=$(trim "$4")

    # Vérification de l'existence du fichier de données
    if [ ! -f "$DATA_FILE" ]; then
        echo "Erreur : Le fichier de données '$DATA_FILE' est introuvable."
        exit 1
    fi

    # Validation du type de station
    if [[ "$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv" ]]; then
        echo "Erreur : Type de station invalide. Valeurs autorisées : hvb, hva, lv."
        exit 2
    fi

    # Validation du type de consommateur
    if [[ "$consumer_type" != "comp" && "$consumer_type" != "indiv" && "$consumer_type" != "all" ]]; then
        echo "Erreur : Type de consommateur invalide. Valeurs autorisées : comp, indiv, all."
        exit 3
    fi

    # Validation de l'ID de station
    if [ -z "$ID" ]; then
        echo "Aucun ID de station fourni. Toutes les stations de type '$station_type' seront traitées."
        process_all_stations "$station_type" "$consumer_type"
    else
        if [[ "$ID" =~ ^[0-9]+$ ]] && [ "$ID" -ge 1 ] && [ "$ID" -le 5 ]; then
            echo "Traitement de la station ID: $ID."
            process_station "$station_type" "$consumer_type" "$ID"
        else
            echo "Erreur : L'ID de station doit être un nombre entre 1 et 5."
            exit 4
        fi
    fi
}

# Vérification et compilation de l'exécutable
veriffication_for_executable() {
    local script_dir=$(dirname "$0")          # Répertoire contenant le script
    local project_dir="$script_dir/.."        # Répertoire racine du projet
    local source_file="$project_dir/c_wire.c" # Fichier source
    local executable="$project_dir/c_wire"    # Exécutable

    # Vérifier si l'exécutable existe
    if [ ! -x "$executable" ]; then
        echo "L'exécutable '$executable' est introuvable. Tentative de compilation..."

        # Vérifier si le fichier source existe
        if [ ! -f "$source_file" ]; then
            echo "Erreur : Le fichier source '$source_file' est introuvable."
            exit 5
        fi

        # Compiler le fichier source
        gcc "$source_file" -o "$executable"
        if [ $? -ne 0 ]; then
            echo "Erreur : La compilation de '$source_file' a échoué."
            exit 6
        fi
        echo "Compilation réussie. Exécutable créé : '$executable'."
    fi

    # Exécuter l'exécutable avec les arguments fournis
    echo "Exécution de '$executable' avec les arguments : $@"
    "$executable" "$@" >"$project_dir/output.csv" # Redirection vers un fichier CSV
    if [ $? -ne 0 ]; then
        echo "Erreur : L'exécution de '$executable' a échoué."
        exit 7
    fi

    echo "Exécution réussie. Résultats sauvegardés dans '$project_dir/output.csv'."
}

# Placeholder pour traiter toutes les stations
process_all_stations() {
    local station_type=$1
    local consumer_type=$2
    echo "Traitement de toutes les stations de type '$station_type' pour le type de consommateur '$consumer_type'."
}

# Placeholder pour traiter une station spécifique
process_station() {
    local station_type=$1
    local consumer_type=$2
    local ID=$3
    echo "Traitement de la station ID $ID de type '$station_type' pour le type de consommateur '$consumer_type'."
}


# Placeholder pour la fonction verification_temp_graph
verification_temp_graph() {
    # Paths relative to the main project
    local script_dir=$(dirname "$0")          # Directory containing the script (SHELL)
    local project_dir="$script_dir/.."        # Root directory of the project
    local Graphs_path="$project_dir/Graphs"   # Path to the 'Graphs' directory in the project
    local Temps_path="$project_dir/temp"      # Path to the 'temp' directory in the project

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

# Logique principale
if [ "$1" == "-h" ]; then
    function_help
    exit 0
fi

if [ $# -lt 2 ]; then
    echo "Erreur : Arguments manquants."
    function_help
    exit 8
fi

echo "Démarrage de la vérification des arguments..."
argument_verification "$1" "$2" "$3"


veriffication_for_executable "$@"
verification_temp_graph


# Enregistrer le temps de fin en secondes
end=$(date +%s)
# Calculer la durée (en secondes)
duration=$((end - start))

# Convertir nanosecondes en secondes avec printf
echo "Temps d'exécution: $duration secondes"

   #!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Icônes
OK="${GREEN}✔️${RESET}"
ERROR="${RED}❌${RESET}"
INFO="${CYAN}ℹ️${RESET}"
ARROW="${BLUE}➡️${RESET}"

# Ligne de séparation
SEPARATOR="${CYAN}============================================${RESET}"

# Enregistrer le temps de début en secondes
start=$(date +%s)

# Chemins relatifs dynamiques
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
DATA_FILE="$SCRIPT_DIR/Input/c-wire_v00.dat"
EXECUTABLE="$SCRIPT_DIR/CodeC/c_wire"
OUTPUT_FILE="$PROJECT_DIR/output.csv"

# Fonction pour nettoyer les espaces autour d'une chaîne
trim() {
    echo "$1" | xargs
}

# Fonction d'aide
function_help() {
    echo -e "${SEPARATOR}"
    echo -e "${INFO} Usage : $0 <station_type> <consumer_type> [ID] [-h]"
    echo -e "${INFO} Description des paramètres :"
    echo -e "${ARROW} <station_type>: hvb | hva | lv."
    echo -e "${ARROW} <consumer_type>: comp | indiv | all."
    echo -e "${ARROW} [ID]: (Optionnel) ID de station entre 1 et 5. Si non fourni, toutes les stations seront traitées."
    echo -e "${ARROW} -h: Affiche ce message d'aide."
    echo -e "${ARROW} : les options suivantes sont interdites car seules des entreprises sont connectées aux stations HV-B et HV-A :
hvb all
hvb indiv
hva all
hva indiv"
    echo -e "${SEPARATOR}"
}

debug_arguments() {
    echo -e "${INFO} DEBUG : Arguments reçus :"
    echo -e "  ${ARROW} Station type: '$2'"
    echo -e "  ${ARROW} Consumer type: '$3'"
    echo -e "  ${ARROW} ID: '$4'"
    echo ""
}
# Vérification des arguments
argument_verification() {

    echo "DEBUG: Nombre d'arguments: $#"
    for i in "$@"; do
        echo "DEBUG: Argument brut = '$i'"
    done

    local station_type=$(trim "$2")
    local consumer_type=$(trim "$3")
    local ID_raw="$4"
    local ID=$(trim "$4")

    echo "DEBUG: station_type='$station_type', consumer_type='$consumer_type', ID='$ID'"
    # Vérification de l'existence du fichier de données
    if [ ! -f "$DATA_FILE" ]; then
        echo -e "${ERROR} Le fichier de données '$DATA_FILE' est introuvable."
        exit 1
    fi

    # Validation du type de station
    if [[ "$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv" ]]; then
        echo -e "${ERROR} Type de station invalide. Valeurs autorisées : hvb, hva, lv."
        exit 2
    fi

    # Validation du type de consommateur
    if [[ "$consumer_type" != "comp" && "$consumer_type" != "indiv" && "$consumer_type" != "all" ]]; then
        echo -e "${ERROR} Type de consommateur invalide. Valeurs autorisées : comp, indiv, all."
        exit 3
    fi
    # Vérification des restrictions spécifiques
    if [[ "$station_type" == "hvb" || "$station_type" == "hva" ]]; then
        if [[ "$consumer_type" == "all" || "$consumer_type" == "indiv" ]]; then
            echo -e "${ERROR} Les options 'all' et 'indiv' sont interdites pour les stations HV-B et HV-A."
            function_help
            exit 5
        fi
    fi

    # Validation de l'ID de station
    if [ -z "$ID" ]; then
        echo -e "${INFO} Aucun ID de station fourni. Toutes les stations de type '${station_type}' seront traitées."
        process_all_stations "$station_type" "$consumer_type"
    else
        if [[ "$ID" =~ ^[0-9]+$ ]] && [ "$ID" -ge 1 ] && [ "$ID" -le 5 ]; then
            echo -e "${OK} Traitement de la station ID: $ID."
            process_station "$station_type" "$consumer_type" "$ID"
        else
            echo -e "${ERROR} L'ID de station doit être un nombre entre 1 et 5."
            exit 4
        fi
    fi
}

# Vérification et compilation de l'exécutable
veriffication_for_executable() {
    local script_dir=$(dirname "$0")                # Répertoire contenant le script
    local project_dir="$script_dir/.."              # Répertoire racine du projet
    local source_file="$SCRIPT_DIR/CodeC/c_wire.c"  # Fichier source
    local executable="$SCRIPT_DIR/CodeC/c_wire.exe" # Exécutable

    # Vérifier si l'exécutable existe
    if [ -f "$executable" ]; then
        # Supprimer l'exécutable existant
        echo -e "${INFO} L'exécutable '$executable' existe déjà. Suppression de l'exécutable existant..."
        rm "$executable"
    fi

    # Compiler le fichier source
    echo -e "${INFO} Lancement du Makefile'..."

    # Vérifier si le fichier Makefile existe dans le répertoire
    if [ ! -f "codeC/Makefile" ]; then
        echo "Le fichier Makefile n'existe pas dans ce répertoire."
        exit 5
    fi

    echo -e "${INFO} Compilation du fichier source '$source_file'..."

    cd codeC
    make all
    # Vérifier si la commande make a échoué
    if [ $? -ne 0 ]; then
        echo "${ERROR} Erreur lors de la compilation."
        exit 6
    else
        echo "${ARROW} Compilation réussie !"
    fi
    
    cd ..

    # Exécuter l'exécutable avec les arguments fournis
    echo "Exécution de '$executable' avec les arguments : $@"
    "$executable" "$@"
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
    local ID=0
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
    # Paths relatifs vers le projet (en supposant que le script est dans 'Test')
    local script_dir=$(dirname "$0")        # Répertoire contenant le script (c_wire.sh)
    local project_dir="$script_dir"         # Répertoire racine du projet, qui est maintenant 'Test'
    local Graphs_path="$project_dir/Graphs" # Chemin absolu vers le répertoire 'Graphs' dans 'Test'
    local Temps_path="$project_dir/temp"    # Chemin absolu vers le répertoire 'temp' dans 'Test'

    echo -e "${SEPARATOR}"
    echo -e "${INFO} Vérification des répertoires..."

    # Vérification de l'existence du répertoire racine du projet
    if [ ! -d "$project_dir" ]; then
        echo "Erreur: Le répertoire racine du projet '$project_dir' n'existe pas."
        exit 1
    fi

    # Vérification et gestion du répertoire 'Graphs'
    if [ -d "$Graphs_path" ]; then
        echo -e "${INFO} Nettoyage du répertoire '${Graphs_path}'."
        rm -rf "$Graphs_path"/* # Utilisation de 'rm -rf' pour supprimer sans erreur si le répertoire est vide
    else
        echo "Création du répertoire '$Graphs_path'."
        mkdir -p "$Graphs_path" # Création du répertoire si il n'existe pas
        if [ $? -eq 0 ]; then
            echo "Répertoire '$Graphs_path' créé avec succès."
        else
            echo "Erreur: Impossible de créer le répertoire '$Graphs_path'."
        fi
    fi

    # Vérification et gestion du répertoire 'temp'
    if [ -d "$Temps_path" ]; then
        echo -e "${INFO} Nettoyage du répertoire '${Temps_path}'."
        rm -rf "$Temps_path"/* # Utilisation de 'rm -rf' pour supprimer sans erreur si le répertoire est vide
    else
        echo "Création du répertoire '$Temps_path'."
        mkdir -p "$Temps_path" # Création du répertoire si il n'existe pas
        if [ $? -eq 0 ]; then
            echo "Répertoire '$Temps_path' créé avec succès."
        else
            echo "Erreur: Impossible de créer le répertoire '$Temps_path'."
        fi
    fi
    echo -e "${SEPARATOR}"
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
echo -e "${SEPARATOR}"
echo -e "${INFO} Démarrage de la vérification des arguments..."

argument_verification "$1" "$2" "$3"
verification_temp_graph
veriffication_for_executable "$@"

# Enregistrer le temps de fin en secondes
end=$(date +%s)
# Calculer la durée (en secondes)
duration=$((end - start))

# Convertir nanosecondes en secondes avec printf
echo -e "${OK} Temps d'exécution: ${duration} secondes."
echo -e "${SEPARATOR}"

cd codeC
make clean
cd ..

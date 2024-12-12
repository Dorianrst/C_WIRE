#!/bin/bash

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

chmod 777 c_wire.sh

argument_verifiaction() {

    local station_type=$2
    local consumer_type=$3
    local ID=$4
    #We have to change this for the final test with c-wire_v25.dat
    local file_path=$(find .. -iname "c-wire_v00.dat") 2>/dev/null              #Cette ligne de commande permet de chercher le fichier c-wire.csv dans mes dossiers
    local Graphs_path=$(find . -type d -name "Graphs" -print -quit) 2>/dev/null #Cette ligne de commande permet de chercher si le dosier Graphs dans mes dossiers
    local Temps_path=$(find . -type d -name "Temp" -print -quit) 2>/dev/null    #Cette ligne de commande permet de chercher le dossier Temps dans mes dossiers

    if [["$station_type" != "hvb" && "$station_type" != "hva" && "$station_type" != "lv"]]; then
        echo "Error : Invalid value" >&2
        function_help
        exit 1
    fi

    if [["$consumer_type" != "comp" && "$consumer_type" != "indiv" && "all"]]; then
        echo "Error : Invalid value" >&2
        function_help
        exit 1
    fi

    if [-z "$ID" ]; then
        #Put a fonction to analise all the data
        echo "Processing all the data"
    elif ! [["$ID" =~ ^[0-9]+$]]; then

        echo "Processing only the data of the station : $ID"

    else
        echo " Correct ID"
    fi

    #I check  if the c-wire_v25.dat exist
    if [ -e "$file_path" ]; then
        echo "The c-wire_v25.dat file exist"
        echo "$file_path"
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

#Checking the .exe and compiling the C
if [ -f "$executable"]; then
    echo "The  $executable already exist"
else
    echo "The $executable doesn't exist. Compilation of $ executable ..."

fi
verification_executable() {
    if [ -f "$source_file" ]; then
        gcc "$source_file" -o "$executable"
        if [ $? -eq 0 ]; then
            echo "Successful compilation. The $executable file has been created."
        else
            echo "Error: $source_file compilation failed." >&2
        fi
    else
        echo "Error: The source file $source_file does not exist." >&2
    fi
}
#Initialisation of the start_time variable for calculating execution time
start_time=$(date +%s.%s)

#Cette condition permet de voir si je passe bien un argmument dans station il y a trois types d'arguments HVB / HVA / LV dans le cas où il n' a pas d'argument j'affiche qu'il n'y a pas d'argument et j'arrête le programme
if [ $# -eq 0 ]; then
    echo "Aucun argument fourni"
    exit 1
fi

#ORDRE DANS LE C-WIRE.CSV
#Power plant;HV-B Station;HV-A Station;LV Station;Company;Individual;Capacity;Load
#  1          2                 3          4         5         6        7       8

#Dans cette boucle on regarde l'ensemble des arguments et on lance le programme associée à l'argument mis en paramètre soit HVB / HVA / LV
for arg in "$@"; do
    case "$arg" in
    -hvb)
        echo "Exécution du tri selon la colonne Station HVB"
        cut -d';' -f2,5,6,7,8 c-wire.csv | sort -n -t';' -k1 >hvb.csv
        echo "Le tri selon la colonne Station HVB a été exécuté"

        #Lance la commande associé au fait de prendre que les colonnes suivantes  HVB / COMPANY / INDIVIDUAL / CAPACITY / LOAD et ressort un tableau nommé hvb.csv
        #ORDRE DANS LE HBV.CSV
        #HV-B Station;Company;Individual;Capacity;Load
        #  1            2          3          4       5

        #Lance une nouvelle boucle dans laquelle on regarde un nouvelle argument qui peut etre l'un des suivant COMPANY / INDIVIDUAL / ALL
        for arg in "$@"; do
            case "$arg" in
            -comp)
                echo "Exécution du tri selon la colonne Company"
                cut -d';' -f1,2,4,5 hvb.csv | sort -n -t';' -k1 >temp_hvb_comp.csv
                echo "Le tri selon la colonne Station HVB et selon la company a été exécuté"
                #manque le calcul pour permettre de voir combien chaque HVB a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace à la commande awk
                ;;

            -indiv)
                echo "Cette commande ne peut pas être appliqué"
                exit 1
                ;;
            -all)
                echo "Cette commande ne peut pas être appliqué"
                exit 1
                ;;
            esac
        done
        ;;

    -hva)
        echo "Exécution du tri selon la colonne Station HVA"
        cut -d';' -f3,5,6,7,8 c-wire.csv | sort -n -t';' -k1 >hva.csv
        echo "Le tri selon la colonne Station HVA a été exécuté"

        # lance la commande associé au fait de prendre que les colonnes suivantes  HVA / COMPANY / INDIVIDUAL / CAPACITY / LOAD et ressort un tableau nommé hva.csv
        #ORDRE DANS LE HVA.CSV
        #HV-A Station;Company;Individual;Capacity;Load
        #  1            2          3          4       5

        #Lance une nouvelle boucle dans laquelle on regarde un nouvelle argument qui peut etre l'un des suivant COMPANY / INDIVIDUAL / ALL
        for arg in "$@"; do
            case "$arg" in
            -comp)
                echo "Exécution du tri selon la colonne Company"
                cut -d';' -f1,2,4,5 hva.csv | sort -n -t';' -k1 >temp_hva_comp.csv
                echo "Le tri selon la colonne Station HVA et selon la company a été exécuté"
                #manque le calcul pour permettre de voir combien chaque HVA a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace à la commande awk
                ;;
            -indiv)
                echo "Cette commande ne peut pas être appliqué"
                exit 1
                ;;
            -all)
                echo "Cette commande ne peut pas être appliqué"
                exit 1
                ;;
            esac
        done
        ;;

    -lv)
        echo "Exécution du tri selon la colonne Station LV"
        cut -d';' -f4,5,6,7,8 c-wire.csv | sort -n -t';' -k1 >lv.csv
        echo "Le tri selon la colonne Station LV a été exécuté"
        # lance la commande associé au fait de prendre que les colonnes suivantes  LV / COMPANY / INDIVIDUAL / CAPACITY / LOAD et  ressort un tableau nommé lv.csv
        #ORDRE DANS LE LV.CSV
        #LV Station;Company;Individual;Capacity;Load
        #  1            2          3          4       5

        #Lance une nouvelle boucle dans laquelle on regarde un nouvelle argument qui peut etre l'un des suivant COMPANY / INDIVIDUAL / ALL
        for arg in "$@"; do
            case "$arg" in
            -comp)
                echo "Exécution du tri selon la colonne Company"
                cut -d';' -f1,2,4,5 lv.csv | sort -n -t';' -k1 >temp_lv_comp.csv
                echo "Le tri selon la colonne Station HVA et selon la company a été exécuté"
                #manque le calcul pour permettre de voir combien chaque LV a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace à la commande awk
                ;;
            -indiv)
                echo "Exécution du tri selon la colonne Individual"
                cut -d';' -f1,3,4,5 lv.csv | sort -n -t';' -k1 >temp_lv_indiv.csv
                echo "Le tri selon la colonne Station HVA et selon la colonne individual a été exécuté"
                #manque le calcul pour permettre de voir combien chaque LV a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace à la commande awk
                ;;
            -all)
                echo "Exécution du tri selon la colonne Individual"
                cut -d';' -f1,2,3,4,5 lv.csv | sort -n -t';' -k1 >temp_lv_all.csv
                #manque le calcul pour permettre de voir combien chaque LV a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace au programme C
                ;;
            esac
        done
        ;;

    *)
        echo "Argument inconnu : $arg"
        ;; # Cas où on prends un autre arguments en paramètres cela ressort un message d'erreur
    esac
done

# Calcul et affichage du temps écoulé
end_time=$(date +%s.%s)
elapsed_time=$(echo "$end_time - $start_time" | bc)
echo "Temps écoulé : $elapsed_time secondes"

#Execution du programme C

# Nom du fichier source C et de l'executable
fichier_source="c_wire.c"
executable="c_wire"

# Compilation
gcc -o $executable $fichier_source
if [ $? -ne 0 ]; then
    echo "Erreur : Échec de la compilation"
    exit 1
fi

#Les arguments devront etre le fichier, la station choisi etc...
arg1=3
arg2=5
arg3=7

output=$(./$executable $arg1 $arg2 $arg3)
code_return=$?

# Verifier la sortie
if [ $code_return -eq 0 ]; then
    echo "Le calcul a réussi. Résultat : $output"
else
    echo "Erreur : Le programme a échoué avec le code $code_return."
fi

main() {
    echo "Hello wolrd!"
}

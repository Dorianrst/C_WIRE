#!/bin/bash

file_path=$(find .. -iname "data.csv") 2>/dev/null                                                                                      #Cette ligne de commande permet de chercher le fichier c-wire.csv dans mes dossiers

Graphs_path=$(find . -type d -name "Graphs" -print -quit) 2>/dev/null                                                                   #Cette ligne de commande permet de chercher si le dosier Graphs dans mes dossiers

Temps_path=$(find . -type d -name "Temp" -print -quit) 2>/dev/null                                                                      #Cette ligne de commande permet de chercher le dossier Temps dans mes dossiers


chmod 777 c-wire.sh

# Dans cette conditions je vérifie si le fichier c-wire.csv existe bien dans mes dossiers
if [ -e "$file_path" ]; then
 echo "le fichier data.csv existe"
 echo "$file_path"
fi

# Dans cette condition je vérifie si le dossier Graphs existe bien dans mes dossiers si il existe je le vide grace à la commande rm - r s'il n'existe pas je le créer via la commandes mkdir -p
if [ -n "$Graphs_path" ]; then
  echo "Le dossier Images existe et il va etre vidé"
  rm -r "$Graphs_path"/*
  echo " Le dossier a été vidé"
else
  echo "Le dossier Graphs n'existe pas et il va être créer"
  mkdir -p "Graphs"
fi

# Dans cette condition je vérifie si le dossier Temps existe bien dans mes dossiers si il existe je le vide grace à la commande rm - r s'il n'existe pas je le créer via la commandes mkdir -p
if [ -n "$Temps_path" ]; then
  echo "Le dossier Temps existe et il va etre vidé"
  rm -r "$Temps_path"/*
  echo " Le dossier a été vidé"
else
  echo "Le dossier Temps n'existe pas et il va être créer"
  mkdir -p "Temps"
fi

# Initialisation de la variable start_time pour le calcul du temps d'exécution
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
for arg in "$@"
do 
  case "$arg" in
    -hvb) 
        echo "Exécution du tri selon la colonne Station HVB"
        cut -d';' -f2,5,6,7,8 c-wire.csv | sort -n -t';' -k1 > hvb.csv
        echo "Le tri selon la colonne Station HVB a été exécuté"

        #Lance la commande associé au fait de prendre que les colonnes suivantes  HVB / COMPANY / INDIVIDUAL / CAPACITY / LOAD et ressort un tableau nommé hvb.csv 
        #ORDRE DANS LE HBV.CSV
        #HV-B Station;Company;Individual;Capacity;Load
        #  1            2          3          4       5

        #Lance une nouvelle boucle dans laquelle on regarde un nouvelle argument qui peut etre l'un des suivant COMPANY / INDIVIDUAL / ALL
            for arg in "$@"
                do 
                    case "$arg" in
                    -comp) 
                        echo "Exécution du tri selon la colonne Company"
                        cut -d';' -f1,2,4,5 hvb.csv | sort -n -t';' -k1 > temp_hvb_comp.csv
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
        cut -d';' -f3,5,6,7,8 c-wire.csv | sort -n -t';' -k1 > hva.csv
        echo "Le tri selon la colonne Station HVA a été exécuté"
        
        # lance la commande associé au fait de prendre que les colonnes suivantes  HVA / COMPANY / INDIVIDUAL / CAPACITY / LOAD et ressort un tableau nommé hva.csv 
        #ORDRE DANS LE HVA.CSV
        #HV-A Station;Company;Individual;Capacity;Load
        #  1            2          3          4       5

        #Lance une nouvelle boucle dans laquelle on regarde un nouvelle argument qui peut etre l'un des suivant COMPANY / INDIVIDUAL / ALL
            for arg in "$@"
                do 
                    case "$arg" in
                    -comp) 
                        echo "Exécution du tri selon la colonne Company"
                        cut -d';' -f1,2,4,5 hva.csv | sort -n -t';' -k1 > temp_hva_comp.csv
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
        cut -d';' -f4,5,6,7,8 c-wire.csv | sort -n -t';' -k1 > lv.csv
        echo "Le tri selon la colonne Station LV a été exécuté"
        # lance la commande associé au fait de prendre que les colonnes suivantes  LV / COMPANY / INDIVIDUAL / CAPACITY / LOAD et  ressort un tableau nommé lv.csv
        #ORDRE DANS LE LV.CSV
        #LV Station;Company;Individual;Capacity;Load
        #  1            2          3          4       5

        #Lance une nouvelle boucle dans laquelle on regarde un nouvelle argument qui peut etre l'un des suivant COMPANY / INDIVIDUAL / ALL
            for arg in "$@"
                do 
                    case "$arg" in
                    -comp) 
                        echo "Exécution du tri selon la colonne Company"
                        cut -d';' -f1,2,4,5 lv.csv | sort -n -t';' -k1 > temp_lv_comp.csv
                        echo "Le tri selon la colonne Station HVA et selon la company a été exécuté"
                        #manque le calcul pour permettre de voir combien chaque LV a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace à la commande awk 
                        ;;
                    -indiv) 
                        echo "Exécution du tri selon la colonne Individual"
                        cut -d';' -f1,3,4,5 lv.csv | sort -n -t';' -k1 > temp_lv_indiv.csv
                        echo "Le tri selon la colonne Station HVA et selon la colonne individual a été exécuté"
                         #manque le calcul pour permettre de voir combien chaque LV a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace à la commande awk
                        ;;
                    -all) 
                        echo "Exécution du tri selon la colonne Individual"
                        cut -d';' -f1,2,3,4,5 lv.csv | sort -n -t';' -k1 > temp_lv_all.csv
                        #manque le calcul pour permettre de voir combien chaque LV a pour capacité de production et combien les entreprises utilises dans cette productions ce fait grace au programme C
                        ;;
                    esac
                done 
      ;; 


    *)
      echo "Argument inconnu : $arg"
      ;;  # Cas où on prends un autre arguments en paramètres cela ressort un message d'erreur 
  esac
done

# Calcul et affichage du temps écoulé
end_time=$(date +%s.%s) 
elapsed_time=$(echo "$end_time - $start_time" | bc)
echo "Temps écoulé : $elapsed_time secondes"
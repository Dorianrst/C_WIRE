#!/bin/bash

# Fonction d'affichage de l'aide
afficher_aide() {
    echo "Utilisation : c-wire.sh <chemin_fichier> <type_station> <type_consommateur> [id_centrale] [-h]"
    echo "Paramètres :"
    echo "  <chemin_fichier>       Chemin du fichier CSV contenant les données (obligatoire)"
    echo "  <type_station>         Type de station à traiter (obligatoire) : hvb, hva, lv"
    echo "  <type_consommateur>    Type de consommateur à traiter (obligatoire) : comp, indiv, all"
    echo "                         Restrictions :"
    echo "                         - hvb accepte uniquement 'comp'"
    echo "                         - hva accepte uniquement 'comp'"
    echo "  [id_centrale]          (Optionnel) Identifiant de centrale pour filtrer les résultats"
    echo "  -h                     (Optionnel) Affiche cette aide et ignore tous les autres paramètres"
    echo ""
    echo "Exemple : c-wire.sh donnees.csv hvb comp 1234"
    exit 0
}

# Vérification de l'option d'aide
if [[ "$@" =~ "-h" ]]; then
    afficher_aide
fi

# Vérification du nombre minimum de paramètres
if [ "$#" -lt 3 ]; then
    echo "Erreur : Nombre de paramètres insuffisant."
    afficher_aide
fi






# Assignation des paramètres
chemin_fichier=$1
type_station=$2
type_consommateur=$3
id_centrale=${4:-""} # Optionnel, vide par défaut




# Vérification de l'existence du fichier
if [ ! -f "$chemin_fichier" ]; then
    echo "Erreur : Le fichier spécifié n'existe pas : $chemin_fichier"
    exit 1
fi

# Vérification des valeurs des paramètres
case "$type_station" in
    hvb|hva|lv) ;; # Valeurs valides
    *)
        echo "Erreur : Type de station invalide. Valeurs possibles : hvb, hva, lv"
        exit 1
        ;;
esac

case "$type_consommateur" in
    comp|indiv|all) ;; # Valeurs valides
    *)
        echo "Erreur : Type de consommateur invalide. Valeurs possibles : comp, indiv, all"
        exit 1
        ;;
esac

# Vérification des combinaisons interdites
if [[ "$type_station" == "hvb" && "$type_consommateur" != "comp" ]] ||
   [[ "$type_station" == "hva" && "$type_consommateur" != "comp" ]]; then
    echo "Erreur : Combinaison de station et de consommateur invalide."
    exit 1
fi

# Traitement des données
echo "Traitement en cours..."
echo "Fichier : $chemin_fichier"
echo "Type de station : $type_station"
echo "Type de consommateur : $type_consommateur"
if [ -n "$id_centrale" ]; then
    echo "Identifiant de centrale : $id_centrale"
else
    echo "Aucun identifiant de centrale spécifié, traitement sur toutes les centrales."
fi

# Exemple de traitement (filtrage des données)
awk -F',' -v station="$type_station" -v consommateur="$type_consommateur" -v centrale="$id_centrale" '
BEGIN { print "Station,Consommateur,Centrale" }
$2 == station && $3 == consommateur && (centrale == "" || $4 == centrale) {
    print $0
}' "$chemin_fichier"
set terminal pngcairo size 1280,720 enhanced font 'Arial,12'  # Graphique en haute résolution
set output 'Graphs/graphique_image_corrected.png'            # Nom du fichier de sortie

set boxwidth 0.5 relative  # Largeur des barres ajustée
set style fill solid 0.7 border -1  # Barres semi-transparentes 

# Titre et axes du graphique
set title "Graphique à barres - Répartition des Capacités et Charges" font "Arial Bold,16"
set xlabel "Numéro de stations" font "Arial,14"
set ylabel "Load (kWh)" font "Arial,14"  # Axe Y avec l'unité kWh

# Configuration de la grille
set grid ytics lc rgb "#d0d0d0" lw 1  # Grille Y discrète

# Légende améliorée
set key outside right top box lt rgb "gray" spacing 1.5  # Position sur la droite avec espacement
set key font "Arial,12"  # Police plus lisible pour la légende

# Personnalisation des couleurs des barres
set style line 1 lc rgb "#4682b4" lt 1 lw 1  # Bleu pour Capacité
set style line 2 lc rgb "#ff6347" lt 1 lw 1  # Rouge pour Load

# Rotation des étiquettes sur l'axe X
set xtics rotate by -45 font "Arial,10"  # Rotation pour éviter les chevauchements
set bmargin 5  # Ajout de marge supplémentaire en bas pour les étiquettes

# Type de graphique : histogrammes empilés
set style data histograms
set style histogram rowstacked  # Les barres sont empilées

# Format des données CSV
set datafile separator ":"  # Séparateur par point

# Indiquer des légendes pour les colonnes
set key autotitle columnheader

# Tracer les données (en tenant compte de l'ordre donné : numero, capacity, load)

plot 'Graphs/graphique.csv' using 2:xtic(1) title "Capacité (kWh)" with boxes ls 1, \
     '' using 3 title "Load (kWh)" with boxes ls 2


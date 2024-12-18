set terminal pngcairo  # Pour générer un graphique en PNG
set output 'Graphs\bar_chart2.png'  # Nom du fichier de sortie
set boxwidth 0.5 relative  # Largeur des barres
set style fill solid 0.6  # Style de remplissage des barres
set title "Graphique à barres des charges par station"  # Titre du graphique
set xlabel "Station HVA"  # Légende de l'axe des X
set ylabel "Load"  # Légende de l'axe des Y
set grid ytics  # Activer la grille sur l'axe Y

# Tracer le graphique à barres
plot 'HVA.dat' using 1:2 with boxes title 'Charge'

#include "fonctions.h"


int main(int argc, char *argv[]) {

    // Affichage de l'ASCII Art en rouge
    printf("\033[1;31m"); // Rouge en gras
    printf(" .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. \n");
    printf("| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\n");
    printf("| |     ______   | || |              | || | _____  _____ | || |     _____    | || |  _______     | || |  _________   | |\n");
    printf("| |   .' ___  |  | || |              | || ||_   _||_   _|| || |    |_   _|   | || | |_   __ \\    | || | |_   ___  |  | |\n");
    printf("| |  | |         | || |              | || |  | |/  \\| |  | || |      | |     | || |   |  __ /    | || |   |  _|  _   | |\n");
    printf("| |  \\ `.___.'\\  | || |              | || |  |   /\\   |  | || |     _| |_    | || |  _| |  \\ \\_  | || |  _| |___/ |  | |\n");
    printf("| |   `._____.`  | || |   _______    | || |  |__/  \\__|  | || |    |_____|   | || | |____| |___| | || | |_________|  | |\n");
    printf("| |              | || |  |_______|   | || |              | || |              | || |              | || |              | |\n");
    printf("| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\n");
    printf(" '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \n");
    printf("\033[0m"); // Réinitialiser les couleurs

    
    clock_t start, end;
    double cpu_time_used;
    start = clock();  // Démarrer le chronomètre

    FILE* file;
    char line[256];
    // strcpy( fullName, firstName );
    char file_address[256];
    strcpy(file_address, "Input/");
    strcat(file_address, argv[1]);

    char *cpp, *chvb, *chva, *clv, *ccomp, *cindiv, *ccapa, *cload;
    

    int pp, hvb, hva, lv, comp, indiv, capa, load;
    char* station = argv[2];
    char* type = argv[3];

    int choice_pp = atoi(argv[4]);

    if(choice_pp < 0 || choice_pp > 5){
        choice_pp = 0;
    }

    
    
    Avl* tree = NULL;
    
    
    // Open the file
    file = fopen(file_address, "r");
    if (file == NULL) {
        printf("Error while opening file\n");
        exit(2);
    }

    fgets(line, sizeof(line), file); // Pour passer la première ligne du document

    // read each line
    while (fgets(line, sizeof(line), file)) {

        // delete line jump
        line[strcspn(line, "\n")] = '\0';

        // cut each string with ';'
        cpp = strtok(line, ";");
        chvb = strtok(NULL, ";");
        chva = strtok(NULL, ";");
        clv = strtok(NULL, ";");
        ccomp = strtok(NULL, ";");
        cindiv = strtok(NULL, ";");
        ccapa = strtok(NULL, ";");
        cload = strtok(NULL, ";");
        //printf("%s %s %s %s %s %s %s %s\n", cpp, chvb, chva, clv, ccomp, cindiv, ccapa, cload);
        tree = buildAvl(tree, station, type, choice_pp, cpp, chvb, chva, clv, ccomp, cindiv, ccapa, cload);
    }
    
    FILE* csvFile;

    char csv_address[256];
    strcpy(csv_address, "tests/");
    strcat(csv_address, argv[2]);
    strcat(csv_address, "_");
    strcat(csv_address, argv[3]);
    strcat(csv_address, "_");
    strcat(csv_address, argv[4]);
    strcat(csv_address, ".csv");

    // Ouvrir un fichier CSV pour l'écriture
    csvFile = fopen(csv_address, "w");
    if (csvFile == NULL) {
        fprintf(stderr, "Erreur : impossible de créer le .csv\n");
        return EXIT_FAILURE;
    }

    // Écrire l'en-tête du fichier CSV
    fprintf(csvFile, "Station ID:Capacity:Load\n");
    // Parcourir l'AVL et écrire les données dans le CSV
    writeAVLToCsv(tree, csvFile);
    // Fermer le fichier CSV
    fclose(csvFile);




    // On créer un 2e fichier un peu différent afin de créer les graphiques plus tard
    FILE* csvGraph;

    // Ouvrir un fichier CSV pour l'écriture
    csvGraph = fopen("Graphs/graphique.csv", "w");
    if (csvGraph == NULL) {
        fprintf(stderr, "Erreur : impossible de créer le graph.csv\n");
        return EXIT_FAILURE;
    }

    // Parcourir l'AVL et écrire les données dans le CSV
    writeAVLForGraph(tree, csvGraph);
    // Fermer le fichier écrit pour les Graphiques
    fclose(csvGraph);



    // close the principal file
    fclose(file);

    printf("Les données ont été exportées avec succès dans output.csv\n");
    freeAVL(tree);

    return EXIT_SUCCESS;
}

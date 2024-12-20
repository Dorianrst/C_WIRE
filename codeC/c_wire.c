#include "fonctions.h"

int main(int argc, char *argv[])
{

    // ASCII Art displayed in red
    printf("\033[1;31m"); // Rouge en gras
    printf(" .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. \n");
    printf("| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\n");
    printf("| |     ______   | || |              | || | _____  _____ | || |     _____    | || |  _______     | || |  _________   | |\n");
    printf("| |   .' ___  |  | || |              | || ||_   _||_   _|| || |    |_   _|   | || | |_   __ \\    | || | |_   ___  |  | |\n");
    printf("| |  / .'   \\_|  | || |              | || |  | | /\\ | |  | || |      | |     | || |   | |__) |   | || |   | |_  \\_|  | |\n");
    printf("| |  | |         | || |              | || |  | |/  \\| |  | || |      | |     | || |   |  __ /    | || |   |  _|  _   | |\n");
    printf("| |  \\ `.___.'\\  | || |              | || |  |   /\\   |  | || |     _| |_    | || |  _| |  \\ \\_  | || |  _| |___/ |  | |\n");
    printf("| |   `._____.`  | || |   _______    | || |  |__/  \\__|  | || |    |_____|   | || | |____| |___| | || | |_________|  | |\n");
    printf("| |              | || |  |_______|   | || |              | || |              | || |              | || |              | |\n");
    printf("| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\n");
    printf(" '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \n");
    printf("\033[0m"); // Reset colours


    FILE *file;
    char line[256];
    // strcpy( fullName, firstName );
    char file_address[256];
    strcpy(file_address, "Input/");
    strcat(file_address, argv[1]);

    char *cpp, *chvb, *chva, *clv, *ccomp, *cindiv, *ccapa, *cload;

    // Argument Checking
	if(argc < 4 || argc > 5){
		printf("There are not the right number of arguments.\n");
        return 1;
	}
	char* station = argv[2];
    checkStation(station);
	
    char* type = argv[3];
    checkType(type, station);
    
    int choice_pp = checkChoicePp(argv[4], choice_pp);

    Avl *tree = NULL;

    // Open the file
    file = fopen(file_address, "r");
    if (file == NULL)
    {
        printf("Error while opening file\n");
        return 3;
    }

    fgets(line, sizeof(line), file); //  To skip the first line of the document
    // read each line
    while (fgets(line, sizeof(line), file))
    {

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
        // printf("%s %s %s %s %s %s %s %s\n", cpp, chvb, chva, clv, ccomp, cindiv, ccapa, cload);
        tree = buildAvl(tree, station, type, choice_pp, cpp, chvb, chva, clv, ccomp, cindiv, ccapa, cload);
    }

    // We sort a new tree by capacity to write the file later
    Avl* newTree = NULL;
    newTree = sortAvlByCapacity(tree, newTree); // Remplir le nouvel arbre

    FILE *csvFile;

    // We write the name of the future document with the arguments
    char csv_address[256];
    strcpy(csv_address, "tests/");
    strcat(csv_address, station);
    strcat(csv_address, "_");
    strcat(csv_address, type);
    if(choice_pp != 0){
    	strcat(csv_address, "_");
    	strcat(csv_address, argv[4]);
    }
    strcat(csv_address, ".csv");

    // Open a CSV file for writing
    csvFile = fopen(csv_address, "w");
    if (csvFile == NULL)
    {
        printf("Error: unable to create .csv file\n");
        return 4;
    }

    // Write the CSV file header
    fprintf(csvFile, "Station ID:Capacity:Load, Stations are sorted by capacity in ascending order\n");
    // Browse the AVL and write the data to the CSV
    writeAVLToCsv(newTree, csvFile);
    // Close CSV file
    fclose(csvFile);


    /*
    Ce code n'est pas exécuter car non fonctionnel et non terminé
    Il correspond à la création du fichier lv_all_minmax.csv

    // Allocation des tableaux pour les résultats
    const int maxResults = 10;
    ResultNode minArray[maxResults];
    ResultNode maxArray[maxResults];
    int minSize = 0;
    int maxSize = 0;

    // Trouver les ratios extrêmes
    findExtremeRatios(tree, minArray, &minSize, maxArray, &maxSize, maxResults);

    // Écrire les résultats dans un fichier CSV
    writeResultsToCsv("tests/lv_all_minmax.csv", minArray, maxArray, minSize, maxSize);

    printf("Résultats écrits dans tests/lv_all_minmax.csv\n");
    */


    // Create a 2nd, slightly different file to create the graphics later.
    FILE *csvGraph;

    // Open a CSV file for writing
    csvGraph = fopen("Graphs/graphique.csv", "w");
    if (csvGraph == NULL)
    {
        printf("Error: unable to create graph.csv file\n");
        return 5;
    }

    
    fprintf(csvFile, "Station ID:Capacity:Load, Stations are sorted by capacity in ascending order\n");
    // Browse the AVL and write the data to the CSV
    writeAVLToCsv(tree, csvGraph); // We use the non sorted AVL for the graphics
    // Close the file written for Graphics
    fclose(csvGraph);

    // close the principal file
    fclose(file);

    printf("The data has been successfully exported to %s\n", csv_address);
    freeAVL(tree);
    freeAVL(newTree);

    return 0;
}


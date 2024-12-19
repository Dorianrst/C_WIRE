#include "fonctions.h"

int main(int argc, char *argv[])
{

    // ASCII Art displayed in red
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
    printf("\033[0m"); // Reset colours

    clock_t start, end;
    double cpu_time_used;
    start = clock(); // Start the stopwatch

    FILE *file;
    char line[256];
    // strcpy( fullName, firstName );
    char file_address[256];
    strcpy(file_address, "Input/");
    strcat(file_address, argv[1]);

    char *cpp, *chvb, *chva, *clv, *ccomp, *cindiv, *ccapa, *cload;

    int pp, hvb, hva, lv, comp, indiv, capa, load;
    char *station = argv[2];
    char *type = argv[3];

    int choice_pp = atoi(argv[4]);

    if (choice_pp < 0 || choice_pp > 5)
    {
        choice_pp = 0;
    }

    Avl *tree = NULL;

    // Open the file
    file = fopen(file_address, "r");
    if (file == NULL)
    {
        printf("Error while opening file\n");
        exit(2);
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

    FILE *csvFile;

    char csv_address[256];
    strcpy(csv_address, "tests/");
    strcat(csv_address, argv[2]);
    strcat(csv_address, "_");
    strcat(csv_address, argv[3]);
    strcat(csv_address, "_");
    strcat(csv_address, argv[4]);
    strcat(csv_address, ".csv");

    // Open a CSV file for writing
    csvFile = fopen(csv_address, "w");
    if (csvFile == NULL)
    {
        fprintf(stderr, "Error: unable to create .csv file\n");
        return EXIT_FAILURE;
    }

    // Write the CSV file header

    fprintf(csvFile, "Station ID:Capacity:Load\n");
    // Browse the AVL and write the data to the CSV
    writeAVLToCsv(tree, csvFile);
    // Close CSV file
    fclose(csvFile);

    // Create a 2nd, slightly different file to create the graphics later.

    FILE *csvGraph;

    // Open a CSV file for writing
    csvGraph = fopen("Graphs/graphique.csv", "w");
    if (csvGraph == NULL)
    {
        fprintf(stderr, "Error: unable to create graph.csv file\n");
        return EXIT_FAILURE;
    }

    // Browse the AVL and write the data to the CSV
    writeAVLForGraph(tree, csvGraph);
    // Close the file written for Graphics
    fclose(csvGraph);

    // close the principal file
    fclose(file);

    printf("The data has been successfully exported to output.csv\n");
    freeAVL(tree);

    return EXIT_SUCCESS;
}

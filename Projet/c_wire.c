#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


typedef struct Avl{
    struct Avl *leftSon;
    struct Avl *rightSon;
    int balance;
    long capacity;
    int id;
    long load;
}Avl;



int min(int a, int b) {
    return (a < b) ? a : b;
}

int max(int a, int b) {
    return (a > b) ? a : b;
}


int max3(int a, int b, int c) {
    return (a > b) ? (a > c ? a : c) : (b > c ? b : c);
}

int min3(int a, int b, int c) {
    return (a < b) ? (a < c ? a : c) : (b < c ? b : c);
}

Avl* createNode(){
    Avl* new = malloc(sizeof(Avl));
    if (new==NULL){
        printf("Memory allocation failed");
        exit(1);
    }
    new->leftSon = NULL;
    new->rightSon = NULL;
    new->balance = 0;
    new->capacity = 0;
    new->id = 0;
    new->load = 0;
    return new;
}

Avl* createAVL(long capacity, int id){
    Avl* new = createNode();
    new->capacity = capacity;
    new->id = id;
    return new;
}

// Get the height of a node
int getBalance(Avl* node) {
    if (node == NULL) {
        return 0;
    }
    return node->balance;
}


// Perform a right rotation
Avl* rotateRight(Avl* node) {
    Avl* pivot = node->leftSon;
    int balance_node = node->balance;
    int balance_pivot = pivot->balance;

    node->leftSon = pivot->rightSon;
    pivot->rightSon = node;

    node->balance = balance_node - min(balance_pivot, 0) + 1;
    pivot->balance = max3(balance_node + 2, balance_node + balance_pivot + 2, balance_pivot + 1);

    return pivot;

}

// Perform a left rotation
Avl* rotateLeft(Avl* node) {
    Avl* pivot = node->rightSon;
    int balance_node = node->balance;
    int balance_pivot = pivot->balance;

    node->rightSon = pivot->leftSon;
    pivot->leftSon = node;

    node->balance = balance_node - max(balance_pivot, 0) - 1;
    pivot->balance = min3(balance_node - 2, balance_node + balance_pivot - 2, balance_pivot - 1);

    return pivot;
}

Avl* doubleRotateLeft(Avl* node){
    node->rightSon = rotateRight(node->rightSon);
    return rotateLeft(node);
}

Avl* doubleRotateRight(Avl* node){
    node->leftSon = rotateLeft(node->leftSon);
    return rotateRight(node);
}




Avl* equilibrerAVL(Avl* a){
    if (a->balance >= 2){ // Cas où l'arbre est déséquilibré à droite
        if (a->rightSon->balance >= 0){
            return rotateLeft(a); // Rotation simple gauche
        }
        else{
            return doubleRotateLeft(a); // Double rotation gauche
        }
    }
    else if (a->balance <= -2){ // Cas où l'arbre est déséquilibré à gauche
        if (a->leftSon->balance <= 0){
            return rotateRight(a); // Rotation simple droite
        }
        else{
            return doubleRotateRight(a); // Double rotation droite
        }
    }
    return a; // Aucun rééquilibrage nécessaire
}



Avl* insertAVL(Avl* a, long capacity, int id,  int *h){
    if (a == NULL){           // Si l'arbre est vide, crée un nouveau nœud
        *h = 1; // La hauteur a augmenté
        return createAVL(capacity, id);
    }
    else if (id < a->id){ // Si l'élément est plus petit, insérer à gauche
        a->leftSon = insertAVL(a->leftSon, capacity, id, h);
        *h = -*h; // Inverse l'impact de la hauteur
    }
    else if (id > a->id){ // Si l'élément est plus grand, insérer à droite
        a->rightSon = insertAVL(a->rightSon, capacity, id, h);
    }
    else{ // Élément déjà présent
        *h = 0;
        return a;
    }
    // Mise à jour du facteur d'équilibre et rééquilibrage si nécessaire
    if (*h != 0)
    {
        a->balance += *h;
        a = equilibrerAVL(a);
        if(a->balance == 0){
            *h = 0;
        }else{
            *h = 1;
        }
    }
    return a;
}







void printAVL(Avl* node) {
    if (node != NULL){
        printAVL(node->leftSon);
        printf("Station %d, capacity = %lu, load = %lu\n", node->id, node->capacity, node->load);
        printAVL(node->rightSon);
    }
}

//======================================= PROCESS WHILE MAKEFILE NOT MADE ===================================


int research(Avl* node, int id, Avl** searched){
    if (node==NULL){
        return 0;
    }
    if (node->id == id){
        *searched = node;
        return 1;
    }
    if (node->id > id){
        return research(node->leftSon, id, searched);
    }
    if (node->id < id){
        return research(node->rightSon, id, searched);
    }
}


void updateStation(Avl* tree, long load, int id){
    Avl* station;
    int result = research(tree, id, &station);
    
    if(!result){
                return;
    }

    station->load += load;
}




Avl* buildAvl(Avl* tree, char* station, char *chvb, char *chva, char *clv, char *ccomp, char *cindiv, char *ccapa, char *cload){
    int ph = 0;
    int* h = &ph;

    if (strcmp("hvb", station) == 0){
        // Si c'est un hvb qui ne donne a personne
        if (strcmp("-", chvb) != 0 && strcmp("-", chva) == 0 && strcmp("-", ccapa) != 0){
            // On insert la station dans l'arbre
            tree = insertAVL(tree, atol(ccapa), atoi(chvb), h);
        }
        // On verifie que les cases company et load sont bien remplies
        else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0 && strcmp("-", chvb) != 0){
            // On ajoute la consommation en plus a la station
            updateStation(tree, atol(cload), atoi(chvb));
        }
    }
    
    
    /*
    if(isLv){

        if (strcmp("-", ccomp) || strcmp("-", cindiv)){ // this is a consumer
            updateStation(tree, atoi(clv), atol(cload));
        }else{ // this is a lv station
            tree = insertAVL(tree, atol(ccapa), &h, atol(clv));
        }
    }else if(isHva){
        if (strcmp("-", ccomp) || strcmp("-", cindiv)){ // this is a consumer
            updateStation(tree, atoi(chva), atol(cload));
        }
        else if(strcmp("-", clv)){ // this is a lv station
            updateStation(tree, atoi(chva), atol(ccapa));
        }
        else{ // this is a hva station
            tree = insertAVL(tree, atol(ccapa), &h, atol(chva));
        }
    }else if(isHvb){
        if (strcmp("-", ccomp) || strcmp("-", cindiv)){ // this is a consumer
            updateStation(tree, atoi(chvb), atol(cload));
        }
        else if(strcmp("-", clv) || strcmp("-", chva)){ // this is a lv or hva
            updateStation(tree, atoi(chvb), atol(ccapa));
        }else{ // this is a hvb station
            tree = insertAVL(tree, atol(ccapa), &h, atol(chvb));
        }
    }
    */
    
    return tree;
}



int main(int argc, char *argv[]) {
    FILE* file;
    char line[256];
    char* file_address = "c-wire_v00.dat";
    char *cpp, *chvb, *chva, *clv, *ccomp, *cindiv, *ccapa, *cload;
    
    int pp, hvb, hva, lv, comp, indiv, capa, load;
    
    char* station = argv[1];
    station = "hvb";
    // Faire un case{} pour vérifier que station contient soit hvb hva ou lv
    
    Avl* tree = NULL;
    
    
    // Open the file
    file = fopen(file_address, "r");
    if (file == NULL) {
        printf("Error while opening file\n");
        exit(2);
    }
    
    fgets(line, sizeof(line), file);
    line[strcspn(line, "\n")] = '\0';
    cpp = strtok(line, ";");
    chvb = strtok(NULL, ";");
    chva = strtok(NULL, ";");
    clv = strtok(NULL, ";");


    rewind(file);
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

        tree = buildAvl(tree, station, chvb, chva, clv, ccomp, cindiv, ccapa, cload);
    }


    printAVL(tree);
    // close the file
    fclose(file);
    return EXIT_SUCCESS;
}
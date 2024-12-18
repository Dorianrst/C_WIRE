#include "fonctions.h"



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




// Fonction pour écrire un nœud dans le fichier CSV
void writeToCsv(FILE *csvFile, int id, long capacity, long load) {
    fprintf(csvFile, "%d:%lu:%lu\n", id, capacity, load);
}

// Fonction pour parcourir l'AVL et écrire dans un fichier CSV
void writeAVLToCsv(Avl *node, FILE *csvFile) {
    if (node != NULL) {
        // Ecriture récursive des nœuds gauche
        writeAVLToCsv(node->leftSon, csvFile);

        // Ecriture du nœud courant
        writeToCsv(csvFile, node->id, node->capacity, node->load);

        // Ecriture récursive des nœuds droit
        writeAVLToCsv(node->rightSon, csvFile);
    }
}




void writeForGraph(FILE *csvFile, int id, long load) {
    fprintf(csvFile, "%d, %lu\n", id, load); // Format : id:load
}

void writeAVLForGraph(Avl* node, FILE* csvFile) {
    if (node != NULL) {
        // Ecriture récursive des nœuds gauche
        writeAVLForGraph(node->leftSon, csvFile);

        // Ecriture du nœud courant (ID + Load seulement)
        writeForGraph(csvFile, node->id, node->load);

        // Ecriture récursive des nœuds droit
        writeAVLForGraph(node->rightSon, csvFile);
    }
}



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




Avl* buildAvl(Avl* tree, char* station, char* type, int choice_pp, char* cpp, char *chvb, char *chva, char *clv, char *ccomp, char *cindiv, char *ccapa, char *cload){
    int ph = 0;
    int* h = &ph;

    if (strcmp("hvb", station) == 0 && !(strcmp("-", chvb) == 0)){
        // Si c'est un hvb qui ne donne a personne
        if (choice_pp == 0 || choice_pp == atoi(cpp)){
            if (strcmp("-", chva) == 0 && strcmp("-", ccapa) != 0){
                // On insert la station dans l'arbre
                tree = insertAVL(tree, atol(ccapa), atoi(chvb), h);
            }
            // On verifie que les cases company et load sont bien remplies
            else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0){
                // On ajoute la consommation en plus a la station
                updateStation(tree, atol(cload), atoi(chvb));
            }
        }
    }
    else if (strcmp("hva", station) == 0 && !(strcmp("-", chva) == 0)){
        if (choice_pp == 0 || choice_pp == atoi(cpp)){
            // Si c'est un hva qui recoit de l'énergie d'un hvb
            if (strcmp("-", chvb) != 0){
                // On insert la station dans l'arbre
                tree = insertAVL(tree, atol(ccapa), atoi(chva), h);
            }
            // On ajoute seulement les hva qui donne à une entreprise
            else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0){
                // On ajoute la consommation en plus a la station
                updateStation(tree, atol(cload), atoi(chva));
            }
        }
    }
    else if (strcmp("lv", station) == 0 && !(strcmp("-", clv) == 0)){
        if (choice_pp == 0 || choice_pp == atoi(cpp)){
            // Si c'est un lv qui recoit de l'énergie d'un hva
            if (strcmp("-", chva) != 0){
                // On insert la station dans l'arbre
                tree = insertAVL(tree, atol(ccapa), atoi(clv), h);
            }
            // Pour rajouter que les entreprises
            else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0 && (strcmp("comp", type) == 0 || strcmp("all", type) == 0)){
                // On ajoute la consommation en plus a la station
                updateStation(tree, atol(cload), atoi(clv));
            }
            // Pour rajouter que les particuliers
            else if (strcmp("-", cload) != 0 && strcmp("-", cindiv) != 0 && (strcmp("indiv", type) == 0 || strcmp("all", type) == 0)){
                // On ajoute la consommation en plus a la station
                updateStation(tree, atol(cload), atoi(clv));
            }
        }
    }

    return tree;
}


// Fonction pour libérer l'arbre AVL
void freeAVL(Avl* node) {
    if (node != NULL) {
        freeAVL(node->leftSon);  // Libérer récursivement le sous-arbre gauche
        freeAVL(node->rightSon); // Libérer récursivement le sous-arbre droit
        free(node);              // Libérer le nœud courant
    }
}


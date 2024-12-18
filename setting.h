#ifndef SETTING_H
#define SETTING_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

// ====== Structure d'un nœud AVL =======
typedef struct Avl {
    struct Avl *leftSon;  // Fils gauche
    struct Avl *rightSon; // Fils droit
    int balance;          // Facteur d'équilibre
    long capacity;        // Capacité de la station
    int id;               // ID de la station
    long load;            // Charge de la station
} Avl;

// ====== Macros Utilitaires =======
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))
#define max3(a, b, c) ((a) > (b) ? ((a) > (c) ? (a) : (c)) : ((b) > (c) ? (b) : (c)))
#define min3(a, b, c) ((a) < (b) ? ((a) < (c) ? (a) : (c)) : ((b) < (c) ? (b) : (c)))

// ====== Prototypes des Fonctions =======

// Rotations AVL
Avl* rotateRight(Avl* node);
Avl* rotateLeft(Avl* node);
Avl* doubleRotateLeft(Avl* node);
Avl* doubleRotateRight(Avl* node);

// Fonctions pour équilibrer l'arbre AVL
Avl* equilibrerAVL(Avl* a);

// Gestion de l'arbre AVL
Avl* createNode();
Avl* createAVL(long capacity, int id);
Avl* insertAVL(Avl* a, long capacity, int id, int *h);
void printAVL(Avl* node);

// Recherche et modification dans l'arbre
int research(Avl* node, int id, Avl** searched);
void updateStation(Avl* tree, long load, int id);

// Construction personnalisée de l'AVL
Avl* buildAvl(Avl* tree, char* station, char* type, int choice_pp, char* cpp, char *chvb, char *chva, char *clv, char *ccomp, char *cindiv, char *ccapa, char *cload);

// Écriture dans un fichier CSV
void writeToCsv(FILE *csvFile, int id, long capacity, long load);
void writeAVLToCsv(Avl *node, FILE *csvFile);

void writeIdAndLoadToCsv(FILE *csvFile, int id, long load);
void writeAVLIdAndLoadToCsv(Avl *node, FILE *csvFile);


#endif // SETTING_H

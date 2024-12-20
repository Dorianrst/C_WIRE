#ifndef FONCTIONS_H
#define FONCTIONS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


typedef struct Avl{
    struct Avl *leftSon;
    struct Avl *rightSon;
    int balance;
    long capacity;
    int id;
    unsigned long load;
}Avl;


int min(int a, int b);
int max(int a, int b);
int max3(int a, int b, int c);
int min3(int a, int b, int c);

Avl* createNode();
Avl* createAVL(long capacity, int id);
int getBalance(Avl* node);
Avl* rotateRight(Avl* node);
Avl* rotateLeft(Avl* node);
Avl* doubleRotateLeft(Avl* node);
Avl* doubleRotateRight(Avl* node);
Avl* equilibrerAVL(Avl* a);
Avl* insertAVL(Avl* a, long capacity, int id,  int *h);
Avl* insertAvlByCapacity(Avl* a, long capacity, long load, int id, int* h);
Avl* sortAvlByCapacity(Avl* tree, Avl* newTree);

void checkStation(char* station);
void checkType(char* type, char* station);
int checkChoicePp(char* arg, int choice_pp);

void writeToCsv(FILE *csvFile, int id, long capacity, long load);
void writeAVLToCsv(Avl *node, FILE *csvFile);
void writeForGraph(FILE *csvFile, int id, long load);
void writeAVLForGraph(Avl* node, FILE* csvFile);

int research(Avl* node, int id, Avl** searched);
void updateStation(Avl* tree, long load, int id);
Avl* buildAvl(Avl* tree, char* station, char* type, int choice_pp, char* cpp, char *chvb, char *chva, char *clv, char *ccomp, char *cindiv, char *ccapa, char *cload);
void freeAVL(Avl* node);

void printAVL(Avl* node);

int main(int argc, char *argv[]);


#endif

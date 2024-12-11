#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct AVL
{
    int id; // Le numero de la station
    char type[3]; // Type de la station (hvb, hva, lv)
    int capacite; // Capacite max de la station
    int consommation; // Somme des consommateurs de la station

    int eq; // Facteur d'equilibre
    struct AVl* fg; // Pointeur vers le fils gauche
    struct AVL* fd; // Pointeur vers le fils droit
} AVL;


AVL* creerAVL(int id, char type[], int capacite){
    AVL* nouveau = (AVL* )malloc(sizeof(AVL));
    if (nouveau == NULL)
    {
        exit(1);
    }

    // Initialisation de toutes les valeurs du noeud
    nouveau->id = id;
    strcpy(nouveau->type, type);
    nouveau->capacite = capacite;
    nouveau->consommation = 0; // La somme des consommations sera ajouter au fur a mesure
    nouveau->fg = NULL;
    nouveau->fd = NULL;
    nouveau->eq = 0;
    return nouveau;
}



int main (int argc, char *argv[]){

    printf("Hello World");


    return 0;
}
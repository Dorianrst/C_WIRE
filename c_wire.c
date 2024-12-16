#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// AVL Tree Node Definition
typedef struct Avl
{
    struct Avl *leftSon;
    struct Avl *rightSon;
    int balance;
    long capacity;
    int id;
    long load;
} Avl;

// Utility Functions
int min(int a, int b) { return (a < b) ? a : b; }
int max(int a, int b) { return (a > b) ? a : b; }
int max3(int a, int b, int c) { return max(a, max(b, c)); }
int min3(int a, int b, int c) { return min(a, min(b, c)); }

// Create a New Node
Avl *createNode()
{
    Avl *newNode = malloc(sizeof(Avl));
    if (!newNode)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    newNode->leftSon = NULL;
    newNode->rightSon = NULL;
    newNode->balance = 0;
    newNode->capacity = 0;
    newNode->id = 0;
    newNode->load = 0;
    return newNode;
}

// Create AVL Tree Node with Capacity and ID
Avl *createAVL(long capacity, int id)
{
    Avl *newNode = createNode();
    newNode->capacity = capacity;
    newNode->id = id;
    return newNode;
}

// Get the Balance Factor of a Node
int getBalance(Avl *node) { return node ? node->balance : 0; }

// Right Rotation
Avl *rotateRight(Avl *node)
{
    Avl *pivot = node->leftSon;
    node->leftSon = pivot->rightSon;
    pivot->rightSon = node;
    node->balance -= 1 + max(0, pivot->balance);
    pivot->balance -= 1 - min(0, node->balance);
    return pivot;
}

// Left Rotation
Avl *rotateLeft(Avl *node)
{
    Avl *pivot = node->rightSon;
    node->rightSon = pivot->leftSon;
    pivot->leftSon = node;
    node->balance += 1 - min(0, pivot->balance);
    pivot->balance += 1 + max(0, node->balance);
    return pivot;
}

// Double Left Rotation
Avl *doubleRotateLeft(Avl *node)
{
    node->rightSon = rotateRight(node->rightSon);
    return rotateLeft(node);
}

// Double Right Rotation
Avl *doubleRotateRight(Avl *node)
{
    node->leftSon = rotateLeft(node->leftSon);
    return rotateRight(node);
}

// Rebalance AVL Tree
Avl *rebalanceAVL(Avl *node)
{
    if (node->balance >= 2)
    {
        if (node->rightSon->balance >= 0)
            return rotateLeft(node);
        else
            return doubleRotateLeft(node);
    }
    else if (node->balance <= -2)
    {
        if (node->leftSon->balance <= 0)
            return rotateRight(node);
        else
            return doubleRotateRight(node);
    }
    return node;
}

// Insert into AVL Tree
Avl *insertAVL(Avl *node, long capacity, int id, int *h)
{
    if (!node)
    {
        *h = 1;
        return createAVL(capacity, id);
    }
    else if (id < node->id)
    {
        node->leftSon = insertAVL(node->leftSon, capacity, id, h);
        *h = -*h;
    }
    else if (id > node->id)
    {
        node->rightSon = insertAVL(node->rightSon, capacity, id, h);
    }
    else
    {
        *h = 0;
        return node;
    }
    if (*h)
    {
        node->balance += *h;
        node = rebalanceAVL(node);
        *h = node->balance == 0 ? 0 : 1;
    }
    return node;
}

// Search AVL Node by ID
int search(Avl *node, int id, Avl **result)
{
    if (!node)
        return 0;
    if (node->id == id)
    {
        *result = node;
        return 1;
    }
    return (id < node->id) ? search(node->leftSon, id, result) : search(node->rightSon, id, result);
}

// Update Station Load
void updateStation(Avl *tree, long load, int id)
{
    Avl *station;
    if (search(tree, id, &station))
    {
        station->load += load;
    }
}

// Build AVL Tree Based on Input Data
Avl *buildAvl(Avl *tree, int isLv, int isHva, int isHvb, char *chvb, char *chva, char *clv, char *ccomp, char *cindiv, char *ccapa, char *cload)
{
    int h = 0;
    if (isLv)
    {
        if (strcmp("-", ccomp) || strcmp("-", cindiv))
            updateStation(tree, atol(cload), atoi(clv));
        else
            tree = insertAVL(tree, atol(ccapa), atoi(clv), &h);
    }
    else if (isHva)
    {
        if (strcmp("-", ccomp) || strcmp("-", cindiv))
            updateStation(tree, atol(cload), atoi(chva));
        else if (strcmp("-", clv))
            updateStation(tree, atol(ccapa), atoi(chva));
        else
            tree = insertAVL(tree, atol(ccapa), atoi(chva), &h);
    }
    else if (isHvb)
    {
        if (strcmp("-", ccomp) || strcmp("-", cindiv))
            updateStation(tree, atol(cload), atoi(chvb));
        else if (strcmp("-", clv) || strcmp("-", chva))
            updateStation(tree, atol(ccapa), atoi(chvb));
        else
            tree = insertAVL(tree, atol(ccapa), atoi(chvb), &h);
    }
    return tree;
}

// Print AVL Tree
void printAVL(Avl *node)
{
    if (node)
    {
        printAVL(node->leftSon);
        printf("Station %d, capacity = %ld, load = %ld\n", node->id, node->capacity, node->load);
        printAVL(node->rightSon);
    }
}

// Main Function
int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        fprintf(stderr, "Usage: %s <station_type>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    char *stationType = argv[1];
    Avl *tree = NULL;

    FILE *file = fopen("c-wire_v00.dat", "r");
    if (!file)
    {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    char line[256];
    fgets(line, sizeof(line), file); // Skip header

    while (fgets(line, sizeof(line), file))
    {
        char *cpp = strtok(line, ";");
        char *chvb = strtok(NULL, ";");
        char *chva = strtok(NULL, ";");
        char *clv = strtok(NULL, ";");
        char *ccomp = strtok(NULL, ";");
        char *cindiv = strtok(NULL, ";");
        char *ccapa = strtok(NULL, ";");
        char *cload = strtok(NULL, ";");

        int isLv = strcmp(stationType, "lv") == 0;
        int isHva = strcmp(stationType, "hva") == 0;
        int isHvb = strcmp(stationType, "hvb") == 0;

        tree = buildAvl(tree, isLv, isHva, isHvb, chvb, chva, clv, ccomp, cindiv, ccapa, cload);
    }

    printAVL(tree);
    fclose(file);

    return 0;
}

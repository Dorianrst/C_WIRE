#include "fonctions.h"

int min(int a, int b)
{
    return (a < b) ? a : b;
}

int max(int a, int b)
{
    return (a > b) ? a : b;
}

int max3(int a, int b, int c)
{
    return (a > b) ? (a > c ? a : c) : (b > c ? b : c);
}

int min3(int a, int b, int c)
{
    return (a < b) ? (a < c ? a : c) : (b < c ? b : c);
}

Avl *createNode()
{
    Avl *new = malloc(sizeof(Avl));
    if (new == NULL)
    {
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

Avl *createAVL(long capacity, int id)
{
    Avl *new = createNode();
    new->capacity = capacity;
    new->id = id;
    return new;
}

// Get the height of a node
int getBalance(Avl *node)
{
    if (node == NULL)
    {
        return 0;
    }
    return node->balance;
}

// Perform a right rotation
Avl *rotateRight(Avl *node)
{
    Avl *pivot = node->leftSon;
    int balance_node = node->balance;
    int balance_pivot = pivot->balance;

    node->leftSon = pivot->rightSon;
    pivot->rightSon = node;

    node->balance = balance_node - min(balance_pivot, 0) + 1;
    pivot->balance = max3(balance_node + 2, balance_node + balance_pivot + 2, balance_pivot + 1);

    return pivot;
}

// Perform a left rotation
Avl *rotateLeft(Avl *node)
{
    Avl *pivot = node->rightSon;
    int balance_node = node->balance;
    int balance_pivot = pivot->balance;

    node->rightSon = pivot->leftSon;
    pivot->leftSon = node;

    node->balance = balance_node - max(balance_pivot, 0) - 1;
    pivot->balance = min3(balance_node - 2, balance_node + balance_pivot - 2, balance_pivot - 1);

    return pivot;
}

Avl *doubleRotateLeft(Avl *node)
{
    node->rightSon = rotateRight(node->rightSon);
    return rotateLeft(node);
}

Avl *doubleRotateRight(Avl *node)
{
    node->leftSon = rotateLeft(node->leftSon);
    return rotateRight(node);
}

Avl *balanceAVL(Avl *a)
{
    if (a->balance >= 2)
    { // When the shaft is unbalanced to the right
        if (a->rightSon->balance >= 0)
        {
            return rotateLeft(a); // Single rotation left
        }
        else
        {
            return doubleRotateLeft(a); // Double left rotation
        }
    }
    else if (a->balance <= -2)
    { // Case where the shaft is unbalanced to the left
        if (a->leftSon->balance <= 0)
        {
            return rotateRight(a); // Single rotation right
        }
        else
        {
            return doubleRotateRight(a); // Double rotation right
        }
    }
    return a; // No rebalancing required
}

Avl *insertAVL(Avl *a, long capacity, int id, int *h)
{
    if (a == NULL)
    {           // If the tree is empty, create a new node
        *h = 1; // The height has increased
        return createAVL(capacity, id);
    }
    else if (id < a->id)
    { // If the element is smaller, insert on the left
        a->leftSon = insertAVL(a->leftSon, capacity, id, h);
        *h = -*h; // Reverses the impact of height
    }
    else if (id > a->id)
    { // If the element is larger, insert to the right
        a->rightSon = insertAVL(a->rightSon, capacity, id, h);
    }
    else
    { // Element already present
        *h = 0;
        return a;
    }
    // Updating the balance factor and rebalancing if necessary
    if (*h != 0)
    {
        a->balance += *h;
        a = balanceAVL(a);
        if (a->balance == 0)
        {
            *h = 0;
        }
        else
        {
            *h = 1;
        }
    }
    return a;
}

// We check the arguments
void checkStation(char* station){
    if(strcmp("hvb", station) != 0 && strcmp("hva", station) != 0 && strcmp("lv", station) != 0){
        printf("Invalid station type. Allowed values: hvb, hva, lv.\n");
        exit(2);
    }
}


// We check the type variable
void checkType(char* type, char* station){
    if(strcmp("all", type) != 0 && strcmp("comp", type) != 0 && strcmp("indiv", type) != 0)
    {
		printf("Invalid consumer type. Allowed values: comp, indiv, all.\n");
        exit(2);
	}
	else if(strcmp("hvb", station) == 0 && strcmp("comp", type) != 0)
    {
		printf("The ‘all’ and ‘indiv’ options are prohibited for HV-B and HV-A stations.\n");
        exit(2);
	}
	else if(strcmp("hva", station) == 0 && strcmp("comp", type) != 0)
    {
		printf("The ‘all’ and ‘indiv’ options are prohibited for HV-B and HV-A stations.\n");
        exit(2);
	}
}

int checkChoicePp(char* arg, int choice_pp){
    if(arg != NULL) // The choice of the power station has been made
    { 
		if(atoi(arg) < 0 || atoi(arg) > 5)
        {
			printf("The power station ID must be a number between 1 and 5.\n");
		    return 0;
		}
        return atoi(arg);
    }
    else // So if the argument is not here, we take all the power stations.
    { 
        printf("No station ID provided. All power stations will be processed.\n");
    	return 0;
    }
}


// Function for writing a node to the CSV file
void writeToCsv(FILE *csvFile, int id, long capacity, long load)
{
    fprintf(csvFile, "%d:%lu:%lu\n", id, capacity, load);
}

// Function for browsing the AVL and writing to a CSV file
void writeAVLToCsv(Avl *node, FILE *csvFile)
{
    if (node != NULL)
    {
        // Recursive writing of left-hand nodes
        writeAVLToCsv(node->leftSon, csvFile);

        // Writing the current node
        writeToCsv(csvFile, node->id, node->capacity, node->load);

        // Recursive writing of right-hand nodes
        writeAVLToCsv(node->rightSon, csvFile);
    }
}

void writeForGraph(FILE *csvFile, int id, long load, long capacity)
{
    fprintf(csvFile, "%d, %lu , %lu \n", id, load, capacity); // Format : id:load
}

void writeAVLForGraph(Avl *node, FILE *csvFile)
{
    if (node != NULL)
    {
        // Recursive writing of left-hand nodes
        writeAVLForGraph(node->leftSon, csvFile);

        // Write current node (ID + Load only)
        writeForGraph(csvFile, node->id, node->load, node->capacity);

        // Recursive writing of right-hand nodes
        writeAVLForGraph(node->rightSon, csvFile);
    }
}

int research(Avl *node, int id, Avl **searched)
{
    if (node == NULL)
    {
        return 0;
    }
    if (node->id == id)
    {
        *searched = node;
        return 1;
    }
    if (node->id > id)
    {
        return research(node->leftSon, id, searched);
    }
    if (node->id < id)
    {
        return research(node->rightSon, id, searched);
    }
}

void updateStation(Avl *tree, long load, int id)
{
    Avl *station;
    int result = research(tree, id, &station);

    if (!result)
    {
        return;
    }

    station->load += load;
}

Avl *buildAvl(Avl *tree, char *station, char *type, int choice_pp, char *cpp, char *chvb, char *chva, char *clv, char *ccomp, char *cindiv, char *ccapa, char *cload)
{
    int ph = 0;
    int *h = &ph;

    if (strcmp("hvb", station) == 0 && !(strcmp("-", chvb) == 0))
    {
        if (choice_pp == 0 || choice_pp == atoi(cpp))
        {
            // If it's a hvb receiving energy
            if (strcmp("-", chva) == 0 && strcmp("-", ccapa) != 0)
            {
                // Insert the station in the tree
                tree = insertAVL(tree, atol(ccapa), atoi(chvb), h);
            }
            // Check that the company and load boxes are filled in correctly
            else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0)
            {
                // We add the extra consumption at the station
                updateStation(tree, atol(cload), atoi(chvb));
            }
        }
    }
    else if (strcmp("hva", station) == 0 && !(strcmp("-", chva) == 0))
    {
        if (choice_pp == 0 || choice_pp == atoi(cpp))
        {
            // If it's a hva receiving energy from a hvb
            if (strcmp("-", chvb) != 0)
            {
                // Insert the station in the tree
                tree = insertAVL(tree, atol(ccapa), atoi(chva), h);
            }
            // We only add the hva that gives a company
            else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0)
            {
                // We add the extra consumption at the station
                updateStation(tree, atol(cload), atoi(chva));
            }
        }
    }
    else if (strcmp("lv", station) == 0 && !(strcmp("-", clv) == 0))
    {
        if (choice_pp == 0 || choice_pp == atoi(cpp))
        {
            // If it's an lv receiving energy from a hva
            if (strcmp("-", chva) != 0)
            {
                // Insert the station in the tree
                tree = insertAVL(tree, atol(ccapa), atoi(clv), h);
            }
            // To add only companies
            else if (strcmp("-", cload) != 0 && strcmp("-", ccomp) != 0 && (strcmp("comp", type) == 0 || strcmp("all", type) == 0))
            {
                // We add the extra consumption at the station
                updateStation(tree, atol(cload), atoi(clv));
            }
            // To add only private individuals
            else if (strcmp("-", cload) != 0 && strcmp("-", cindiv) != 0 && (strcmp("indiv", type) == 0 || strcmp("all", type) == 0))
            {
                // We add the extra consumption at the station
                updateStation(tree, atol(cload), atoi(clv));
            }
        }
    }

    return tree;
}


void freeAVL(Avl *node)
{
    if (node != NULL)
    {
        freeAVL(node->leftSon);  // Recursively free the left sub-tree
        freeAVL(node->rightSon); // Recursively free the right sub-tree
        free(node);              // Free the current node
    }
}

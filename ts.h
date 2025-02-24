/****************CREATION DE LA TABLE DES SYMBOLES ******************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure des TS-

typedef struct NodeTS
{
    char name[20];
    char code[20];
    char type[20];
    char val[20];
    int ceck_cst;
    int taille;

    struct NodeTS *next;
} NodeTS;

typedef struct NodeSM
{
    char name[20];
    char type[20];
    struct NodeSM *next;
} NodeSM;

// Têtes des listes chaînées
NodeTS *TS = NULL;
NodeSM *TS_MC = NULL;
NodeSM *TS_S = NULL;

/* 2- Fonction d'insertion des entités lexicales ***/

void insererTS(const char *name, const char *code, const char *type, const char *val, int ceck_cst, int taille)
{

    NodeTS *newNode = (NodeTS *)malloc(sizeof(NodeTS));
    if (newNode == NULL)
    {

        exit(1);
    }

    strcpy(newNode->name, name);
    strcpy(newNode->code, code);
    strcpy(newNode->type, type);
    strcpy(newNode->val, val);
    newNode->ceck_cst = ceck_cst;
    newNode->taille = taille;

    newNode->next = TS;
    TS = newNode;
}

// insere tabM tabS
void insererSM(NodeSM **head, const char *name, const char *type)
{

    NodeSM *newNode = (NodeSM *)malloc(sizeof(NodeSM));
    if (newNode == NULL)
    {

        exit(1);
    }

    strcpy(newNode->name, name);
    strcpy(newNode->type, type);

    newNode->next = *head;
    *head = newNode;
}

// GETTaille
int getTaille(const char *name)
{
    NodeTS *current = TS;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            return current->taille; // Retourner la taille
        }
        current = current->next;
    }
    return -1;
}

int isceck_cst(const char *name)
{
    NodeTS *current = TS;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0 && (current->ceck_cst == 0) == 0)
        {
            return 1; // Symbole non ceck_cst
        }
        current = current->next;
    }
    return 0; // Symbole est ceck_cst
}

// DECLARATION OU NON
int Declare(const char *name)
{
    NodeTS *current = TS;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            return 1; // Symbole trouvé
        }
        current = current->next;
    }
    return 0; // Symbole non trouvé
}

// Fonction Rechercher
void rechercher(const char *entite, const char *code, const char *type, const char *val, int ceck_cst, int t, int y)
{
    NodeTS *current;
    NodeSM *currentM;
    NodeSM *currentS;

    switch (y)
    {
    case 1:
        current = TS;
        while (current != NULL)
        {
            if (strcmp(current->name, entite) == 0)
            {

                return; // L'entité existe déjà
            }
            current = current->next;
        }

        insererTS(entite, code, type, val, ceck_cst, t);
        break;

    case 2:
        currentM = TS_MC;
        while (currentM != NULL)
        {
            if (strcmp(currentM->name, entite) == 0)
            {

                return; // Le mot-clé existe déjà
            }
            currentM = currentM->next;
        }

        insererSM(&TS_MC, entite, code);
        break;

    case 3:
        currentS = TS_S;
        while (currentS != NULL)
        {
            if (strcmp(currentS->name, entite) == 0)
            {

                return; // Le séparateur existe déjà
            }
            currentS = currentS->next;
        }

        insererSM(&TS_S, entite, code);
        break;
    }
}

/*Fonction d'affichage de la TS */

void afficherTS()
{
    printf("/**************************Table des symboles IDF*******************************/\n");
    printf("_____________________________________________________________________________\n");
    printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite | ceck_cst | Taille\n");
    printf("_____________________________________________________________________________\n");

    NodeTS *current = TS;
    while (current != NULL)
    {
        printf("\t|%11s |%13s | %12s | %9s | %7d | %8d |\n",
               current->name, current->code, current->type, current->val, current->ceck_cst, current->taille);
        current = current->next;
    }
}

void afficherM()
{
    printf("\n/***************Table des symboles mots cles*************/\n");
    printf("_____________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("_____________________________________\n");

    NodeSM *current = TS_MC;
    while (current != NULL)
    {
        printf("\t|%10s |%12s | \n", current->name, current->type);
        current = current->next;
    }
}

void afficherS()
{

    printf("\n/*******Table des symboles separateurs********/\n");
    printf("_____________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("_____________________________________\n");

    NodeSM *current = TS_S;
    while (current != NULL)
    {
        printf("\t|%10s |%12s | \n", current->name, current->type);
        current = current->next;
    }
}

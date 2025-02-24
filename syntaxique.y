 /* -------------- Analyseur syntaxique ----------------*/

 %{
 #include <string.h>
   #include <stdio.h> 
 int nb_ligne=1;
 int Col=1;
 void yyerror(char *msg);
 char* current_type;
    int yylex(); // Déclaration explicite de yylex
    int exit();
    int getTaille();
    int Declare();
    int isceck_cst();
    void rechercher();
    void afficherM();
    void afficherS();
    void afficherTS();
%}
%start S

/* Déclaration des types */
%union {
    int entier;
    char* str;
    float floatval;
}


%token MC_DEB MC_FIN MC_EXC ERR  MC_FIX  MC_SI MC_SNON MC_TQ MC_OU MC_ALORS acolv
%token MC_FAIRE MC_LIRE MC_AFFICHE MC_NON PE GE NE AFF MC_ET '-' acolf 
%token <str> MC_NUM <str> MC_REAL <str> IDF  <str> MC_TXT <str> STRING 
%token <entier> CST
%token <floatval> CST_FLOAT
%type <str> TYPE
%type <str> LISTE_IDF
%type <entier> EXP EXPPRIME TERME TERMEPRIME FACTEURS 



%left MC_OU
%left MC_ET
%left MC_NON
%left '<' '>' GE PE '=' NE
%left '+' '-'
%left '*' '/'
 

%%


S:
    MC_DEB DECLARATIONS   MC_EXC   BLOC_inst  MC_FIN { printf ("programme syntaxiquement correcte . \n"); YYACCEPT;}
;

DECLARATIONS:  
            DECLARATION DECLARATIONS
            | 
            ;

DECLARATION:
           TYPE ':' LISTE_IDF ';'  


           | MC_FIX TYPE ':' IDF '=' CST ';' { printf("constante declare : %s de type %s\n", $4, current_type);
                if (Declare($4)){
                 printf("Erreur semantique : Variable '%s' deja declare , a la ligne %d a la colonne %d\n", $4,nb_ligne,Col);exit(1);
              };  
                rechercher($4,"IDF",current_type,"",1,0,1);
                 Col= Col + strlen($4);
              }

           |MC_FIX TYPE ':' IDF '=' '-' CST ';' { printf("constante declare : %s de type %s\n", $4, current_type);
                if (Declare($4)){
                 printf("Erreur semantique : Variable '%s' deja declare , a la ligne %d a la colonne %d\n", $4,nb_ligne,Col);exit(1);
              };  
                rechercher($4,"IDF",current_type,"",1,0,1);
                 Col= Col + strlen($4);
              }


           |MC_FIX TYPE ':' IDF '=' CST_FLOAT ';' { printf("constante declare : %s de type %s\n", $4, current_type);
                if (Declare($4)){
                 printf("Erreur semantique : Variable '%s' deja declare , a la ligne %d a la colonne %d\n", $4,nb_ligne,Col);exit(1);
              };  
                rechercher($4,"IDF",current_type,"",1,0,1);
                 Col= Col + strlen($4);
              }
           
           |MC_FIX TYPE ':' IDF '=' '-' CST_FLOAT ';' { printf("constante declare : %s de type %s\n", $4, current_type);
                if (Declare($4)){
                 printf("Erreur semantique : Variable '%s' deja declare , a la ligne %d a la colonne %d\n", $4,nb_ligne,Col);exit(1);
              };  
                rechercher($4,"IDF",current_type,"",1,0,1);
                 Col= Col + strlen($4);
              }
             
;

TYPE:
     MC_NUM  { current_type = "NUM"; $$ = current_type; }
     |MC_REAL  { current_type = "REAL"; $$ = current_type; }
     |MC_TXT  { current_type = "TEXT"; $$ = current_type; }
;

LISTE_IDF:
        IDF { printf("Identifiant declare : %s de type %s\n", $1, current_type);
              if (Declare($1)){
               printf("Erreur semantique : Variable '%s' deja declare, a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);exit(1);
              }
                 rechercher($1,"IDF",current_type,"",0,0,1);
                 Col= Col + strlen($1); 
              }
 

        |IDF '[' CST ']' ',' LISTE_IDF { printf("Tableau declare : %s[%d] de type %s\n", $1, $3, current_type);
                    if (Declare($1)) {
                 printf("Erreur semantique : Variable '%s' deja declare,  a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);exit(1);
              } 
                 rechercher($1,"IDF",current_type,"",0,$3,1); 
                 Col= Col + strlen($1);  }
| IDF ',' LISTE_IDF  { printf("Identifiant declare : %s de type %s\n", $1, current_type); 
                       if (Declare($1)) {
                 printf("Erreur semantique : Variable '%s' deja declare , a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);exit(1);
              } 
                 rechercher($1,"IDF",current_type,"",0,0,1); 
                 Col= Col + strlen($1);    
                 }
        |IDF '[' CST ']' { printf("Tableau declare : %s[%d] de type %s\n", $1, $3, current_type);
                    if (Declare($1)) {
                 printf("Erreur semantique : Variable '%s' deja declare , a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);exit(1);
              } 
                 rechercher($1,"IDF",current_type,"",0,$3,1); 
                 Col= Col + strlen($1);
        }
  ;

BLOC_inst:
          acolv INSTR acolf
  ;

INSTR: 
      INSTRUCTION INSTR
      | ;

INSTRUCTION:
           AFFECT
           |CONDITION
          |BCL
           |LECTURE
           |AFFICHE
           
           
  ;

AFFECT:
           IDF AFF  EXP ';'{
            if (!Declare($1)) {
                printf("Erreur semantique: Variable '%s' non declaree, a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);
                exit(1);
            }
            if (isceck_cst($1)){
               printf("Erreur semantique: Modification de la valeur d une constante, a la ligne %d a la colonne %d\n",nb_ligne,Col);exit(1);
            }
          
           
        }
           
          |IDF '[' CST ']' AFF  EXP ';'{
            if (!Declare($1)) {
                printf("Erreur semantique: Variable '%s' non declaree, a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);
                exit(1);
            }
            if (isceck_cst($1)){
               printf("Erreur semantique: Modification de la valeur d une constante, a la ligne %d a la colonne %d\n",nb_ligne,Col);exit(1);
            }
            if( $3 > getTaille($1)){
                printf("Erreur semantique : Depassement de la taille d un tableau, a la ligne %d a la colonne %d\n",nb_ligne,Col);exit(1);
            }
            
        }

          | IDF AFF STRING ';' { if (!Declare($1)) {
                printf("Erreur semantique : Variable '%s' non declaree.a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);
                exit(1);
            }
             
        }
           
    ;

CONDITION:
          MC_SI '(' COND_LOG ')' MC_ALORS BLOC_inst 
          |MC_SI '(' COND_LOG ')' MC_ALORS BLOC_inst MC_SNON BLOC_inst 
   ; 

BCL:
       MC_TQ '(' COND_LOG ')' MC_FAIRE BLOC_inst 
  ;

COND_LOG:
          CONDITIONSIMPLE COND_LOGPRIME
  ;

COND_LOGPRIME:
                  MC_ET CONDITIONSIMPLE COND_LOGPRIME
                  |MC_OU CONDITIONSIMPLE COND_LOGPRIME
                  |
    ;

CONDITIONSIMPLE:
                MC_NON CONDITIONSIMPLE
                | '('COND_LOG ')'
                |EXP COMPARATEUR EXP
  ;

EXP:
    TERME EXPPRIME
  ;

EXPPRIME:
         '+' TERME EXPPRIME {$$=$$ + $2 }
         |'-' TERME EXPPRIME  {$$= $$- $2}
         | {$$= 0;}
  ;

TERME:
      FACTEURS TERMEPRIME
  ;

TERMEPRIME:
           '*' FACTEURS TERMEPRIME {$$= $$ * $2}
           |'/' FACTEURS TERMEPRIME {
          if ( $2 ==0  ) { 
              printf("Erreur semantique :Division par 0, a la ligne %d a la colonne %d\n",nb_ligne,Col);
              exit(1); 
          } else {
              $$ = $$ / $2;
          }
      }
           | {$$=0;}
  ;

FACTEURS:
          '(' EXP ')' {$$=$2}

          | CST {($$=$1)}

          | '-' CST  {($$=$2)}

          |IDF {if (!Declare($1)) {
                printf("Erreur semantique : Variable '%s' non declaree, a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);
                exit(1);
            }
            
             
            
            }
          |CST_FLOAT {($$=(int)$1)}

          | '-' CST_FLOAT {($$=(int)$2)}
|IDF '[' CST ']' {if (!Declare($1)) {
                printf("Erreur semantique : Variable '%s' non declaree, a la ligne %d a la colonne %d\n", $1,nb_ligne,Col);
                exit(1);
            }
            
            if( $3 > getTaille($1)){
                printf("Erreur semantique : Depassement de la taille d un tableau, a la ligne %d a la colonne %d\n",nb_ligne,Col);exit(1);
            }
            
            }
          
  ;
  

COMPARATEUR:
            PE
            | '>'
            | '<'
            | GE
            | '='
            | NE
  ;
          

LECTURE:
       MC_LIRE '(' IDF ')' ';'
       
  ;

AFFICHE: 
         MC_AFFICHE '('STRING ')' ';'
         |MC_AFFICHE '(' STRING ',' IDF ')' ';'
  ;
       

      

      
%%

void yyerror(char *msg) {
    printf("Erreur syntaxique %s, a la ligne %d a la colonne %d\n", msg, nb_ligne,Col);
    
}
int main ()
{ 
  
  yyparse();
  afficherTS();
  afficherM();
  afficherS();


    return 0;
}
int yywrap (){
  return 1;
}

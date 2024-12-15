%{
   #include <stdio.h>
   int nb_ligne = 1;
   int nb_colone = 1;

   int yylex(); // Déclaration explicite de yylex
   void yyerror(const char msg); // Déclaration explicite et correcte de yyerror

%}


%union {
int numint;
char string;
float numfloat;
}

%start S
%token DEBUT EXECUTION ':'  FIN CST <numint>CST_int <string>CST_string  <numfloat>CST_real <string>IDF <numint>NUM <numfloat>REAL <string>TEXT '[' FIXE  ']' acolv acolf aff ';' SI  ALORS SINON TANQUE FAIRE OU ET NON '=''+''*''/' '<' '>' PE GE NE ;
%%

S: DEBUT  DECLARATION  EXECUTION acolv Bloc_Inst  acolf FIN {
       printf("syntaxe correcte\n");
       YYACCEPT;
   };

Type : NUM | REAL | TEXT;

DECLARATION : DEC_VAR DEC_cst | DEC_cst DEC_VAR
        |
        ;

DEC_VAR : VAR  DEC_VAR
        |
        ;

VAR : Type ':' Liste_IDF ';';


 

Liste_IDF: IDF ',' Liste_IDF  | IDF '=' CST_int  {printf("declaration d'une variable avec initialisation de : %d \n",$3);}
  | IDF{printf("declaration d'une variable \n");}
  |
    IDF  '=' CST_V OP_Arithmetique CST_V 
    |
    IDF '[' CST_int ']' { if($3 >= 0) {printf("declaration d'un tableau correcte \n");
    }else { printf("erreur la taille doit etre positive \n"); }
       }
  //check que  CST_int >= 0




DEC_cst: FIXE Type ':' IDF '=' CST_V ';'{printf("declaration d'une constante \n");}

CST_V : CST_int | CST_string  | CST_real ;
 Bloc_Inst :Expression | COND | BCL |ExpressionAFF |  Expression_Logique | Expression_arithmetique
|
 ;
Expression:
COND: SI '('Expression_Logique | Expression_arithmetique ')' ALORS acolv Expression acolf | SI '('IDF')' ALORS acolv Expression acolf SINON '('IDF')' acolv Expression acolf ;
BCL: TANQUE '(' IDF')' FAIRE acolv Expression acolf;

ExpressionAFF : 
AFF : IDF aff CST ';'{       printf("aff idf cst \n");}
|  IDF aff IDF ';'{ printf("aff idf idf \n");} | IDF aff Expression_arithmetique ';';
 
OP_LOGIQUE : ET | OU | NON ;
OP_Arithmetique :'=' | '+' | '' | '/' ;
OP_COMP: '<' |  '>' |  '=' | PE | GE | NE ;
Expression_Logique :   OP_Arithmetique
Expression_arithmetique : OP_Arithmetique
%%

int main() {
    yyparse();
    return 0;
}

int yywrap() {
    return 1;
}

void yyerror(const charmsg) {
    fprintf(stderr, "Erreur de syntaxe à la ligne %d, colonne %d : %s\n", nb_ligne, nb_colone, msg);
}
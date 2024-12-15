/* -------------- Analyseur lexicale ----------------*/

%{
       // Partie : Déclarations en C
    #include "syntaxique.tab.h"
    #include "table_symbole.h" 

     extern int nb_ligne;
     extern int nb_colone;


     extern YYSTYPE yylval;

%}
  /* -- Partie : Expressions régulières -- */
lettre [a-zA-Z]
chiffre [0-9]
IDF  [A-Z]({lettre}|{chiffre}|_)*  
cmntr_ligne  --[^\n]*##
cmntr_bloc \{-([^}]*)-\}
CST_int [-+]?{chiffre}+
CST_string \"[^\"]*\"
CST_real [+-]?{chiffre}+.{chiffre}+



%%
DEBUT   {  printf("L'entite \' %s \' lexicale reconnue de taille %d \n",yytext,yyleng);
          nb_colone+=yyleng; return DEBUT;}

EXECUTION {  printf("L'entite \' %s \' lexicale reconnue \n",yytext);
                 nb_colone+=yyleng; return  EXECUTION;}

FIN {  printf("L'entite \' %s \' lexicale reconnue \n",yytext);
           nb_colone+=yyleng; 
           return FIN;} 


NUM {  printf("L'entite \' %s \' lexicale reconnue \n",yytext);
 nb_colone+=yyleng; return  NUM;}

REAL {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
nb_colone+=yyleng; return REAL;} 

TEXT {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
          nb_colone+=yyleng; return TEXT; } 

FIXE {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
            nb_colone+=yyleng; return FIXE;} 


SI {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
      nb_colone+=yyleng; return SI;} 

ALORS {  printf("L'entite \' %s \' lexicale reconnue \n",yytext);
          nb_colone+=yyleng; 
          return ALORS;} 

SINON {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
          nb_colone+=yyleng;
            return SINON;} 


TANQUE {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
nb_colone+=yyleng; return TANQUE;} 

FAIRE {  printf("L'entite \' %s \' lexicale reconnue \n",yytext);
 nb_colone+=yyleng; return FAIRE;} 


OU {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
        nb_colone+=yyleng; return OU;} 

ET {  printf("L'entite \' %s \' lexicale reconnue \n",yytext);
           nb_colone+=yyleng; return ET;} 

NON {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
            nb_colone+=yyleng; return NON;} 



          
{CST_int} {        printf("L'entite lexicale reconnue est %s \n", yytext); 
                   yylval.numint=atoi(yytext);
                 nb_colone+=yyleng; 
                  return CST_int;} 


{CST_string} {   printf("L'entite lexicale reconnue est %s \n", yytext);
               yylval.string=strdup(yytext);
                 nb_colone+=yyleng; 
                return CST_string;}



{CST_real}  {    printf("L'entite lexicale reconnue est %s \n", yytext); 
                 yylval.numfloat=atof(yytext);
                 nb_colone+=yyleng; 
                return CST_real;}


{IDF} {  printf("L'entite \' %s \' lexicale reconnue \n",yytext); 
        yylval.string=strdup(yytext);
          nb_colone+=yyleng; 
          return IDF ; } 



"," {  nb_colone += yyleng; return ','; }
"/" { printf("Token '/' reconnu\n"); nb_colone += yyleng; return '/'; }
"+" { printf("Token '+' reconnu\n"); nb_colone += yyleng; return '+'; }
"*" { printf("Token '*' reconnu\n"); nb_colone += yyleng; return '*'; }
"(" { printf("Token '(' reconnu\n"); nb_colone += yyleng; return '('; }
")" { printf("Token ')' reconnu\n"); nb_colone += yyleng; return ')'; }
"[" { printf("Token '[' reconnu\n"); nb_colone += yyleng; return '['; }
"]" { printf("Token ']' reconnu\n"); nb_colone += yyleng; return ']'; }

";" { nb_colone += yyleng; return ';'; }
":" { nb_colone += yyleng; return ':'; }
"<-" { nb_colone+=yyleng;  return aff; }
"{"  { nb_colone+=yyleng;  return acolv; }
"}" {  nb_colone+=yyleng;  return acolf; }
"<"   { nb_colone += yyleng; return '<'; }
"<="  { nb_colone += yyleng; return PE; }
">"   { nb_colone += yyleng; return '>'; }
">="  { nb_colone += yyleng; return GE; }
"="   { nb_colone += yyleng; return '='; }
"!="  { nb_colone += yyleng; return NE; }

{cmntr_ligne} printf("\t cmntrr ligne \n");
{cmntr_bloc}  printf("\t cmntrr bloc \n");
[ \t]+ {nb_colone ++; }  ;
\n {nb_ligne++; };



. {printf("entite non reconnue a la ligne %d a la colone %d \n",nb_ligne,nb_colone) ;}

%%
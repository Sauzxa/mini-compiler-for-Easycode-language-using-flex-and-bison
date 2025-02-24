
/* -------------- Analyseur lexicale ----------------*/

%{
    // Partie : Déclarations en C
         #include "syntaxique.tab.h"
         #include "ts.h" 
         #include <string.h>
          extern YYSTYPE yylval;
          extern int nb_ligne;
          extern int Col;

%}
/* -- Partie : Expressions régulières -- */

lettre [a-zA-Z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre}|_)*
CST {chiffre}+
CST_FLOAT [0-9]+\.[0-9]+ 
STRING \"[^\"]*\"

cmntr_ligne  --[^\n]*##
cmntr_bloc "{-"([^'-']|\\n)*"-}"


%%
DEBUT   {rechercher(yytext,"Mot cle",0,"",0,0,2); 
Col= Col+yyleng; 
 return MC_DEB; }
EXECUTION {rechercher(yytext,"Mot cle",0,"",0,0,2); 
Col= Col+yyleng;  
return MC_EXC; }
FIN  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
 return MC_FIN; }
NUM  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
 return MC_NUM; }
REAL  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;  
return MC_REAL; }
TEXT  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;  
return MC_TXT; }
FIXE  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;  
return MC_FIX; }
SI   {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;  
return MC_SI; }
SINON  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
 return MC_SNON; }
TANTQUE  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
 return MC_TQ; }
FAIRE  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
 return MC_FAIRE; }
ALORS  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;
  return MC_ALORS; }
ET   {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;
  return MC_ET; }
OU   {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 

 return MC_OU; }
NON  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
 return MC_NON; }
lire   {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng; 
return MC_LIRE; }
affiche  {rechercher(yytext,"Mot cle",0,"",0,0,2); Col= Col+yyleng;
  return MC_AFFICHE; }


  


{STRING}  {
            yylval.str = strdup(yytext); 
            Col=Col+strlen(yytext);
            
            return STRING; 
            }
{CST_FLOAT} {
           rechercher(yytext,"CST","","",0,0,1); 
           yylval.floatval = atof(yytext);
           Col= Col+strlen(yytext);
          
           return CST_FLOAT;
            }

{CST} {
yylval.entier=atoi(yytext);
        if(atoi(yytext)>32767 || atoi(yytext)<-32768 ){
             printf ("Erreur Lexical: depassement de marge  %d a la Colonne %d \n",nb_ligne, Col);
        }
              rechercher(yytext,"CST","","",0,0,1); 
              Col= Col + strlen(yytext); 
        
        return CST;
      }

{IDF} {

yylval.str=strdup(yytext);
        
            
        if (yyleng>10) printf ("Erreur Lexical: IDF trop long a la ligne %d a la Colonne %d \n",nb_ligne, Col);
                                     
              else{ 
        return IDF;
              }
}


"-" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '-'; }

"," { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return ','; }

"/" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '/'; }

"+" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '+'; }

"*" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '*'; }

"(" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '('; }

")" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return ')'; }

"[" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '['; }

"]" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return ']'; }

";" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return ';'; }

":" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return ':'; }

"<-" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return AFF; }

"{"  { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return acolv; }

"}" { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return acolf; }

"<"   { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '<'; }

"<="  { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return PE; }

">"   { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '>'; }

">="  { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return GE; }

"="   { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return '='; }

"!="  { rechercher(yytext,"Separateur",0,"",0,0,3);
 Col += yyleng; return NE; }


{cmntr_ligne} {printf("\t cmntrr ligne \n");  
yylval.str = strdup(yytext); 
    Col = Col + strlen(yytext);  }

{cmntr_bloc} { printf("\t cmntrr bloc \n");
 yylval.str = strdup(yytext); 
    int i;
    for ( i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') nb_ligne++;  
    }
    Col = Col + yyleng;  
    
}


[ \t] { Col++; }
\n {nb_ligne++; Col=1;}
. {printf ("erreur lexical sur l'entite %s a la ligne %d a la Colonne %d",yytext,nb_ligne,Col); return ERR;}
%%

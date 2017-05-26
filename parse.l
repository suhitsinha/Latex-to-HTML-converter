%option noyywrap
%{
	#include <iostream>
	#include <cstring>
	using namespace std;
	int tabfound = 0;
	int uolistfound = 0;
	int olistfound = 0;
	int formulafound = 0;

	
%}

starttable "\\begin{table}"
endtable "\\end{table}"
newrow	"\\\\"
startuolist "\\begin{itemize}"
enduolist "\\end{itemize}"
startolist "\\begin{enumerate}"
endolist "\\end{enumerate}"
formula "$"
item "\\item "
spc " "


%%
{starttable}	{tabfound = 1; printf("%s",yytext);}
{endtable}	{tabfound = 0; printf("%s",yytext);}
{startuolist}	{uolistfound = 1; printf("%s",yytext);}
{enduolist}	{uolistfound = 0; printf("%s",yytext);}
{startolist}	{olistfound = 1; printf("%s",yytext);}
{endolist}	{olistfound = 0; printf("%s",yytext);}
&		{if(tabfound == 0) printf("&"); else printf("|&|");}
{newrow}	{if(tabfound == 0) printf("\\\\"); else printf("|\\\\|");}
{formula}	{formulafound = (formulafound + 1) % 2; printf("%s",yytext);}
{item}		{if(uolistfound == 0 && olistfound == 0) printf("\\item "); else printf("|");}
{spc}		{if(formulafound == 1) printf("|"); else printf("%s",yytext);}
\n		{if(tabfound == 0 && uolistfound == 0 && olistfound == 0) printf("\n"); else printf("|");}



%%
#include<stdio.h>

int main (int argc, char *argv[]) {
yyin=fopen(argv[1],"r");

yylex();
return 0;
}


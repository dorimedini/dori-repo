%{
#include <stdio.h>
#include <string>
#include "attributes.h"
#include "matrixer.tab.hpp"
using std::string;

/* TODO: Before submitting, set DEBUG to 0 (from attributes.h) */

 /**
  * The unary minus:
  *
  * A unary minus will always come after one of the following characters
  * (maybe with some whitespace between them):
  * 
  * '('
  * '['
  * '{'
  * '='
  * ','
  * '::'
  * '+'
  * '-'
  * '*'
  * '/'
  * ';'
  * 
  * In addition, if the minus sign is at the beginning of the line, the minus
  * is unary.
  *
  * To implement this, use the lookahead capability of lex. For each of the above
  * symbols, after tokenizing them turn the "unary flag" on. For any other symbol,
  * after tokenization - turn it off.
  *
  * When '-' is encountered, return UNARY_MINUS if the flag is on or MINUS otherwise.
  * Note that x+--a is a valid string, (interpreted as x+(-(-a)). ugly) so even 
  * after a '-' sign we have to keep the flag on.
  */
// Set the initial value to 1, because if the '-' sign is the first sign in the file
// it should be treated as a unary minus.
int next_minus_is_unary = 1;
void set_unary_flag();
void clear_unary_flag();
void error_handler();

%}

%option yylineno
%option noyywrap

%%

print					{set_unary_flag(); return PRINT;}
read					{set_unary_flag(); return READ;}
\"[^"]*\"				{set_unary_flag(); return STRING;}
true					{set_unary_flag(); return TRUE;}
false					{set_unary_flag(); return FALSE;}
if						{set_unary_flag(); return IF;}
else					{set_unary_flag(); return ELSE;}
while					{set_unary_flag(); return WHILE;}
foreach					{set_unary_flag(); return FOREACH;}
in						{set_unary_flag(); return IN;}

 /** These are pretty straightforward, except for the minus sign. */
 /** See above for more detailed comments on the unary minus. */
\(						{set_unary_flag(); return LP;}
\)						{clear_unary_flag(); return RP;}
\{						{set_unary_flag(); return LC;}
\}						{clear_unary_flag(); return RC;}
\[						{set_unary_flag(); return LB;}
\]						{clear_unary_flag(); return RB;}
\,						{set_unary_flag(); return CS;}
\;						{set_unary_flag(); return SC;}
\=						{set_unary_flag(); return ASSIGN;}
transpose				{clear_unary_flag(); return TRANSPOSE;}
int|matrix				{
	// TODO: Aren't the true and false here switched?:
	// ANSWER: No, strcmp returns 0 (false) if the strings are identical
							yylval.is_matrix = strcmp("int",yytext) ? true : false;
							g_is_last_type_declaration_matrix = yylval.is_matrix;
							clear_unary_flag();
							return TYPE;
						}
\/						{set_unary_flag(); return DIV;}
\*						{set_unary_flag(); return MUL;}
\+						{set_unary_flag(); return PLUS;}
\-						{
							int tmp = next_minus_is_unary;
							set_unary_flag();
							return tmp ? UNARY_MINUS : MINUS;
						}
 /** These require some data updates: */
([1-9][0-9]*)|0			{
							// Numbers are always constant.
							// Update the value, and let bison know it's constant
							// so it will enforce no assignments to the value.
							yylval.is_matrix = false;
							yylval.value = atoi(yytext);
							clear_unary_flag();
							return NUM;
						}
[a-zA-Z][a-zA-Z0-9_]*	{
							// Identifiers aren't constant, and they have names.
							// It is unknown at this point what is their type, so
							// ignore the is_matrix field for now.
							// Also, set the number of rows and columns to zero - otherwise it
							// becomes hard to define a matrix at all.
							yylval.name = string(yytext);
							yylval.rows=0;
							yylval.cols=0;
							clear_unary_flag();
							return ID;
						}
\<\=					{set_unary_flag(); yylval.name=yytext; return RELOP;}
\>\=					{set_unary_flag(); yylval.name=yytext; return RELOP;}
\<						{set_unary_flag(); yylval.name=yytext; return RELOP; }
\>						{set_unary_flag(); yylval.name=yytext; return RELOP; }
\=\=					{set_unary_flag(); yylval.name=yytext; return RELOP;}
\!\=					{set_unary_flag(); yylval.name=yytext; return RELOP;}
\&\&					{set_unary_flag(); return AND;}
\|\|					{set_unary_flag(); return OR;}
\!						{set_unary_flag(); return NOT;}

 /** Ignore comments */
"//"[^\n]*\n			;

 /** Ignore whitespace */
[\t\n\r ]*				;

 /** Error - no character match */
.						error_handler();


%%

 /**
  * Use these functions to decide if the minus is unary or not.
  */
inline void set_unary_flag() {
	next_minus_is_unary=1;
}
inline void clear_unary_flag() {
	next_minus_is_unary=0;
}

void error_handler() 
{
	cout << "LEXICAL ERROR" << endl;
	exit(0);
}

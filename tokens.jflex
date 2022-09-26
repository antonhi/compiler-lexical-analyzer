/*-***
 *
 * This file defines a stand-alone lexical analyzer for a subset of the Pascal
 * programming language.  This is the same lexer that will later be integrated
 * with a CUP-based parser.  Here the lexer is driven by the simple Java test
 * program in ./PascalLexerTest.java, q.v.  See 330 Lecture Notes 2 and the
 * Assignment 2 writeup for further discussion.
 *
 */


import java_cup.runtime.*;


%%
/*-*
 * LEXICAL FUNCTIONS:
 */

%cup
%line
%column
%unicode
%class Lexer

%{

/**
 * Return a new Symbol with the given token id, and with the current line and
 * column numbers.
 */
Symbol newSym(int tokenId) {
    return new Symbol(tokenId, yyline, yycolumn);
}

/**
 * Return a new Symbol with the given token id, the current line and column
 * numbers, and the given token value.  The value is used for tokens such as
 * identifiers and numbers.
 */
Symbol newSym(int tokenId, Object value) {
    return new Symbol(tokenId, yyline, yycolumn, value);
}

%}

/*-*
 * PATTERN DEFINITIONS:
 */
int = -?[0-9]+
float = -?[0-9]+.[0-9]+
id = [a-zA-Z]+[0-9]*
char = '[[^']&&[^\\]]'|'\\n'|'\\t'
comment = \\\\.*
blockcomment = \\\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\\
letter = [[[^\n]&&[^\t]]&&[[^\\][^\"]]]|\\\\|\\\"
string = \"{letter}*\"
whitespace = [ \n\t\r]

%%
/**
 * LEXICAL RULES:
 */
class           {return newSym(sym.CLASS, yytext());}
final           {return newSym(sym.FINAL, yytext());}
int             {return newSym(sym.INT, yytext());}
char            {return newSym(sym.CHAR, yytext());}
bool            {return newSym(sym.BOOL, yytext());}
float           {return newSym(sym.FLOAT, yytext());}
void            {return newSym(sym.VOID, yytext());}
"="             {return newSym(sym.EQUAL, yytext());}
"("             {return newSym(sym.LPAREN, yytext());}
")"             {return newSym(sym.RPAREN, yytext());}
"~"             {return newSym(sym.TILDE, yytext());}
"-"             {return newSym(sym.DASH, yytext());}
"+"             {return newSym(sym.PLUS, yytext());}
true            {return newSym(sym.TRUE, yytext());}
false           {return newSym(sym.FALSE, yytext());}
if              {return newSym(sym.IF, yytext());}
else            {return newSym(sym.ELSE, yytext());}
while           {return newSym(sym.WHILE, yytext());}
read            {return newSym(sym.READ, yytext());}
print           {return newSym(sym.PRINT, yytext());}
printline       {return newSym(sym.PRINTLINE, yytext());}
return          {return newSym(sym.RETURN, yytext());}
"++"            {return newSym(sym.DOUBLEPLUS, yytext());}
"--"            {return newSym(sym.DOUBLEDASH, yytext());}
"*"             {return newSym(sym.ASTERISK, yytext());}
"/"             {return newSym(sym.FSLASH, yytext());}
"<"             {return newSym(sym.LESSTHAN, yytext());}
">"             {return newSym(sym.GREATERTHAN, yytext());}
"<="            {return newSym(sym.LTEQUAL, yytext());}
">="            {return newSym(sym.GTEQUAL, yytext());}
"=="            {return newSym(sym.CEQUAL, yytext());}
"<>"            {return newSym(sym.LESSGREATER, yytext());}
"||"            {return newSym(sym.COR, yytext());}
"&&"            {return newSym(sym.CAND, yytext());}
"?"             {return newSym(sym.QUESTION, yytext());}
":"             {return newSym(sym.COLON, yytext());}
";"             {return newSym(sym.SEMICOLON, yytext());}
"["             {return newSym(sym.LSQBRACKET, yytext());}
"]"             {return newSym(sym.RSQBRACKET, yytext());}
{id}            {return newSym(sym.ID, yytext());}
{int}           {return newSym(sym.INTLIT, new Integer(yytext()));}
{char}          {return newSym(sym.CHARLIT, yytext());}
{string}        {return newSym(sym.STRLIT, yytext());}
{float}         {return newSym(sym.FLOATLIT, new Float(yytext()));}
{comment}       {return newSym(sym.COMMENT, yytext());}
{blockcomment}  {return newSym(sym.BLOCKCOMMENT, yytext());}
{whitespace}    { /* Ignore whitespace. */ }
.               { System.out.println("Illegal char, '" + yytext() +
                    "' line: " + yyline + ", column: " + yychar); }
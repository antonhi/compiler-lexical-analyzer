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
blockcomment = /\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/
letter = [[[^\n]&&[^\t]]&&[[^\\][^\"]]]|\\\\|\\\"
string = \"{letter}*\"
whitespace = [ \n\t\r]

BinaryOp = \*|\/|\+|-|<|>|<=|>=|==|<>|\|\||&&
Optionalfinal = final|^$
Optionalsemi = ;|^$
OptionalElse = else {Stmt}|^$
Optionalexpr = = {Expr}|^$
Type = int|char|bool|float
Returntype = {Type}|void
ArgdeclList = {Argdecl}, {ArgdeclList}| {Argdecl}
Argdecl = {Type} {id}|{Type} {id} \[\]
Argdecls = {ArgdeclList}|^$
Args = {Expr}, {Args}|{Expr}
Name = {id}|{id} \[{Expr}\]
Expr = {Name}|{id}\(\)|{id}({Args})|intlit|charlit|strlit|floatlit|true|false|\({Expr}\)|\~ {Expr}| \- {Expr}| \+ {Expr}|\({Type}\) {Expr}|{Expr} {BinaryOp} {Expr}|\({Expr} \? {Expr} : {Expr}\)
Readlist = {Name}, {Readlist}|{Name}
Printlist = {Expr}, {Printlist}|{Expr}
Printlinelist = {Printlist}|^$
Stmt = if \({Expr}\) {Stmt} {OptionalElse}| while \({Expr}\) {Stmt}|{Name} = {Expr};|read\({Readlist}\);|print\({Printlist}\);|printline\({Printlinelist}\);|{id}\(\);|{id}\({Args}\);|return;|return {Expr};|{Name}\+\+|{Name}--|{ {Fielddecls} {Stmts} }{Optionalsemi}
Stmts = {Stmt} {Stmts}|^$
Methoddecl = {Returntype} {id} \({Argdecls}\) { {Fielddecls} {Stmts} } {Optionalsemi}
Methoddecls = {Methoddecl} {Methoddecls}|^$
Fielddecl = {Optionalfinal} {Type} {id} {Optionalexpr};
Fielddecls = {Fielddecl} {Fielddecls}|^$
Memberdecls = {Fielddecls} {Methoddecls}
Program = class {id} \{ {Memberdecls} \}

%%
/**
 * LEXICAL RULES:
 */
{id}            {return newSym(sym.ID, yytext());}
{int}           {return newSym(sym.NUMBERLIT, new Integer(yytext()));}
{char}          {return newSym(sym.CHARLIT, yytext());}
{float}         {return newSym(sym.FLOATLIT, new Float(yytext()));}
{string}        {return newSym(sym.STRINGLIT, yytext());}
{comment}       {return newSym(sym.COMMENT, yytext());}
{blockcomment}  {return newSym(sym.BLOCKCOMMENT, yytext());}
{BinaryOp}      {return newSym(sym.BINARYOP, yytext());}
{Type}          {return newSym(sym.TYPE, yytext());}
{Returntype}    {return newSym(sym.RETURNTYPE, yytext());}
{ArgdeclList}   {return newSym(sym.ARGDECLLIST, yytext());}
{Argdecl}       {return newSym(sym.ARGDECL, yytext());}
{Argdecls}      {return newSym(sym.ARGDECLS, yytext());}
{Args}          {return newSym(sym.ARGS, yytext());}
{Name}          {return newSym(sym.NAME, yytext());}
{Expr}          {return newSym(sym.EXPR, yytext());}
{Readlist}      {return newSym(sym.READLIST, yytext());}
{Printlist}     {return newSym(sym.PRINTLIST, yytext());}
{Printlinelist} {return newSym(sym.PRINTLINELIST, yytext());}
{Stmt}          {return newSym(sym.STMT, yytext());}
{Stmts}         {return newSym(sym.STMTS, yytext());}
{Methoddecl}    {return newSym(sym.METHODDECL, yytext());}
{Methoddecls}   {return newSym(sym.METHODDECLS, yytext());}
{Fielddecl}     {return newSym(sym.FIELDDECL, yytext());}
{Fielddecls}    {return newSym(sym.FIELDDECLS, yytext());}
{Memberdecls}   {return newSym(sym.MEMBERDECLS, yytext());}
{Program}       {return newSym(sym.PROGRAM, yytext());}
{whitespace}    { /* Ignore whitespace. */ }
.               { System.out.println("Illegal char, '" + yytext() +
                    "' line: " + yyline + ", column: " + yychar); } 

start           {return newSym(sym.START, "start");}
end             {return newSym(sym.END, "end");}
in              {return newSym(sym.IN, "in");}
out             {return newSym(sym.OUT, "out");}
":)"            {return newSym(sym.SMILE, ":)");}
"("             {return newSym(sym.LPAREN, "(");}
")"             {return newSym(sym.RPAREN, ")");}
":"             {return newSym(sym.COLON, ":");}
number          {return newSym(sym.NUMBER, "number");}
string          {return newSym(sym.STRING, "string");}
flag            {return newSym(sym.FLAG, "flag");}
main            {return newSym(sym.MAIN, "main");}
"<-"            {return newSym(sym.ASSIGN, "<-");}
read            {return newSym(sym.READ, "read");}
write           {return newSym(sym.WRITE, "write");}
call            {return newSym(sym.CALL, "call");}
when            {return newSym(sym.WHEN, "when");}
do              {return newSym(sym.DO, "do");}
done            {return newSym(sym.DONE, "done");}
"-"             {return newSym(sym.MINUS, "-");}
"+"             {return newSym(sym.PLUS, "+");}
"*"             {return newSym(sym.MULTIPLY, "*");}
"/"             {return newSym(sym.DIVIDE, "/");}
up              {return newSym(sym.UP, "up");}
down            {return newSym(sym.DOWN, "down");}
flip            {return newSym(sym.FLIP, "flip");}
"?"             {return newSym(sym.QUESTION, "?");}
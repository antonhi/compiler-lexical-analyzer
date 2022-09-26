JAVA=java
JAVAC=javac
JFLEX=$(JAVA) -jar jflex-full-1.8.2.jar
CUPJAR=./java-cup-11b.jar
CUP=$(JAVA) -jar $(CUPJAR)
CP=.:$(CUPJAR)

default: run

.SUFFIXES: $(SUFFIXES) .class .java

.java.class:
		$(JAVAC) -cp $(CP) $*.java

FILE=    Lexer.java      parser.java    sym.java \
    LexerTest.java

run: sampleFile.utd

all: Lexer.java parser.java $(FILE:java=class)

sampleFile.utd: all
		$(JAVA) -cp $(CP) LexerTest basicRegex.txt > outputRegex.txt
		$(JAVA) -cp $(CP) LexerTest basicFails.txt > outputFails.txt
		$(JAVA) -cp $(CP) LexerTest basicTerminals.txt > outputTerminals.txt
		cat -n outputRegex.txt
		cat -n outputFails.txt
		cat -n outputTerminals.txt

clean:
		rm -f *.class *~ *.bak Lexer.java parser.java sym.java

Lexer.java: tokens.jflex
		$(JFLEX) tokens.jflex

parser.java: grammar.cup
		$(CUP) -interface < grammar.cup

parserD.java: grammar.cup
		$(CUP) -interface -dump < grammar.cup

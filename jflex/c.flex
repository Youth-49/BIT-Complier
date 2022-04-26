/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright (C) 1998-2018  Gerwin Klein <lsf@jflex.de>                    *
 * All rights reserved.                                                    *
 *                                                                         *
 * License: BSD                                                            *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

package bit.minisys.minicc.scanner;

// enum Token_Type{
//     KEYWORD,
//     IDENTIFIER,
//     INT_CONST,
//     FLOAT_CONST,
//     CHAR_CONST,
//     STRING_LITERAL,
//     PUNCTUATOR;
//   }

%%

%public
%class Lexer
// %standalone
// %debug
%type String
%line
%column
%unicode

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator}|[ \t\f]

// Keyword
Keyword = auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|inline|int|long|register|restrict|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while

// Identifier
Identifier = [A-Za-z_][A-Za-z_0-9]*

// Int Const
Integer_Const = {Decimal_Const}{Integer_Suff}?|{Octal_Const}{Integer_Suff}?|{Hexadecimal_Const}{Integer_Suff}?
Decimal_Const = [1-9][0-9]* 
Octal_Const = 0[0-7]*
Hexadecimal_Const = {Hexadecimal_Pre}[0-9A-Fa-f][0-9A-Fa-f]*
Hexadecimal_Pre = 0x|0X
Integer_Suff = [uU][lL]?|[uU](ll|LL)|[lL][uU]?|(ll|LL)[uU]?

// Float Const
Float_Const = {Decimal_Float_Const}|{Hexadecimal_Float_Const}
Decimal_Float_Const = {Fractional_Const}{Exponent_Part}?{Float_Suff}?|{Digit_Seq}{Exponent_Part}{Float_Suff}?
Hexadecimal_Float_Const = {Hexadecimal_Pre}{Hexadecimal_Fraction_Const}{Binary_Exponent_Part}{Float_Suff}?|{Hexadecimal_Pre}{Hexadecimal_Digit_Seq}{Binary_Exponent_Part}{Float_Suff}?
Fractional_Const = {Digit_Seq}?\.{Digit_Seq}|{Digit_Seq}\.
Exponent_Part = e[+-]?{Digit_Seq}|E[+-]?{Digit_Seq}
Digit_Seq = [0-9]+
Hexadecimal_Fraction_Const = {Hexadecimal_Digit_Seq}?\.{Hexadecimal_Digit_Seq}|{Hexadecimal_Digit_Seq}\.
Binary_Exponent_Part = p[+-]?{Digit_Seq}|P[+-]?{Digit_Seq}
Hexadecimal_Digit_Seq = [0-9A-Fa-f]+
Float_Suff = f|l|F|L

// Char Const
Char_Const = \'{C_Char_Seq}\'|L\'{C_Char_Seq}\'|u\'{C_Char_Seq}\'|U\'{C_Char_Seq}\'
C_Char_Seq = {C_Char}+
C_Char = [^\'\\\n\r]|{Escape_Seq}
Escape_Seq = {Simple_Escape_Seq}|{Octal_Escape_Seq}|{Hexadecimal_Escape_Seq}|{Universal_Char_Name}
Simple_Escape_Seq = \\\'|\\\"|\\\?|\\\\|\\a|\\b|\\f|\\n|\\r|\\t|\\v
Octal_Escape_Seq = \\[0-7]|\\[0-7][0-7]|\\[0-7][0-7][0-7]
Hexadecimal_Escape_Seq = \\x[0-9A-Fa-f]+
Universal_Char_Name = \\u{Hex_Quad}|\\U{Hex_Quad}{Hex_Quad}
Hex_Quad = [0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]

// String Const
String_Literal = {Encoding_Pre}?\"{S_Char_Seq}?\"
Encoding_Pre = u8|u|U|L
S_Char_Seq = {S_Char}+
S_Char = [^\"\\\r\n]|{Escape_Seq}

// Operator
// PUNCTUATOR = \[|\]|\(|\)|\{|\}|.|->|\+\+|--|&|\*|\+|-|~|!|/|%|<<|>>|<|>|<=|>=|==|!=|\^|\||&&|\|\||\?|:|;|...|=|\*=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|,|#|##|<:|:>|<%|%>|%:|%:%:
// %state STRING

%%

<YYINITIAL> {

  // White space
  {WhiteSpace} {/* ignore */}

  // Keyword
  {Keyword} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+"";}

  // identifier
  {Identifier} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'Identifier'>,"+(yyline+1)+":"+(yycolumn+1)+"";}

  // literal
  {Integer_Const} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+"";}
  {Float_Const} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+"";}
  {Char_Const} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+"";}
  {String_Literal} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+"";}

  // PUNCTUATOR
  // {PUNCTUATOR} {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "("                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ")"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "{"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "}"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "["                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "]"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "."                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "->"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "++"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "--"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "&"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "*"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "+"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "-"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "~"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "!"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "/"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "%"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "<<"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ">>"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "<"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ">"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "<="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ">="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "=="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "!="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "^"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "|"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "&&"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "||"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "?"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ":"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ";"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "..."                          {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "="                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "*="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "/="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "%="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "+="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "-="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "<<="                          {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ">>="                          {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "&="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "^="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "|="                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ","                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "#"                            {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "##"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "<:"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  ":>"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "<%"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "%>"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "%:"                           {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
  "%:%:"                         {return ""+(yycolumn+1)+":"+((yycolumn+1)+yytext().length()-1)+"='"+yytext()+"',<'"+yytext()+"'>,"+(yyline+1)+":"+(yycolumn+1)+""; }
}
/* error fallback */
[^] { throw new Error("Illegal character <"+yytext()+"> in line: "+(yyline+1)+", column: "+(yycolumn+1)); }
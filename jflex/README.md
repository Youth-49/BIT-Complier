# Some Notes

第一部分将直接复制到生成的Lexer中，包括引入一些库和包，定义package，定义一些变量等。
第二部分是一些选项，具体含义可以查看JFlex User’s Manual。
第三部分是产生式规则和对应的Action，要注意产生式中对字符的转义和正则表达式的书写。

在嵌入BITMini-CC时，要修改yyline、yycolumn和zzAtEOF的private属性为public。

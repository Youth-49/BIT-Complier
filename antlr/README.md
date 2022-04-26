# Some Note

ANTLR: 使用IDEA中的插件: https://plugins.jetbrains.com/plugin/7358-antlr-v4 . 为适应BITMini-CC中的包：/bitmincc-clean/lib/antlr-4.8-complete.jar，选用1.13版本（支持ANTLR 4.8.1）

C语言文法来着于：https://github.com/antlr/grammars-v4/blob/master/c/C.g4 . 其中没有给出文法开始符号，这里添加一条文法规则：

```
program
    :   functionDefinition+
    ;
```

将其直接嵌入BITMini-CC，需要在IDEA中配置ANTLR的输出路径为：BIT-MiniCC\src\bit\minisys\minicc\parser\gen，输出文件同属于包bit.minisys.minicc.parser.gen

使用ANTLR产生的分析器：

```
ANTLRInputStream input = new ANTLRInputStream(in);
CLexer lexer = new CLexer(input);
CommonTokenStream tokens = new CommonTokenStream(lexer);
CParser parser = new CParser(tokens);
ParseTree tree = parser.program(); // program是.g4中定义的第一个非终结符，即为文法开始符
```


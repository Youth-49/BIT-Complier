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

可视化ParserTree：
```

import java.util.Arrays;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import java.awt.Dimension;
import java.awt.Toolkit;
import org.antlr.v4.gui.TreeViewer;

    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    int screenWidth = (int) screenSize.getWidth();
    int screenHeight = (int) screenSize.getHeight();
    JFrame frame = new JFrame("Antlr AST");
    JPanel panel = new JPanel();
    TreeViewer viewer = new TreeViewer(Arrays.asList(
            parser.getRuleNames()),tree);
    viewer.setScale(1.2); // Scale a little
    panel.add(viewer);

    JScrollPane scrollPane = new JScrollPane(panel);
    frame.add(scrollPane);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setSize(screenWidth/2, screenHeight/2);
    //        frame.pack();
    frame.setVisible(true);
```

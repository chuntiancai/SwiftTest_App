
# 一个有具体功能的完整的网页，一般由3部分组成：
    HTML：网页的具体内容和结构。    //主体、结构。
    CSS：网页的样式（美化网页最重要的一块）。 //渲染，装修。
    JavaScript(掌握)： 网页的交互效果，比如对用户鼠标事件做出响应。  //交互。
    HTML\CSS\JavaScript学习资料：http://www.w3school.com.cn/

## HTML的语法：

    > HTML就是一种文本语言，由浏览器负责将它解析成具体的网页内容，所以浏览器就是HTML语言的解释器。
      你说它是标准也行，啥都行，反正就是语言的本质都一样。
      注意：HTML5 中默认的字符编码是 UTF-8。
      
    > 跟XML类似，HTML由N个标签（节点、元素、标记）组成
        1.HTML 元素指的是从开始标签（start tag）到结束标签（end tag）的所有代码。
            开始标签     元素内容     结束标签
            <p>     This is a paragraph     </p>
            <a href="default.htm" >     This is a link     </a>
            <br />     
        
        2.HTML 标签可以拥有属性。属性提供了有关 HTML 元素的更多的信息。
        例如：<a href="default.htm" >     This is a link     </a>
        
        3.剩下的就是浏览器去怎么解析元素的属性，内容，标签这些了。
        
        4.HTML还定义了一些元素自带的UI效果，交互效果。你也可以使用CSS来自定义元素的UI效果。


## CSS的基础知识：
    
    > CSS的全称是Cascading Style Sheets，层叠样式表。它用来控制HTML标签的样式，在美化网页中起到非常重要的作用。
        CSS的编写格式是键值对形式的，比如：
            color: red;
            background-color: blue;
            font-size: 20px;
            冒号:左边的是属性名，冒号:右边的是属性值。

    ###  CSS有3种书写形式:
        > 行内样式：（内联样式）直接在标签的style属性中书写:
            <body style="color: red;">

        > 页内样式：在本网页的style标签中书写:
            <style>
                body {
                    color: red;
                }
            </style>
    
        > 外部样式：在单独的CSS文件中书写，然后在网页中用link标签引用:
            <link rel="stylesheet" href="index.css">



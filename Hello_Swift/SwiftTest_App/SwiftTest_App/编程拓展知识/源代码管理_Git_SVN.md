
GIT
---------
    1、git是一款开源的分布式版本控制工具，在世界上所有的分布式版本控制工具中，git是最快、最简单、最流行的。比SVN快很多。
    2、git比svn多了一个本地版本库管理，而svn是直接提交到服务器。相当于git多了一个本地的库管理缓存。



# GIT命令
##  01. 创建代码库 & 配置个人信息
    1>  创建代码仓库
    $ git init
    $ git init --bare   # 建立空白代码库(专门用于团队开发) 
        在初始化远程仓库时最好使用 git –bare init   而不要使用：git init。这样在使用hooks的时候，会有用处。
    
    2>  配置用户名和邮箱
    $ git config user.name manager
    $ git config user.email manager@gmail.com
    
    * 以上两个命令会将用户信息保存在当前代码仓库中，当前没有用户信息，才会去找全局的用户信息。
    
    3>  如果要一次性配置完成可以使用一下命令
    $ git config --global user.name manager
    $ git config --global user.email manager@gmail.com
    
    * 以上两个命令会将用户信息保存在用户目录下的 .gitconfig 文件中
    
    4>  查看当前所有配置
    $ git config -l

##  02. 实际开发
    1>  创建代码，开始开发
    $ touch main.c
    $ open main.c
    
    2>  将代码添加到代码库
    
    $ git status    # 查看当前代码库状态
    $ git add main.c    # 将文件添加到代码库，xocde会自动帮你执行git add命令。提交到暂存区。
    $ git commit -m "添加了main.c"   # 将修改提交到代码库，把暂存区的所有内容提交到当前分支，并清空暂存区。
    
    提示：
    *   在此一定要使用 -m 参数指定修改的备注信息
    *   否则会进入 vim 编辑器，如果对vim不熟悉，会是很糟糕的事情
    
    $ git add .     # 将当前文件夹下的所有新建或修改的文件一次性添加到代码库
    
    3>  添加多个文件
    $ touch Person.h Person.m
    $ git add .
    $ git commit -m "添加了Person类"
    $ open Person.h
    $ git add .
    $ git commit -m "增加Person类属性"
    
    * 注意 使用git时，每一次修改都需要添加再提交，这一点是与svn不一样的

### git 的重要概念及工作原理
工作区
暂存区(staged)
分支(HEAD)

## 03. 别名 & 日志
    $ git config alias.st status
    $ git config alias.ci "commit -m"
    
    除非特殊原因，最好不要设置别名，否则换一台机器就不会用了

    $ git log    # 查看所有版本库日志
    $ git log 文件名   # 查看指定文件的版本库日志
    
    $ git reflog    # 查看分支引用记录
    
    # 配置带颜色的log别名
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    
    提示：在git中，版本号是一个由SHA1生成的哈希值

## 04. 版本号，让我们在任意版本之间穿梭
    
    $ git reset --hard HEAD     # 回到当前版本，放弃所有没有提交的修改
    $ git reset --hard HEAD^    # 回到上一个版本
    $ git reset --hard HEAD~3    # 回到之前第3个修订版本
    $ git reset --hard e695b67  # 回到指定版本号的版本
    $ git reflog    # 查看分支引用记录
    $ git push -f   #强制推送到共享库
    
    版本回退：
    （版本回退的话，别人也要同样回退，不然会把之前的也提交了。）
    git reset —hard HEAD^ :回到上⼀个版本(张三)
    git push -f :强制上传到共享版本库
    git reset —hard HEAD^ :回到上⼀个版本(经理)
    

## 05、.gitignore 文件的设置
    02、设置.gitignore 文件
    .gitignore 文件可以指定哪些文件不纳入版本库的管理
    参考网址：https://github.com/github/gitignore ，去网址下载文件，然后放到目录中，然后git add
    $ cd /Users/Desktop/git演练/经理/weibo  # 命令行中进入与.git同级的目录
    $ git add .gitignore    # 将.gitignore添加到代码库

## 06、分支管理 
    
    $ git tag        # 查看当前标签
    $ git tag -a v1.0 -m 'Version 1.0'       # 在本地代码库给项目打上一个标签
    $ git push origin v1.0      # 将标签添推送到远程代码库中
    
    
    
    # 使用tag，就能够将项目快速切换到某一个中间状态，例如产品开发线上的某一个稳定版本

    ## #查看分支
        $ git branch -a   //查看本地和远程仓库的所有分支
        $ git branch -r   //查看远程仓库的分支
        $ git reflog    // 查看分支引用记录
        
    ## #创建、切换、删除分支
        $ git checkout v1.0     # 切换v1.0分支。
        $ git checkout -b bugfix1.0  origin/develop   # 切换并创建v1.0bugfix分支，该分支对应远程的develop分支，不指定则是当前工作分支的分支。
        $ git push origin local_branch:remote_branch    #根据本地分支创建远程分支。
        $ git branch -r     # 查看远程分支
        $ git branch -r -d origin/bugfix1.0      # 删除远程分支。
        $ git push origin :remote_branch      #推送空分支到远程分支，也是删除远程分支的一种方式。
        
        /*
         1、在当前分支添加或者删除文件，切换到另外一个分支的时候，这些添加或者删除的文件会被移除或者还原，也就是不影响别的分支的文件结构。
         2、删除文件后，回滚，是肯定可以还原被删除的文件的啊。前提是你这些文件有加入到git的管理文件中。也就是没有在.gitignore文件中忽略掉这些文件。 
        */
        
        查看分支：git branch
        创建分支：git branch <name>
        切换分支：git checkout <name>或者git switch <name>
        创建+切换分支：git checkout -b <name>或者git switch -c <name>
        合并某分支到当前分支：git merge <name>
        
    ## #合并分支
        $ git pull  # 取回远程主机某个分支的更新，再与本地的指定分支合并. 是git fetch后跟git merge FETCH_HEAD的缩写。
        $ git pull <远程主机名> <远程分支名>:<本地分支名>
        $ git fetch  #相当于是从远程获取最新版本到本地，不会自动合并
        $ git merge 分支1 分支2    #git merge命令用于将两个或两个以上的开发历史加入(合并)一起。在当前分支的顶部，使它们合并。
        
        //拉取远程分支、合并的示例：
        $ git fetch origin master   #首先从远程的origin的master主分支下载最新的版本到origin/master分支上
        $ git log -p master..origin/master  #然后比较本地的master分支和origin/master分支的差别
        $ git merge origin/master #最后进行合并
        
    ## #常用于处理合并冲突的命令
        $ git rm text1.txt  #用于从工作区和索引中删除文件。 
        $ git rm -r directory   # 删除文件夹。
        $ git checkout text1.txt    #撤销对text1.txt的修改。
        $ git reset  分支或提交   #用于复位或恢复更改,复位分支指针的位置。
        
        $ git reset [--hard|soft|mixed|merge|keep] [<commit>或HEAD]
        //将当前的分支重设(reset)到指定的<commit>或者HEAD(默认，如果不显示指定<commit>，默认是HEAD，即最新的一次提交)，
          并且根据[mode]有可能更新索引和工作目录。mode的取值可以是hard、soft、mixed、merged、keep。
        //执行git reset时，git会把reset之前的HEAD放入.git/ORIG_HEAD文件中，命令行中使用ORIG_HEAD引用这个提交。
        
        //示例： 重置单独的一个文件 
        $ git reset -- text1.txt                    #(1) 把文件frotz.c从索引中去除。
        $ git commit -m "Commit files in index"     #(2) 把索引中的文件提交。
        
        



## 07、共享版本库、版本备份
    ⼆.共享版本库
    git服务器的搭建⾮常繁琐(linux)
    可以把代码托管到(Github/OSChina)
    ⼀个⽂件夹
    ⼀个U盘
    1.⼀个⽂件夹作为共享版本库
    git init —bare
    2.将共享版本库的所有内容下载到本地
    git clone 共享版本库地址
    3.删除忽略⽂件
    touch .gitignore —> Github ->搜索”.gitignore” -> 选择*最多的->找到
    Object-C,复制下来
    4.版本回退
    git reset —hard HEAD^ :回到上⼀个版本(张三)
    git push -f :强制上传到共享版本库
    git reset —hard HEAD^ :回到上⼀个版本(经理) 
    
    三.版本备份(了解)
    1.1.0版本开发完毕,将1.0版本上传到AppStore,对1.0版本进⾏备份(打上标签)
    git tag -a weibo1.0 -m “这是1.0版本”
    git tag
    
    2.需要将标签push到共享版本库
    git push origin weibo1.0
    
    3.开始2.0版本的开发
    
    4.发现1.0版本有bug,在经理的⽂件夹下⾯创建⼀个⽂件夹,⽤于修复bug,将共享版本库所有内容clone
    git clone
    
    5.将当前的代码转为1.0标签,创建分⽀,并切换到该分⽀
    git checkout weibo1.0 : 转为1.0标签
    git checkout -b weibo1.1fixbug : 创建分⽀,并切换到该分⽀
    
    6.在分⽀中修复bug,上传到AppStore,将修复好的版本,打上tag,并上传到共享版本库
    git tag -a weibo1.1 -m “这是修复了1.0bug的1.1版本”
    git push origin weibo1.1
    
    7.跟当前正在开发的2.0版本进⾏合并
    source Control - > pull ->weibo1.1fixbug
    
    8.删除分⽀
    git branch :查看当前在哪个分⽀
    git branch -r :查看本地版本库的分⽀
    git branch -d weibo1.1fixbug : 删除本地分⽀
    git branch -r -d origin/weibo1.1fixbug :删除本地版本库分⽀
    git push origin —delete weibo1.1fixbug
    
    四.新⼈代码仓库
    创建⼀个⽂件夹作为共享版本库
    项目经理 xocde项空的代码仓库push代码 source control -> configuration -> 添加共享版本库地址
    
    五.Github上托管代码
    1.使⽤HTTPS认证
    2.使⽤SSHKeys认证
    公钥 : 存在github上⽤来解密
    私钥 : 存在本地的⼀个.ssh⽂件夹下⽤来加密
    
    六、OSCHINA创建私有的git仓库是免费的，也就是码云，gitee。
        私有仓库就是不给别人看，github是必须开源给别人看的，只是限制别人提交而已。
        OSCHINA是开源中国的，也就是中国的，所以网速很快。



SVN
--------------------------------------
    全称是Subversion，集中式版本控制之王者，是CVS的接班人，速度比CVS快，功能比CVS多且强大。
    服务器集中管理所有的版本，客户端需要手动上传和下拉代码。与Git不同的是 服务器集中式管理一份完整的源代码，Git是每一个客户端都保存完整的源码。
    你可以在window上搭建服务器。mac上搭建客户端。
    
    提醒:
    每天下班前：commit“可运行版本”
    每天上班前：update前一天所有代码



# SVN命令
svn checkout : 将服务器代码完整的下载到本地。
svn commit : 将本地修改的内容,提交到服务器。
svn update : 将服务器最新的代码下载带本地。

       ⼀.命令⾏的演⽰
        1.项目经理将服务器的已有的内容下载到本地
            svn checkout 服务器地址 —username=mgr —password=mgr
        2.项目经理初始化项目
            touch main.m :创建main.m
            svn add main.m : 将main.m添加到svn的管理之下
            svn commit -m “初始化项目” main.m : 将main.m上传到服务器
        3.查看⽂件状态(查看⽂件是否在svn的管理之下,或者是否进⾏了修改⽽没有提交)
            svn status
            ? : 不在svn的管理之下
            A : 该⽂件在已经添加到svn的管理之下,但是该⽂件在本地,并没有提交到服务器
            M : 该⽂件在本地已经被修改,但是没有传到服务器
            D : 该⽂件在本地已经删除,但是服务器依然有该⽂件,删除操作没有更新到服务器
        4.张三加⼊开发
        1> 将服务器所有的内容下载到本地
            svn checkout 服务器地址 —username=zs —password=zs
        2> 开始开发
            touch person.h person.m :创建person类
            svn commit -m “创建了person类”
        3> 经理更新代码
            svn update:更新服务器最新的代码(如果该⽂件在本地不存在,则下载,如果本地存在,则更新)
        5.命令⾏的简写
            svn checkout -> svn co
            svn status -> svn st
            svn commit -> svn ci
            svn update -> svn up
        6.版本回退
            svn revert person.h : 删除本地新增的内容(没有提交到服务器)
            svn update -r6 : 先回退到某个版本,观察下,该版本是否是你想要的那个版本
            svn update : 更新到最新的版本
            svn merge -r7:6 person.h        //所以把版本号从6变成7之后再提交，r7是指第7版本的意思，revision，只回退person.h文件。
            注意:如果本地版本号低于服务器的版本号,那么不能提交
        7.删除⽂件
            svn remove(rm) person.m
        8.查看版本信息
            svn update : 更新服务器最新的内容
            svn log :查看版本信息
        9.公司常⽤的命令
            svn update : 更新服务器代码到本地。
            svn commit -m “注释” :将本地的代码提交到服务器。
        ⼆.李四加⼊开发(李四进⼊公司)
        1> 需要向项目经理要⼀些东⻄和项目经理要服务器的地址,以及账号和密码
            需求⽂档 : 有什么需求,做什么样的功能
            接⼝⽂档 : 详细的记录服务器所有的接⼝
            效果图: 界⾯到底⻓成什么样⼦
        2> 将服务器已有的内容下载到本地
            svn checkout 服务器地址 账号和密码
            touch dog.h dog.m :创建dog类
            svn add * : 将不在svn管理之下的所有⽂件添加到svn的管理之下
            svn commit -m “添加dog类” :
        3> 代码冲突
            out of date : 过期,本地版本号低于服务器的版本
            df : 在命令⾏中展⽰所有的不同
            e : 在命令⾏中来编辑冲突
            mc: ⽤我的本地的代码来覆盖服务器的代码
            tc : ⽤服务器的代码来覆盖我的代码
            p : 延迟解决冲突,展⽰所有冲突的⽂件,⼿动解决冲突，删除那些===>>>>>符号  -> svn resolved person.h
        注意 :
        1 > 尽量在修改⽂件之前,先update
        2 >如果修改公共⽂件,最好跟同事说⼀声,让他先别修改,修改完之后,让他更新
        三.图形化界⾯⼯具
        1.项目经理初始化项目
        1> 项目经理将服务器已有的内容下载到本地
            记住format的选择 —> 1.7
        2> 需要忽略的⽂件
            xcode会默认记录之前停留⽂件,下次打开依然停留在该⽂件,这个不需要共享
            xcode会默认记录之前目录的打开情况,同事不需要共享
            断点信息,不需要进⾏共享
            xcuserdata
            
        2.在xcode中使⽤svn的注意点
            Source Control --> commit
            Xcode --> preferences --> Accounts --> + --> Xcode Sever
            文件名右边的A字母：表示文件还没添加进管理，是新增文件。
            'A'  新增
            'D'  删除
            'M'  修改
            'R'  替代
            'C'  冲突
            'I'  忽略
            '?'  未受控
            '!'  丢失，一般是将受控文件直接删除导致
        1> 如果使⽤到静态库需要特别注意,必须使⽤命令⾏将静态库添加到svn的管理之下。
        2> 如果使⽤到了storyboard也需要特别注意
            如果能使⽤xib,尽量使⽤xib，因为是一个人在维护。
            如果在项目当中使⽤到了storyboard,尽量保证只有⼀个⼈在操作storyboard，因为解决冲突眼花缭乱，是xml文件。
        3> checkout的⽅式
            使⽤命令⾏
            使⽤cornerstone(图形化界⾯⼯具)
            Xcode
        4> 公司开发技巧(避免冲突)
            尽量写⼀些代码就提交到服务器,时时跟服务器的代码保持同步
            尽量提前半⼩时提交代码,5.00


## SVN的目录结构：
    正规项目的SVN目录结构一般有3个文件夹：
        trunk：主干，当前开发项目的主目录
        branches：分支目录，添加非主线功能时使用，开发测试之后，可以合并到主干项目中
        tags：标记目录，通常作为重大版本的备份


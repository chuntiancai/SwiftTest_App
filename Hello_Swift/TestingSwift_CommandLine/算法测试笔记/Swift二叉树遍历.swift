//
//  Swift二叉树遍历.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/7.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
    1、所谓先，中，后序遍历，是指根节点的操作是在先、中、后。以根节点的操作顺序为主。
        遍历不意味着输出该节点的信息，也不意味中输出该节点的序号，所以可以只是路过，并没有操作。
 */


import Foundation

struct SwiftBinaryTreeBrowseStruct {
    
    //MARK: 先序遍历。根据先序和中序构建二叉树。中序求和
    static func testDLRandLDR(){
        
        //根据先序遍历、中序遍历还原二叉树。

        let midOrderArr = readLine()!.split(separator: " ").map { Int($0)!}    //中序遍历序列号
        let leftOrderArr = readLine()!.split(separator: " ").map { Int($0)!}    //先序遍历序列号

        /**
            一棵树的前中后序列号个数都是一样的啊，因为一棵树的节点个数是一样的。
            1、找出根节点在中序序列的哪个位置，因为节点的值可能是重复的。
                先序的首元素是根节点。
                中序的左、右子树序列的数量和顺序完全和先序的一样。
            2、从根节点，分割左右子树。
            3、重复1、2步操作。
         
            问题规模：先序序列和中序序列的个数多少，都是同时减少的。
            递进关系：如何从上一层传递信息给下一层递归，序列的索引，即数组减少。如何递进？根节点，数组索引减少，或者个数减少。
            边界条件：数组个数为0，或索引重合了。返回值是啥？是一个二叉树的数据结构，把遍历的点挂在结构体上。
         
         */
        class TreeNode{
            internal init(value: Int? = nil, leftNode: TreeNode? = nil, rightNode: TreeNode? = nil) {
                self.value = value
                self.leftNode = leftNode
                self.rightNode = rightNode
            }
            
            
            var value:Int?
            var leftNode:TreeNode?
            var rightNode:TreeNode?
            var sumValue:Int = 0    //左右子树的和
            
        }

        /// 构建二叉树，给出先序序列和中序序列，还原二叉树。给出前中序列，返回这个二叉树的根节点。
        /// 问题就变成了找出根节点，找出左树的根节点，右树的根节点，然后分别挂在根节点的左右端就可以了。然后就分割成从左右子树的前中序列找根节点。
        /// - Parameters:
        ///   - leftArr: 先序序列数组
        ///   - midArr: 中序序列数组
        func buildTree(leftArr:[Int],midArr:[Int]) -> TreeNode?{
            
            if leftArr.count != midArr.count || leftArr.count < 1 {  //序列的个数必须是一样的啊。
                return nil
                
            }
            if leftArr.count == 1 { //到叶子结点了，直接返回
                return TreeNode(value: leftArr[0], leftNode: nil, rightNode: nil)

            }
            //1、从先序列，找出该树的根节点。
            let rootNode = TreeNode(value: leftArr[0], leftNode: nil, rightNode: nil)
            
            //2、找出左子树的前、中序列
            /**
                1.根据当前根节点和中序列，分割成左右子树，从而找出左右子树的前、中序列。
             */
            //找出中序列中，根节点值有多少个重复，而且位置在哪
            var roorIndexArr:[Int] = [] //根节点在中序列中的位置。
            for (index,value) in midArr.enumerated() {
                if value == rootNode.value {
                    roorIndexArr.append(index)
                }
            }
            //判断哪个是真正的根节点。从中序列中找出左子树的前序列，中序列中 左子树的中序列，比较个数和值是否相等，顺序可以不等。
            for index in roorIndexArr {
                let midPreArr = index == 0 ?  [Int]() : Array(midArr[0..<index])     //中序列左子树,一个结点时，证明没有左子树
                let leftPreArr = index == 0 ? [Int]() : Array(leftArr[1...index])   //前序列左子树,一个结点时，证明没有左子树
                
                
                let midSufArr = (index + 1) < midArr.count ? Array(midArr[(index + 1)...]) : [Int]()   //中序列右子树
                let leftSufArr = (index + 1) < midArr.count ? Array(leftArr[(index + 1)...]) : [Int]()   //前序列右子树
                
                let midPreArrSorted = midPreArr.sorted()
                let leftPreArrSorted = leftPreArr.sorted()
                let isPreRoot = (midPreArrSorted == leftPreArrSorted) ? true : false
                let isSufRoot = (midSufArr.sorted() == leftSufArr.sorted()) ? true : false
                
                if isPreRoot && isSufRoot { //确定该点是根节点，挂载左右子树。
                    rootNode.leftNode = buildTree(leftArr: leftPreArr, midArr: midPreArr)
                    rootNode.rightNode = buildTree(leftArr: leftSufArr, midArr: midSufArr)
                    break
                }
            }
            
            //3、返回当前节点，当前二叉树的根节点
            return rootNode
            
        }

        var curMidOrderArr = [Int]()
        var curMidSumArr = [Int]()   //中序遍历求和序列。
        //对二叉树进行中序遍历。求和需要在遍历的时候保留状态，所以你看是数组保留状态还是什么。可以直接在节点的结构中保留
        // 求和状态直接在节点的数据结构中保留，如何在递进中传递？返回值还是第三方标志器？数组标志器还是变量标志器？
        func getMidOrder(rootNode:TreeNode? ) -> Int{    //返回当前节点左、右子树、自己的求和值
            guard let root = rootNode else{
                print("到达叶子结点了")
                return 0;
            }
            
            let leftSum = getMidOrder(rootNode: root.leftNode)
            curMidOrderArr.append(root.value!)  //操作当前节点
            let rightSum = getMidOrder(rootNode: root.rightNode)
            
            root.sumValue = leftSum + rightSum  // 求和左右子树的值
            return root.sumValue + (root.value ?? 0)    //返回当前指数的所有值
            
        }

        //获取求和值的序列
        func getMidSumOrder(rootNode:TreeNode? ){
            guard let root = rootNode else{
                print("到达叶子结点了")
                return;
            }
            
            getMidSumOrder(rootNode: root.leftNode)
            curMidSumArr.append(root.sumValue)  //操作当前节点
            getMidSumOrder(rootNode: root.rightNode)
            
        }

        let rootNode = buildTree(leftArr: leftOrderArr, midArr: midOrderArr)
        let _ = getMidOrder(rootNode: rootNode)
        getMidSumOrder(rootNode: rootNode)


        print("中序遍历的结果:",curMidOrderArr)
        print("中序遍历求和的结果:",curMidSumArr)

        print("end")
        
    }
    
    
    
    
}

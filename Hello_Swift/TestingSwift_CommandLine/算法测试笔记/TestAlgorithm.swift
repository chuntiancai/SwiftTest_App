//
//  TestAlgorithm.swift
//  SwiftTest_CommandLine
//
//  Created by mathew2 on 2021/4/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 算法测试的demo

import Foundation

struct TestAlgorithm {
    
    //MARK:桶排序
    static func bucketSort(){
        //桶排序主要利用了数组的下标特性，或者是链表的特性，通过数组的下标来理解会比较简单，也就是，目标数组的元素值就是缓存数组的下标值，利用数组的下标作为标志器。
        //所以他的空间复杂度度位很大，可以通过链表解决。时间复杂度为kn
        //核心思想：为每一个目标数组中的元素都建立一个标志器。也就是标志器的集合了，利用字典。
        var numArr = [23,986,12,16541,78,15,5,956,45,85,76]
        print("桶排序前：\(numArr)")
        var flagDict = Dictionary<Int,Int>()
        for val in numArr{
            if let curVal = flagDict[val] {
                flagDict[val] = curVal + 1
            }else{
                flagDict[val] = 1   //为目标数组中的每一个元素建立标志器，c语言中可以用链表
            }
        }
        let keysSort = flagDict.keys.sorted()
        var cur = 0
        for key in keysSort{
            if let val = flagDict[key] {
                for _ in 1...val {
                    numArr[cur] = key
                    cur = cur + 1
                }
            }
            
        }
        print("桶排序后：\(numArr)")
        
    }
    
    //MARK:快速排序
    static func quickSortTest(){
        //核心思想：随机选择一个元素作为哨兵，小的插在前面，大的插在哨兵后面。递归处理，分而治之。最差的复杂度也是n的平方。
        //注意与选择排序区分，选择排序是保持哨兵在未排序的第0位
        var numArr = [56,32,565,845,66,15,13213,48,45,85,999]
        let fIndex = numArr.count / 2
        print("快速排序前：\(numArr)")
        
        //合并两个左右已经排序好的数组，和归并排序一样。
        func mergeQuick(numArr: inout [Int],start:Int,flag:Int,end:Int){
            let referArr = numArr    //作为比较和参考的标志器数组
            var leftStart = start
            var rightStart = flag
            var cur = start
            while leftStart<flag && rightStart<end {
                if referArr[leftStart] < referArr[rightStart] {
                    numArr[cur] = referArr[leftStart]
                    leftStart = leftStart + 1
                }else{
                    numArr[cur] = referArr[rightStart]
                    rightStart = rightStart + 1
                }
                cur = cur + 1
            }
            if leftStart<flag{  //当前点还没移动到目标数组中
                numArr[cur..<end] = referArr[leftStart..<flag]
            }
            
        }
        
        //递归函数作用：随机选中一个点，大于的插在数组后面，小于的插在数组前面,end是边界外
        func quickSort(numArr: inout [Int],start:Int,flag:Int,end:Int){
            //结束条件，数组只有一个元素时，返回。
            if end - start <= 1 {
                return
            }
            //递归函数
            //1、处理左边数组
            let start1 = start
            let end1 = flag
            let flag1 =  (start1 + end1) / 2
            quickSort(numArr: &numArr, start: start1, flag: flag1, end: end1)
            
            //2、处理右边数组
            let start2 = flag
            let end2 = end
            let flag2 =  (start2 + end2) / 2
            quickSort(numArr: &numArr, start: start2, flag: flag2, end: end2)
            
            //3、排序整个数组
            mergeQuick(numArr: &numArr,start:start,flag:flag,end:end)
        }
        
        quickSort(numArr: &numArr, start: 0, flag: fIndex, end: numArr.count)
        print("快速排序后：\(numArr)")
    }
    
    //MARK: 归并排序
    static func mergeSortTest(){
        //核心思想：使用递归，明确函数作用，确定递归基，编写函数体；拆分，排序，合并。分而治之
        //工具：借助缓存数组。因为不能真正的把数组给拆开再合并，所以可以通过下标实现这种拆开合并的效果。下标作为递归函数的参数，以起到拆分合并数组的作用。
        //缓存数组：实际被操作。目标数组：等待排序后的成果。
        //因为没有返回值，所以缓存数组要当作参数传入，为了保证目标数组一直都存在，而缓存数组才是真正被排序的数组，然后复制到目标数组中。
        //易错点：操作着操作着缓存数组，又突然操作了目标数组，要记住，缓存数组是做参考和比较的，目标数组不可以做比较，因为要赋值了。
        var numArr = [56,45,89,76,12,90,675,12,356,43,45463,8489,45,85,999]
        print("归并排序前：\(numArr)")
        //认为numArr的左边排序好了，右边也排序好了，现在只需要合并了，end是边界外
        func merge(numArr:inout [Int],start:Int,mid:Int,end:Int){
            let helpArr:[Int] = numArr
            var leftStart = start
            var rightStart = mid
            var cur:Int = start
            while leftStart<mid && rightStart<end {
                if helpArr[leftStart]<helpArr[rightStart]{
                    numArr[cur]=helpArr[leftStart]
                    leftStart = leftStart + 1
                }else{
                    numArr[cur]=helpArr[rightStart]
                    rightStart = rightStart + 1
                }
                cur = cur + 1
            }
            if leftStart<mid {
                numArr[cur..<end] = helpArr[leftStart..<mid]
            }
        }
        //函数的作用：传入一个数组，对它进行排序，左边排序，右边排序，然后合并。end是边界外。
        func mergeSort(numArr:inout [Int],start:Int,mid:Int,end:Int){
            //结束条件是，数组只有一位元素时，证明数组已经排好序了，返回，函数没有返回值
            if end - start <= 1 {
                return
            }
            //拆分
//            let helpArr1:[Int] = Array<Int>(numArr[start..<mid])
            let start1 = start
            let end1 = mid
            let mid1:Int = (start1 + end1 ) / 2
            mergeSort(numArr: &numArr, start: start1, mid: mid1, end: end1)   //认为左边排序好了
            
//            let helpArr2 = Array<Int>(numArr[mid..<end])
            let start2 = mid
            let end2 = end
            let mid2:Int = (start2 + end2 ) / 2
            mergeSort(numArr: &numArr, start: start2, mid: mid2, end: end2)   //认为右边排序好了
            
            //合并
            merge(numArr:&numArr,start:start,mid:mid,end:end)
        }
//        let tHelpArr = numArr
        let mid:Int = numArr.count / 2
        mergeSort(numArr: &numArr,  start: 0, mid: mid, end: numArr.count)
        print("归并排序后：\(numArr)")
    }
    
    //MARK: 归并数组测试
    static func mergeArrSortTest(){
        let numArr = [56,89,90,356,8489,9999]
        let numArr2 = [6,89,95,356,8490,9000]
        var outArr = [Int]()
        print("归并排序前：\(numArr)")
        print("归并排序前：\(numArr2)")
        //认为numArr的左边排序好了，右边也排序好了，现在只需要合并了，end是边界外
        var leftStart = 0
        var rightStart = 0
        while leftStart<numArr.count && rightStart<numArr2.count {
            if numArr[leftStart]<numArr2[rightStart]{
                outArr.append(numArr[leftStart])
                leftStart = leftStart + 1
            }else if numArr[leftStart]==numArr2[rightStart]{
                
                outArr.append(numArr2[rightStart])
                leftStart = leftStart + 1
                rightStart = rightStart + 1
            }else{
                outArr.append(numArr2[rightStart])
                rightStart = rightStart + 1
            }
        }
        if leftStart<=(numArr.count-1) {
            print("numArr没有使用完，：\(leftStart)")
            outArr = outArr + numArr[leftStart..<numArr.count]
        }
        if rightStart<=(numArr2.count-1) {
            print("numArr2没有使用完，：\(rightStart)")
            outArr = outArr + numArr2[rightStart..<numArr2.count]
        }
        print("归并后:\(outArr)")
    }
    
    //MARK: 选择排序
    static func selectionSort(){
        //核心思想：每次选中最小的放在前面，哨兵是未确定排序第0位元素，不断遍历一直把哨兵更新到最后一位，那么该数组就全部排好序了
        //难点在于：如何保持哨兵一直都是未排序的第0位元素。借助标志器。或者说缓存空间。所有的算法基本上都是借助缓存空间，缓存空间可以是一位也可以是多位。可以是一组，也可以是多组。
        var numArr = [56,45,89,76,12,90,675,356,43]
        print("选择排序前：\(numArr)")
        for i in 0..<numArr.count { //这里的标志器是numArr[i]
            for j in i ..< numArr.count {   //选择排序的时间复杂度也是n的平方，但是交换的次数比冒泡排序要少
                let tmp = numArr[i]
                if tmp > numArr[j]{
                    numArr[i] = numArr[j]
                    numArr[j] = tmp
                }
            }
        }
        print("选择排序后：\(numArr)")
        
    }
    
    //MARK: 递归查找
    static func diguiFind(numArr:[Int]) -> Int{
        //1、明确函数的作用，寻找返回值
        //2、寻找递归基，函数结束条件
        //3、编写递归函数的实现，1和整体的思想，1的时候怎么做，整体的时候怎么做，然后编写代码。
        // 目标：返回数组中的最大值
        // 递归基：但数组只有一个元素的时候，该值就是最大值，这就是分而治之的思想，不要想过过程，想的是如何把问题规模缩小，当规模达到一的时候怎么处理
        // 递归函数：把传入的数组进行拆分，分而治之。
        if numArr.count == 1 {
            return numArr[0]
        }
        let midIndex:Int = numArr.count / 2
        var leftArr:[Int] = [Int]()
        for index in 0..<midIndex{
            leftArr.append(numArr[index])
        }
        var rightArr:[Int] = [Int]()
        for index in midIndex..<numArr.count{
            rightArr.append(numArr[index])
        }
        let leftMax = diguiFind(numArr: leftArr)
        let rightMax = diguiFind(numArr: rightArr)
        if leftMax < rightMax {
            return rightMax
        }else{
            return leftMax
        }
    }
    
    //MARK:  二分查找，寻找值的下标
    static func BinaryFind(){
        let tmpfind = 8 //寻找的值
        //二分查找的关键点在于寻找哨兵，中间点,上下限的哨兵的下标不断向目标值的下标靠拢，关键点在于通过值来移动哨兵的下标
        let numArr = [1,2,3,4,5,6,7,9,10,11]
        var midIndex:Int = numArr.count/2
        var lIndex = 0
        var rIndex = numArr.count - 1
        while lIndex <= rIndex {
            midIndex = (lIndex + rIndex) / 2
            if numArr[midIndex] == tmpfind {
                break
            }
            if numArr[midIndex] < tmpfind {
                lIndex = midIndex + 1
            }else {
                rIndex = midIndex - 1
            }
        }
        print("左哨兵的下标：\(lIndex),右哨兵的下标：\(rIndex) ,下标：\(midIndex)---值：\(numArr[midIndex])")
    }
    
    //MARK:  寻找第一个非重复的字符
    static func findFirstCharacter(){
        let str = "gjgjkjhftuyuxhgfcjhvyxrygaer"
        //两个字符数组用于筛选出重复的字符元素，关键点在于，数组A用于储存未遍历过的元素，数组B用于存储遍历过但重复的元素，然后用便利数组A，查看第一个不被包含在数组B中的元素，即为所求。
        //这里还没处理第一个字符的情况
        var arr = Array<Character>()
        var arr1 = Array<Character>()
        for charc in str {
            if arr.contains(charc) {
                arr1.append(charc)
            }else{
                arr.append(charc)
            }
        }
        print("原始数组",str)
        print("未遍历过的数组：",arr)
        print("含有重复元素的数组：",arr1)
        for charc2 in arr {
            if !arr1.contains(charc2){
                print("第一个不重复的字符元素：",charc2)
                break
            }
        }
    }
    
    //MARK: 刷选出数组中的重复元素并去掉，利用集合的特性，也可以利用哈希
    static func shaixuan(){
        let arr = ["a","b","c","d","e","f","a","b","c","j","a"]
        print("原始数组：",arr)
        
        let set = Set(arr)
        let arr1 = Array(set)
        print("用set过滤重复元素：",arr1)
        
        var dict = Dictionary<String,Any>()
        for item in arr {
            dict[item] = item
        }
        print("用字典过滤重复元素：")
        print(Array(dict.keys),terminator: " ")
    }
    
    //MARK: 逆序输出
    static func nixu(){
        var arr = ["a","b","c","d","e","f","g","h","i","j","k"]
        print("逆序前：")
        for element in arr{
            print(element,terminator: " ")
        }
        //关键在于判断数组的元素个数是奇数还是偶数,还有中点元素下标的处理，已经向下取整了，数组越界处理。
        //注意最后一个元素的下标，和数组个数的平均值的大小关系，因为数组个数的平均值刚好是数组长度的重点，奇数向下取整后的平局值刚好就是中点元素的下标，偶数向下取整的平局值刚好也是中点元素的下标，都是相当于减去1.
        //因为元素的下标刚好是数组个数减去1，所以，中点元素的下标值，恰好就是个数平局值的向下取整，因为一个是从零开始，一个是从1开始的自然数。
        let midIndex:Int = arr.count / 2
        for index in 0 ... midIndex {
            let tmp = arr[index]
            let lastIndex = arr.count - 1
            arr[index] = arr[lastIndex-index]
            arr[lastIndex-index] = tmp
        }
        print("\n逆序后：")
        for element in arr{
            print(element,terminator: " ")
        }
    }
    //MARK:  冒泡排序
    static func maopao(){
        var arr = [56,45,89,76,12,90,675,356,43]
        print("排序前：")
        for element in arr{
            print(element,terminator: " ")
        }
        for index in 0 ..< arr.count {
            for j in 0 ..< arr.count - 1 - index {  //从大到小，大在前，降序排序，每一次都把最小的放在最后
                if arr[j] < arr[j+1]{
                    let tmp = arr[j]
                    arr[j] = arr[j+1]
                    arr[j+1] = tmp
                }
                
            }
        }
        print("\n排序后：")
        for element in arr{
            print(element,terminator: " ")
        }
    }
    
    
}
//MARK: 工具方法，获取随机数
extension TestAlgorithm{
    
    /// 获取随机整数
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值
    static func randomInt(min:Int,max: Int) -> Int {
        let rInt = Int(arc4random_uniform(UInt32(max-min)))
        return min + rInt
    }
}

//
//  XibFile_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/4.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//  测试，xib绑定VC的view
//MARK: - 笔记
/**
    1、xib的文件名要和vc的名字相同。
      vc初始化时，默认会去寻找同名的xib，会去调用initWithNibName寻找：
            init ->  initWithNibName 1.首先判断有没有指定nibName 2.判断下有没有跟类名同名xib。
    2、xib文件的placeholder的file's owner中要绑定vc的类，file's owner要连线xib的view，建立起 vc --> file owner --> view 的连线。
        file's owner侧边栏绑定vc的类 => 按住ctrl + 点击file owner => outlet 连线xib里面的view。
    
    3、绑定之后，默认xib的view就是vc的view了。
 
    4、storyboard要通过storyboard的代码方式来创建vc。
 */

class XibFile_VC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("XibFile_VC的\(#function)方法")
    }
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("XibFile_VC的\(#function)方法")
    }
    
    required init?(coder: NSCoder) {
        print("XibFile_VC的\(#function)方法")
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Xib的VC"
        imgView.image = UIImage(named: "labi03")
        
    }
    

}


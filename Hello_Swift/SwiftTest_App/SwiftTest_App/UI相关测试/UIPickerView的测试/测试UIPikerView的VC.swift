//
//  测试UIPikerView的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/26.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//  测试UIPikerView的VC

class TestUIPickerView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var pickerView = UIPickerView() //选择器
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIPikerView的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIPickerView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            print("     (@@  ")
            break
        case 1:
            //TODO: 1、
            print("     (@@ ")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 遵循UIPikerView的代理协议,UIPickerViewDelegate,UIPickerViewDataSource
extension TestUIPickerView_VC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    //MARK: 设置有多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //MARK: 设置每一列有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 5
        case 1:
            return 6
        case 2:
            return 7
        default:
            return 7
        }
    }
    
    //MARK: 设置每一列的宽度
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        switch component {
        case 0:
            return 80
        case 1:
            return 100
        case 2:
            return 120
        default:
            return 80
        }
    }
    //MARK: 设置每一行的高度
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        switch component {
        case 0:
            return 50
        case 1:
            return 60
        case 2:
            return 70
        default:
            return 60
        }
    }
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    //MARK: 设置每一个单元格的标题
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
//        return "[\(component),\(row)]"
//    }
    
    // attributed title is favored if both methods are implemented
    /// 如果和titleForRow方法同时实现，会优先选择富文本的标题，但是如果富文本返回nil的话，会报错找不到文本对象，从而崩溃。
    //MARK: 设置每一个单元格的富文本标题
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?{
        if component ==  0 && row == 3{
            return NSAttributedString.init(string: "富文本标题", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red.cgColor,
                                                   NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
        }
        return NSAttributedString(string: "\(component),\(row)")
    }
    
    //MARK: 设置每一个单元格的自定义view
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
//
//        let curView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
//        curView.layer.borderWidth = 0.5
//        curView.layer.borderColor = UIColor.blue.cgColor
//        return curView
//    }
    
    //MARK: 告知选中了哪个view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("选中了：[\(component),\(row)]")
    }
}
   


//MARK: - 设置测试的UI
extension TestUIPickerView_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        /// 设置pickerView的代理
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.layer.borderColor = UIColor.gray.cgColor
        pickerView.layer.borderWidth = 0.5
        
        self.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestUIPickerView_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        ///布局从导航栏下方开始
        self.edgesForExtendedLayout = .bottom
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestUIPickerView_VC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    ///设置cell的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView_Cell_ID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        cell.contentView.addSubview(label)
        
        return cell
    }
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

// MARK: - 笔记
/**
 问题：
     1、在设置row的显示为自定义view时，为什么pickerView中间会有一个蒙版，然后显示不出来图片？
         :是自定义view的赋值问题，但是我还没找到问题出现在哪里。我不知道为什么view一定要是在viewForRow代理方法中新建，而不能暂存在数组里面，暂存的话，会显示不出来。
          所以一般的操作是，你在viewForRow代理方法中新建自定义view，但是你的自定义view的数据则用数组缓存起来。不可以暂存view。
         :因为pickerView的设计之初就是为了有限的选择，如果是无限的选择，你应该用tableView，而不是pickerView。
 */

//
//  TestContact_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//

//测试获取通讯录的VC
// MARK: - 笔记
/**
    历史：
    1、AddressBookUI框架：提供了联系人列表界面、联系人详情界面、添加联系人界面等，一般用于选择联系人。
    2、AddressBook框架：纯C语言的API，仅仅是获得联系人数据。没有提供UI界面展示，需要自己搭建联系人展示界面。
                       里面的数据类型大部分基于Core Foundation框架，使用起来极其蛋疼。
    3、swift使用Core Foundation框架里面的类型，（例如类型是Unmanaged<AnyObject>）分为两种：
        1.内存托管对象：不需要我们程序员手动去管理，例如：CFString。
        2.内存非托管对象：需要我们程序员，手动管理内存，用下面两种内存管理方式：
                        takeRetainedValue:如果方法名称里有create，copy等，用takeRetainedValue返回对象，保留引用。
                        takeUnretainedValue：如果方法名称里有get。用takeUnretainedValue返回对象，不保留引用。
    4、UnsafePointer<Void> 相当于C语言的 Void * ：指向任意对象的指针。    //在swift中，需要把该指针转换为特定的对象，才可以使用。
        Swift提供了一个函数，专门用于转换该指针，unsafeBitCast函数。但是该函数非常不安全，所以使用的时候，必须准确知道你想要的结果是什么，否则转换失败。
        
 
    iOS9之后：
    1、获取通讯录首先都需要获取授权了。
    2、ContactsUI框架：用于替代AddressBookUI框架，是面向对象的框架，对swift友好。
    3、Contacts框架：用于替代AddressBook框架，是面向对象的框架，对swift友好。
    4、现在很多人都是直接用第三方框架了。


 
 */
import ContactsUI

class TestContact_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试获取通讯录的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestContact_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestContact_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试ContactsUI框架。
            /**
                1、用于展示联系人的UI界面。
             */
            print("     (@@ 0、测试ContactsUI框架。")
            //1.创建 选择联系人 的页面。
            let pickVC = CNContactPickerViewController()
            //2.设置代理。
            pickVC.delegate = self
            //3.弹出 选择择联系人界面的 VC。
            self.present(pickVC, animated: true)
            
        case 1:
            //TODO: 1、测试Contacts框架。
            /**
                1、用于获取联系人的数据，需要申请授权。
                   在info.plist文件中添加key：NSContactsUsageDescription
             */
            print("     (@@ 1、测试Contacts框架。")
            //1.判断授权状态，请求授权。
            let status = CNContactStore.authorizationStatus(for: .contacts)
            // 1.1、创建联系人仓库
            let store = CNContactStore()
            
            if status == .notDetermined {
               //还没授权，则请求授权。
                // 1.2、请求授权。
                store.requestAccess(for: .contacts) { (isGranted:Bool, err:Error?) in
                    if isGranted {
                        print("请求联系人数据，授权成功")
                    }else{
                        print("请求联系人数据，授权失败")
                    }
                }
                break
            }
            //2、获取联系人。
            //2.1、创建请求联系人的请求对象。
            // 数组里的key是你想请求的属性。
            let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor])
            
            //2.2、遍历联系人
            do {
                // 注意, 这种遍历, 类似于数组的遍历， 每执行一次block, 只会传递过来一个联系人对象。
                // 而联系人对象里面的值得获取, 是根据上面 CNContactFetchRequest, 参数指定的key来的, 没写的key, 统统不获取
                try store.enumerateContacts(with: request) { (contact: CNContact, stop) in
                    let givenName = contact.givenName
                    print("联系人是：",givenName)
                    // 遍历电话号码
                    let phoneNums = contact.phoneNumbers
                    // 每个电话号码, 包括标签和值
                    for phoneNum in phoneNums {
                        let label = phoneNum.label
                        let value = phoneNum.value 
                        print("遍历联系人的信息：",label ?? "", value.stringValue)
                    }
                }
            } catch {
                print("遍历联系人发生了错误：",error)
                return
            }
            
        case 2:
            //TODO: 2、
            print("     (@@ 2、")
        case 3:
            //TODO: 3、
            print("     (@@ 3、")
        case 4:
            print("     (@@")
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
//MARK: - 遵循选择联系人的代理协议，CNContactPickerDelegate协议。
extension TestContact_VC:CNContactPickerDelegate{
   
    //TODO: 取消选择联系人的时候回调。
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("取消选择联系人：\(#function)")
    }
    
    //TODO: 选择某一个联系人的时候回调。
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("选择某一个联系人：\(#function)方法，联系人姓氏：\(contact.familyName)--\(contact.phoneNumbers)")
    }
    
    //TODO: 选择某一个联系人的某个属性的时候回调。
    /**
        1、如果要该方法生效，需要把上面的didSelect contact，选择某个联系人的方法注释掉。
     */
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        print("选择某一个联系人的某个属性：\(#function)")
    }
    
}


//MARK: - 设置测试的UI
extension TestContact_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestContact_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
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
extension TestContact_VC: UICollectionViewDelegate {
    
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




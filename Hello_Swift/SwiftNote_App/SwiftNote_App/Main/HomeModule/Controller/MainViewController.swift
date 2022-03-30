//
//  MainViewController.swift
//  SwiftNote_App
//
//  Created by Mathew Cai on 2020/11/5.
//  Copyright © 2020 com.fendaTeamIOS. All rights reserved.
//

import UIKit

import UIKit
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class MainViewController: UIViewController {

    //MARK: 对外属性
    public var collDataArr = ["测试浏览PDF","模态","打款凭条","录视频"]
    
    //MARK: 内部属性
    ///UI数据源
    
    
    ///UI组件
    private var baseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试App"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }


}



//MARK: - 遵循委托协议,UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
}

//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
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
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            let rVC = JFZReadPDF_ImageVC()
            var modelArr = [PDFResourceModel]()
            let titleArr = ["阿卡夫阿拉伯的萨说卡","福大df","法卡","阿骨朵啦啦啊水库附近开始","asdnflajl","看了十多块垃圾"]
            for index in 0 ..< 6 {
//                let urlStr = Bundle.main.path(forResource: "资源文件//阿里巴巴java开发手册", ofType: "pdf")
                let urlStr = Bundle.main.path(forResource: "阿里巴巴java开发手册", ofType: "pdf")
                let url = URL.init(fileURLWithPath: urlStr!)
                let model = PDFResourceModel(fileName: titleArr[index], type: .PDF, url: url)
                modelArr.append(model)
            }
            var imgModelArr = [ImgResModel]()
            let titleArr2 = ["福大sfaff","鸟卡","阿巴斯里v呢"]
            for index in 0 ..< titleArr2.count {
                let urlStr1 = Bundle.main.path(forResource: "11", ofType: "jpg")
                let url1 = URL.init(fileURLWithPath: urlStr1!)
                let urlStr2 = Bundle.main.path(forResource: "222", ofType: "jpg")
                let url2 = URL.init(fileURLWithPath: urlStr2!)
                let urlStr3 = Bundle.main.path(forResource: "333", ofType: "jpg")
                let url3 = URL.init(fileURLWithPath: urlStr3!)
                let model = ImgResModel(fileName: titleArr2[index], type: .Image, urlArr: [url1,url2,url3])
                imgModelArr.append(model)
            }
            rVC.pdfModelArr = modelArr
            rVC.imgModelArr = imgModelArr
            pushNext(viewController: rVC)
            break
        case 1:
            let alertVC = UIAlertController(title: "", message: "请选择上传方式", preferredStyle: .actionSheet)
            self.present(alertVC, animated: true, completion: nil)
            let cameraAction = UIAlertAction(title: "拍照 ", style: .destructive, handler: {(sender:UIAlertAction) in
                print("选择了后摄像头")
            })
            let photoLibrayAcyion = UIAlertAction(title: "从相册上传", style: .destructive, handler: {(sender:UIAlertAction) in
                print("选择了相册")
            })
            //按钮
            let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            //添加按钮
            alertVC.addAction(cameraAction)
            alertVC.addAction(photoLibrayAcyion)
            //取消样式的按钮在下面显示
            alertVC.addAction(action)
            break
        case 2:
            let addVC = AddPaymentClipVC()
            pushNext(viewController: addVC)
            break
        case 3:
//            let vedioVC = JFZVideoPickerVC()
//            let mediaTypeArr = JFZVideoPickerVC.availableMediaTypes(for: .camera)
//            print("mediaTypeArr: ",mediaTypeArr)
//            vedioVC.modalPresentationStyle = .fullScreen
//            vedioVC.delegate = vedioVC.self
//            vedioVC.sourceType = .camera
//            self.present(vedioVC, animated: true) {
//                print("模态展示vc")
//            }
            break
        case 4:
            break
        case 5:
            break
        default:
            break
        }
    }
    
}


//MARK: - 工具方法
extension MainViewController{
    
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


//MARK: - 设计UI
extension MainViewController {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        //去掉导航栏的下划线，导致子页面的布局是从导航栏下方开始，即snpkit会以导航栏下方为零坐标
        self.edgesForExtendedLayout = .bottom
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
//        layout.headerReferenceSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 130)
        layout.itemSize = CGSize.init(width: 80, height: 80)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:SCREEN_HEIGHT),
                                             collectionViewLayout: layout)
        baseCollView.backgroundColor = UIColor.white
        baseCollView.delegate = self
        baseCollView.dataSource = self
        // register cell
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}


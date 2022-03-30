//
//  AddPaymentClipVC.swift
//  SwiftNote_App
//
//  Created by chuntiancai on 2021/6/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 添加打款凭条的VC

import UIKit

class AddPaymentClipVC: UIViewController{
    //MARK: - 对外属性
    var selectedImg:UIImage?{   //选中的图片
        didSet{
            selectedImgView.image = selectedImg
            selectedImgView.isHidden = false
            delBtn.isHidden = false
            addImgBtn.isHidden = true
            if selectedImg == nil {
                selectedImgView.isHidden = true
                delBtn.isHidden = true
                addImgBtn.isHidden = false
            }
        }
    }
    var addConfirmAction:(()->Void)?    //确认添加的动作方法,回调
    
    //MARK: - 内部属性
    private let delBtn = UIButton() //图片右上方的小删除按钮
    private let addImgBtn = UIButton()  //没有图片时的添加按钮
    private let selectedImgView = UIImageView() //凭条图片View
    private let textField = UITextField()   //输入金额
    private let timeValueLabel = UILabel()  //时间值label
    private var curDateComponets = Calendar.current.dateComponents([Calendar.Component.year,
                                                                 Calendar.Component.month,
                                                                 Calendar.Component.day],
                                                                from: Date())   //当前的日历组件
    private let confirmBtn = UIButton() //确认添加的按钮
    


    //MARK: - 复写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        self.title = "添加打款凭条"
        self.edgesForExtendedLayout = .bottom
        setUI()
        
    }
    
    ///收起键盘，获取当前点击的view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ///UItextField会拦截点击时间，不会走该方法，所以直接辞掉第一响应者就好
        textField.resignFirstResponder()
       
    }
    
}


//MARK: - 设置UI
extension AddPaymentClipVC{
    
    /// 设置UI
    private func setUI(){
        ///添加打款凭条*
        let addLabel = UILabel()
        let addStr = NSMutableAttributedString()
        let addStr1 = NSAttributedString(string: "添加打款凭条", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)] )
        let addStr2 = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)] )
        addStr.setAttributedString(addStr1)
        addStr.append(addStr2)
        addLabel.attributedText = addStr
        self.view.addSubview(addLabel)
        addLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(15)
        }
        
        let whiteBgView = UIView()
        whiteBgView.backgroundColor = .white
        self.view.addSubview(whiteBgView)
        whiteBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.width.equalToSuperview()
            make.height.equalTo(105)
        }
        
        addImgBtn.addTarget(self, action: #selector(addImgAtcion(sender:)), for: .touchUpInside)
        addImgBtn.setBackgroundImage(UIImage.init(named: "jfz_addImage_big"), for: .normal)
//        addImgBtn.backgroundColor = .cyan
        addImgBtn.isHidden = true
        whiteBgView.addSubview(addImgBtn)
        addImgBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.height.width.equalTo(68)
        }
        
        whiteBgView.addSubview(selectedImgView)
        selectedImgView.backgroundColor = .yellow
        selectedImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.height.width.equalTo(68)
        }
        
        delBtn.addTarget(self, action: #selector(delImgAtcion(sender:)), for: .touchUpInside)
//        delBtn.backgroundColor = .red
        delBtn.setBackgroundImage(UIImage.init(named: "jfz_deleteIcon"), for: .normal)
        whiteBgView.addSubview(delBtn)
        delBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(66)
            make.height.width.equalTo(14)
        }
        
        ///添加打款凭条*
        let payLabel = UILabel()
        let payStr = NSMutableAttributedString()
        let payStr1 = NSAttributedString(string: "打款信息", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)] )
        let payStr2 = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)] )
        payStr.setAttributedString(payStr1)
        payStr.append(payStr2)
        payLabel.attributedText = payStr
        self.view.addSubview(payLabel)
        payLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(149)
            make.left.equalToSuperview().offset(15)
        }
        
        ///打款金额，打款时间
        let whiteBgView2 = UIView()
        whiteBgView2.backgroundColor = .white
        self.view.addSubview(whiteBgView2)
        whiteBgView2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(173)
            make.width.equalToSuperview()
            make.height.equalTo(114)
        }
        
        let moneyLabel = UILabel()
        moneyLabel.text = "打款金额"
        moneyLabel.textColor = .black
        moneyLabel.font = .systemFont(ofSize: 16)
        whiteBgView2.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
        }
        
        let grayLineView = UIView()
        grayLineView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        whiteBgView2.addSubview(grayLineView)
        grayLineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let yuanLabel = UILabel()
        yuanLabel.text = "元"
        yuanLabel.textColor = .gray
        whiteBgView2.addSubview(yuanLabel)
        yuanLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.right.equalToSuperview().offset(-33)
        }
        textField.textAlignment = .right
        textField.textColor = .gray
        textField.delegate = self
        textField.placeholder = "--"
        textField.keyboardType = .decimalPad   //数字键盘
        textField.font = .systemFont(ofSize: 16)
        whiteBgView2.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.right.equalTo(yuanLabel.snp.left).offset(-5)
            make.width.equalTo(150)
        }
        
        let dateLabel = UILabel()
        dateLabel.text = "打款金额"
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 16)
        whiteBgView2.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77)
            make.left.equalToSuperview().offset(15)
        }
        ///打款时间
        timeValueLabel.textAlignment = .right
        timeValueLabel.font = .systemFont(ofSize: 16)
        timeValueLabel.textColor = .gray
        let monthStr = (curDateComponets.month ?? 1)>9 ? "\(curDateComponets.month!)":"0\(curDateComponets.month ?? 1)"
        let dayStr = (curDateComponets.day ?? 1) > 9 ? "\(curDateComponets.day!)":"0\(curDateComponets.day ?? 1)"
        timeValueLabel.text = "\(curDateComponets.year ?? 2000)-\(monthStr)-\(dayStr)"
        timeValueLabel.isUserInteractionEnabled = true
        let tapGestrue = UITapGestureRecognizer.init(target: self, action: #selector(showDatePickerView))
        timeValueLabel.addGestureRecognizer(tapGestrue)
        whiteBgView2.addSubview(timeValueLabel)
        timeValueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77)
            make.right.equalToSuperview().offset(-33)
            make.height.equalTo(15)
            make.width.equalTo(150)
        }
        
        ///添加打款拼条按钮
        confirmBtn.setTitle("添加打款凭条", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        confirmBtn.backgroundColor = UIColor.init(red: 194/255.0, green: 154/255.0, blue: 99/255.0, alpha: 1.0)
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(55)
        }
        
    }
    
    
}

//MARK: - 动作方法
@objc extension AddPaymentClipVC{
    /// 删除图片的动作方法
    /// - Parameter sender: 删除按钮
    func delImgAtcion(sender:UIButton){
        print("删除图片的动作方法")
        self.selectedImg = nil
    }
    
    /// 添加图片的动作方法
    /// - Parameter sender: 添加按钮
    func addImgAtcion(sender:UIButton){
        print("添加图片的动作方法")
        let alertVC = UIAlertController(title: "", message: "请选择上传方式", preferredStyle: .actionSheet)
        self.present(alertVC, animated: true, completion: nil)
        let cameraAction = UIAlertAction(title: "拍照 ", style: .destructive, handler: {(sender:UIAlertAction) in
            print("选择了后摄像头")
            self.goCamera()
        })
        let photoLibrayAcyion = UIAlertAction(title: "从相册上传", style: .destructive, handler: {(sender:UIAlertAction) in
            print("选择了相册")
            self.goImage()
        })
        //按钮
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        //添加按钮
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoLibrayAcyion)
        //取消样式的按钮在下面显示
        alertVC.addAction(action)
        
    }
    
    ///展示日期PickerView
    func showDatePickerView(){
        print("展示日期选择器～～～")
        let pickView = DatePickerView()
        pickView.layer.cornerRadius = 10
        self.view.addSubview(pickView)
        pickView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        pickView.okAction = {
            [weak self]
            (year:Int,month:Int,day:Int) -> () in
            self?.timeValueLabel.text = "\(year)-\(month)-\(day)"
            print("pickView传回来的参数:\(year)-\(month)-\(day)")
        }
    }
    
    ///确认提交的动作方法
    func confirmAction(sender:UIButton){
        print("确认添加打款凭条")
    }
}

//MARK: - 遵循代理
extension AddPaymentClipVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let mStr = textField.text
        if mStr?.isEmpty ?? false {
            return
        }
        print("textField的输入金额：\(textField.text ?? "")")
//        if !(mStr?.contains("元") ?? false) {
//            textField.text = (mStr ?? "") + "元"
//        }
        
    }
    
}

//MARK: - 内部工具方法
extension AddPaymentClipVC{
    /// 去拍照
    func goCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
        }
    }

    /// 去相册
    func goImage(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddPaymentClipVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    ///图片代理回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("获得照片============= \(info)")
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        ///显示设置的照片
        self.selectedImg=image
        self.dismiss(animated: true, completion: nil)
    }
}

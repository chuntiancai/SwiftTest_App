//
//  CHLogView.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 命令交互的View，用于打印log

import Foundation
import UIKit

class CHLogView: UIView {
    
    //MARK:  public,对外属性
    public var appendText: String = "" {    //append string in textview
        didSet{
            lock.lock()
            var textFielViewText = self.displayTextView.text ?? ""
            if textFielViewText.count > 10000 {
                textFielViewText = String(textFielViewText.suffix(10000))
            }
            
            self.displayTextView.text = textFielViewText.appending(self.appendText + "\n\n")
            self.displayTextView.scrollRectToVisible(CGRect(x: 10, y: self.displayTextView.contentSize.height-15, width: self.displayTextView.contentSize.width, height: 15), animated: true)
            
            lock.unlock()
            
        }
    }
    
    public var contentText: String = "" {   //内容文本
        didSet{
              self.displayTextView.text = contentText
        }
    }
    ///对外提供的单例，用于全局观看log打印，或者添加到window上也行
    static let instance = CHLogView.init(frame: CGRect(x: 0, y: NAVIGATION_BAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2))
       
    //MARK: - private
    
    //textView
    fileprivate  let displayTextView = UITextView.init()
    let lock = NSLock.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        
        //双点清除文本
        let doubleGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.doubleTapAction(doubleTapGes:)))
        doubleGes.numberOfTouchesRequired = 2
        self.addGestureRecognizer(doubleGes)
        
        //design textview
        setTextViewUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//MARK: - 设计UI
extension CHLogView {
    
    private func setTextViewUI(){
        
        displayTextView.backgroundColor = .lightGray
        displayTextView.font = UIFont.systemFont(ofSize: 12)
        displayTextView.layer.cornerRadius = 10.0
        displayTextView.textColor = .red
        displayTextView.isEditable = false
        displayTextView.isSelectable = true
        self.addSubview(displayTextView)
        displayTextView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


//MARK: - 动作方法
@objc extension CHLogView {
    
    //long press to clear textview
    func doubleTapAction(doubleTapGes:UILongPressGestureRecognizer) {
        if doubleTapGes.state == .ended {
            print("@@Two finger touch to clear textview")
            self.displayTextView.text = ""
        }
    }
    
}

//MARK: - 对外提供的方法
extension CHLogView {
    
    public func clearText(){
        self.displayTextView.text = ""
    }
    
}

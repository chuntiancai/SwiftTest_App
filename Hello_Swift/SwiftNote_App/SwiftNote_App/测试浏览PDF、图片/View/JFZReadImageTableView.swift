//
//  JFZReadImageTableView.swift
//  SwiftNote_App
//
//  Created by chuntiancai on 2021/6/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 查看图片的tableview

import UIKit


class JFZReadImageTableView: UIView {
    //MARK: - 对外属性
    var imgModel:ImgResModel = ImgResModel(fileName: "", type: .Image, urlArr: [URL]())  //数据model的数组
    
    
    //MARK: - 内部属性
    private var tableView:UITableView!

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            tableView = UITableView.init(frame: self.frame, style: .insetGrouped)
        } else {
            tableView = UITableView.init(frame: self.frame, style: .grouped)
            // Fallback on earlier versions
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JFZReadImgTableCell.classForCoder(), forCellReuseIdentifier: "JFZReadImgTableCellID")
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 40))
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 遵循tableView的协议
extension JFZReadImageTableView: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return imgModel.urlArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 0.001))
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 0.001))
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: "JFZReadImgTableCellID") as? JFZReadImgTableCell
        if cell == nil  {
            cell = JFZReadImgTableCell.init(style: .default, reuseIdentifier: "JFZReadImgTableCellID")
        }
        cell!.url = imgModel.urlArr[indexPath.section]
        cell?.selectionStyle = .none    //取消点击效果
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
}

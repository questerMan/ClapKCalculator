//
//  MainViewController.swift
//  ClapKCalculator
//
//  Created by 陆遗坤 on 2020/5/11.
//  Copyright © 2020 陆遗坤. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, Deleagte {
    //MARK - PrefixTool的代理协议

    func changeResultText(textStr: String) {
        labResult.text = "= " + textStr
    }
    
    func changeShowText(textStr: String) {
        labNews.text = textStr
    }
    
    //MARK - 懒加载
    lazy var tool:PrefixTool = {
        let tool = PrefixTool.init()
        tool.delegate = self
        return tool
    }()
    lazy var labNews:UILabel = {
        let labNews = UILabel.init(frame: CGRect(x: 0, y: 30, width: WIDTH_SCREEN, height: 40))
        labNews.textAlignment = .right
        labNews.textColor = BTN_TIN_COLOR
        labNews.numberOfLines = 2
        labNews.font = UIFont.boldSystemFont(ofSize: 30)
        labNews.contentMode = .scaleAspectFill
        return labNews
    }()
    lazy var labResult:UILabel = {
        let labResult = UILabel.init(frame: CGRect(x: 0, y: 70, width: WIDTH_SCREEN, height: 60))
        labResult.textAlignment = .right
        labResult.textColor = .white
        labResult.font = UIFont.boldSystemFont(ofSize: 40)
        return labResult
    }()
    lazy var inputText:UILabel = {
           let inputText = UILabel.init(frame: CGRect(x: 0, y: 10, width: WIDTH_SCREEN, height: 40))
           inputText.textAlignment = .center
           inputText.textColor = .gray
           inputText.text = "ClapK Calculator"
           inputText.font = UIFont.boldSystemFont(ofSize: 30)
           return inputText
       }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建UI界面
        self.creatUI()
    }
    
    //MARK - 创建UI界面：LOGO、显示模块、历史信息模块、功能键模块
    func creatUI() {
        self.view.backgroundColor = THEME0_BG_COLOR
        //创建背景视图 TOP背景
        let topBG = tool.creatImageView(frame: CGRect(x: 0, y: 0, width: WIDTH_SCREEN, height: HEIGHT_SCREEN/3), named: "top")
        self.view.addSubview(topBG)
        //创建背景视图 历史信息显示背景
        let dataBG = tool.creatImageView(frame: CGRect(x: 0, y: HEIGHT_SCREEN/3, width: WIDTH_SCREEN, height: HEIGHT_SCREEN/12), named: "newsdata")
        self.view.addSubview(dataBG)

        //创建LOGO
        
        //创建显示模块 输入信息和结果
        
        self.view.addSubview(labNews)
        
        self.view.addSubview(labResult)
        
        dataBG.addSubview(inputText)
        
        //创建历史信息模块
        
        //创建功能键模块
        tool.creatCheckButton(superView: self,topY:HEIGHT_SCREEN/12*5)
                
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

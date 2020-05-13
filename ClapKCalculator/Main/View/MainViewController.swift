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
    func changeLOGOColor(k:Int) {
        switch k {
        case 0:
            logoText.textColor = LOGO_0_COLOR
        case 1:
            logoText.textColor = LOGO_1_COLOR
        case 2:
            logoText.textColor = LOGO_2_COLOR
        case 3:
            logoText.textColor = LOGO_3_COLOR
        case 4:
            logoText.textColor = LOGO_4_COLOR
        case 5:
            logoText.textColor = LOGO_5_COLOR
        default:
            logoText.textColor = .gray
        }
    }
    
    func tellResultTextEmpty() {
        labResult.text = ""
        labSymbolNews.text = ""
    }
    
    func changeShowSymbolText(textStr: String) {
        let arr = ["➕","➖","✖️","➗"]
        if arr.contains(textStr){
            labSymbolNews.text = textStr
        }else{
            
        }
    }
    
    func tellNew(str: String) {
        weak var WeakSelf = self
        newsText.text = str
        ///延迟执行之前的代码
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:{
             ///延迟执行的代码
            WeakSelf?.newsText.text = ""
        })
    }

    func changeShowSymbolTextOfOnclickEqual() {
        labSymbolNews.text = ""
    }
    func changeResultText(textStr: String) {
        if  tool.stringToDouble(textStr) == 0{
            labResult.text = "0"
        }else{
            labResult.text = "= " + tool.removePiontCount(string:textStr)
        }
    }
    
    func changeShowCharsText(textStr: String) {
        labCharsNews.text = textStr
    }
    
    //MARK - 懒加载
    lazy var tool:PrefixTool = {
        let tool = PrefixTool.init()
        tool.delegate = self
        return tool
    }()
    lazy var labSymbolNews:UILabel = {
        let labSymbolNews = UILabel.init(frame: CGRect(x: WIDTH_SCREEN - 100, y: 80, width: 50, height: 40))
        labSymbolNews.textAlignment = .right
        labSymbolNews.textColor = BTN_TIN_COLOR
        labSymbolNews.numberOfLines = 2
        labSymbolNews.font = UIFont.boldSystemFont(ofSize: 30)
        labSymbolNews.contentMode = .scaleAspectFill
        return labSymbolNews
    }()
    lazy var labCharsNews:UILabel = {
        let labCharsNews = UILabel.init(frame: CGRect(x: 50, y: 30, width: WIDTH_SCREEN - 100, height: 40))
        labCharsNews.textAlignment = .center
        labCharsNews.textColor = BTN_TIN_COLOR
        labCharsNews.numberOfLines = 2
        labCharsNews.font = UIFont.boldSystemFont(ofSize: 30)
        labCharsNews.contentMode = .scaleAspectFill
        return labCharsNews
    }()
    lazy var labResult:UILabel = {
        let labResult = UILabel.init(frame: CGRect(x: 0, y: 70, width: WIDTH_SCREEN, height: 60))
        labResult.textAlignment = .center
        labResult.textColor = .white
        labResult.font = UIFont.boldSystemFont(ofSize: 40)
        return labResult
    }()
    lazy var logoText:UILabel = {
           let logoText = UILabel.init(frame: CGRect(x: 0, y: 10, width: WIDTH_SCREEN, height: 40))
           logoText.textAlignment = .center
           logoText.textColor = LOGO_1_COLOR
           logoText.text = "ClapK Calculator"
           logoText.font = UIFont.boldSystemFont(ofSize: 30)
           return logoText
       }()
    lazy var newsText:UILabel = {
        let newsText = UILabel.init(frame: CGRect(x: 0, y: -18, width: WIDTH_SCREEN, height: 40))
        newsText.textAlignment = .center
        newsText.textColor = .white
        newsText.text = ""
        newsText.font = UIFont.boldSystemFont(ofSize: 15)
        return newsText
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
        
        self.view.addSubview(labCharsNews)
        self.view.addSubview(labSymbolNews)

        self.view.addSubview(labResult)
        
        dataBG.addSubview(logoText)
         dataBG.addSubview(newsText)
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

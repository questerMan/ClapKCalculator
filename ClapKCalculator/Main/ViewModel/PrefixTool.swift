//
//  PrefixTool.swift
//  ClapKCalculator
//
//  Created by 陆遗坤 on 2020/5/11.
//  Copyright © 2020 陆遗坤. All rights reserved.
//

import UIKit
//主题颜色1
let THEME0_BG_COLOR = UIColor(red: 74/255, green: 112/255, blue: 139/255, alpha: 1)
//135,206,235
let BTN_TIN_COLOR = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)

//输入文字颜色
let SHOWINPUT_COLOR = UIColor.white
//计算结果文字颜色
let SHOWRESULT_COLOR = UIColor.red
// 74,112,139
//按钮字体大小
let FONT_BOLD_BTN = UIFont.boldSystemFont(ofSize: 30)
//logo字体大小
let FONT_BOLD_LOGO = UIFont.boldSystemFont(ofSize: 30)
//输入文字显示字体大小
let SHOWINPUT_FONT_BOLD = UIFont.boldSystemFont(ofSize: 20)
//结果显示字体大小
let SHOWRESULT_FONT_BOLD = UIFont.boldSystemFont(ofSize: 30)
//屏幕宽度
let WIDTH_SCREEN = UIScreen.main.bounds.width
//屏幕高度
let HEIGHT_SCREEN = UIScreen.main.bounds.height

@objc protocol Deleagte:class {

    @objc optional func changeShowText(textStr:String)
    @objc optional func changeResultText(textStr:String)
}

class PrefixTool: NSObject {
    
    override init() {
        super.init()
    
        // 添加观察者
        self.addObserver(self, forKeyPath: "symbolState", options: [.new,.old], context: nil)
        self.addObserver(self, forKeyPath: "chars", options: [.new,.old], context: nil)
        self.addObserver(self, forKeyPath: "resultFinish", options: [.new,.old], context: nil)

    }
    /// KVO监听属性
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newName = change?[.newKey] as? String{
            //let newstr =  change?[.newKey] as? String
            //let oldtr =  change?[.oldKey] as? String
            
            print("新的name属性的值为: \(newName)")
            if keyPath == "symbolState" {
                changeOnclickSelecteSate(symbolState)
            }else if keyPath == "chars" {
                delegate?.changeShowText?(textStr: chars)
            }else if keyPath == "resultFinish" {
                delegate?.changeResultText?(textStr: resultFinish)
            }
        }
    }

    var addBtn:UIButton?
    var subtractBtn:UIButton?
    var multiplyBtn:UIButton?
    var divideBtn:UIButton?

    weak var delegate:Deleagte?
    
    //MARK - 创建图片视图ImageView
    func creatImageView(frame: CGRect,named: String) -> UIImageView {
        let imageView = UIImageView.init(frame: frame)
        imageView.image = UIImage(named: named)
        return imageView
    }
    //MARK - 创建方格按钮：计算器输入控制按钮
    func creatCheckButton(superView:UIViewController,topY:CGFloat) {
        var interval_x:CGFloat = 10.0
        var interval_Y:CGFloat = 10.0
        let siderLenght:CGFloat = (WIDTH_SCREEN-(5*interval_x))/4 > (HEIGHT_SCREEN/12)*7/5 ? (HEIGHT_SCREEN/12)*7/5-interval_x*2:(WIDTH_SCREEN-(5*interval_x))/4
        interval_x = (WIDTH_SCREEN-(5*interval_x))/4 > (HEIGHT_SCREEN/12)*7/5 ?  (WIDTH_SCREEN-4*siderLenght)/5:10.0
        interval_Y = (WIDTH_SCREEN-(5*interval_x))/4 > (HEIGHT_SCREEN/12)*7/5 ? 10.0:(HEIGHT_SCREEN/12*7-(5*siderLenght))/6
        
        let array = [["ME","AC","EC","C"],["1","2","3","✖️"],["4","5","6","➗"],["7","8","9","➕"],[".","0","=","➖"]]
        //创建功能键模块
        for i in 0..<5 {
            for j in 0..<4{
                let btn = UIButton.init(frame: CGRect(x: interval_x+(interval_x+siderLenght)*CGFloat(j), y:topY+interval_Y+(interval_Y+siderLenght)*CGFloat(i), width: siderLenght, height: siderLenght))
                btn.layer.cornerRadius = siderLenght/2
                btn.layer.masksToBounds = true
                btn.titleLabel?.font = FONT_BOLD_BTN
                btn.setBackgroundImage(createImageWithColor(.white, frame: CGRect(x: 0, y: 0, width: btn.frame.size.width, height: btn.frame.size.height)), for: .selected)
                btn.setBackgroundImage(createImageWithColor(BTN_TIN_COLOR, frame: CGRect(x: 0, y: 0, width: btn.frame.size.width, height: btn.frame.size.height)), for: .normal)

                btn.setTitle(array[i][j], for: .normal)
                btn.tag = (i+1)*10 + j
                btn.addTarget(self, action: #selector(onclick(btn:)), for: .touchUpInside)
                superView.view.addSubview(btn)
                
                switch btn.tag {
                case 23:
                    multiplyBtn = btn
                case 33:
                    divideBtn = btn
                case 43:
                    addBtn = btn
                case 53:
                    subtractBtn = btn
                default:
                    break
                }
            }
        }
    }
    
    //字符串转换成浮点型Double
    private func stringToDouble(_ str:String) -> Double{
        return Double((str as NSString).doubleValue)
    }
    
    //浮点型Double转换成字符串
    private func doubleToString(_ number:Double) -> String{
        return String(format: "%.2f", number)
    }
    
    //运算符号的使用状态
    enum SymbolState:Int {
        case none = 0
        case add = 1
        case subtract = 2
        case multiply = 3
        case divide = 4
    }
    
    private func gethars(_ str:String){
        if isEqualOnclickSymbol == false{
            chars += str
        }
    }

    //被监听的对象属性
    @objc dynamic var symbolState:String = ""
    
    @objc dynamic var chars:String = ""
    
    @objc dynamic var resultFinish:String = ""
    //声明变量，辨别运算符号和点号之间是否重复点击
    private var isContinuousOnclickSymbol:Bool = false
    private var isEqualOnclickSymbol:Bool = false
    //声明一个装输入数字值的数组
    private var arrNumber:Array<String> = []
    //声明一个装输入运算符号的数组
    private var arrSymbol:Array<String> = []
    //输入的数字
    private var perfectCharsCount:String = ""
    
    @objc func onclick(btn:UIButton){
        let number1:String = "1"
        let number2:String = "2"
        let number3:String = "3"
        let number4:String = "4"
        let number5:String = "5"
        let number6:String = "6"
        let number7:String = "7"
        let number8:String = "8"
        let number9:String = "9"
        let number0:String = "0"
        let number100:String = "."
        let symbolAdd:String = "➕"
        let symbolSubtract:String = "➖"
        let symbolMultiply:String = "✖️"
        let symbolDivide:String = "➗"
        
        
        switch btn.tag {
        case 10://我的
            //跳转我的页面
            print("我的按钮")
            
        case 11://全删除
            print("全删除按钮")
            initProperty()
            
        case 12://部分删除
            print("部分删除按钮")
            
        case 13://单个删除
            print("单个删除按钮")
        case 20://数字1
            print("数字1按钮")
            
            gethars(number1)
            getCount(btnTag: btn.tag, symbolName: number1)
        case 21://数字2
            print("数字2按钮")
            
            gethars(number2)
            getCount(btnTag: btn.tag, symbolName: number2)
        case 22://数字3
            print("数字3按钮")
            
            gethars(number3)
            getCount(btnTag: btn.tag, symbolName: number3)
            
        case 23://乘
            print("乘号按钮")
            
            symbolState = "multiply"
            getCount(btnTag: btn.tag, symbolName: "")
            
            if chars.isEmpty{
                replaceChar("0" + symbolMultiply)
            }else{
                replaceChar(symbolMultiply)
            }
            
        case 30://数字4
            print("数字4按钮")
            gethars(number4)
            getCount(btnTag: btn.tag, symbolName: number4)
        case 31://数字5
            print("数字5按钮")
            gethars(number5)
            getCount(btnTag: btn.tag, symbolName: number5)
        case 32://数字6
            print("数字6按钮")
            gethars(number6)
            getCount(btnTag: btn.tag, symbolName: number6)
        case 33://除
            symbolState = "divide"
            getCount(btnTag: btn.tag, symbolName: "")
            if chars.isEmpty{
                replaceChar("0" + symbolDivide)
            }else{
                replaceChar(symbolDivide)
            }
            
            print("除号按钮")
        case 40://数字7
            print("数字7按钮")
            gethars(number7)
            getCount(btnTag: btn.tag, symbolName: number7)
        case 41://数字8
            print("数字8按钮")
            gethars(number8)
            getCount(btnTag: btn.tag, symbolName: number8)
        case 42://数字9
            print("数字9按钮")
            gethars(number9)
            getCount(btnTag: btn.tag, symbolName: number9)
        case 43://加
            print("加号按钮")
            symbolState = "add"
            getCount(btnTag: btn.tag, symbolName: "")
            if chars.isEmpty{
               replaceChar("0" + symbolAdd)
            }else{
                replaceChar(symbolAdd)
            }
            
            
        case 50://点号
            print("点号按钮")
            if chars.isEmpty{
                replaceChar("0" + number100)
            }else{
                replaceChar(number100)
            }
            getCount(btnTag: btn.tag, symbolName: number100)
        case 51://数字0
            print("数字0按钮")
            gethars( number0)
            getCount(btnTag: btn.tag, symbolName: number0)
            
        case 52://等于号
            print("等于号按钮")
            if isEqualOnclickSymbol == true{
            getCount(btnTag: btn.tag, symbolName: "")
            //计算
            resultOfCount(arrNumber, arrSymbol)
            //initProperty()
            }
            
            isEqualOnclickSymbol = true
            
        case 53://减
            print("减号按钮")
            symbolState = "subtract"
            getCount(btnTag: btn.tag, symbolName: "")
            if chars.isEmpty{
                replaceChar("0" + symbolSubtract)
            }else{
                replaceChar(symbolSubtract)
            }

        default:
            break
        }
      

        if btn.tag == 23 || btn.tag == 33 || btn.tag == 43 || btn.tag == 53{
            isContinuousOnclickSymbol = true
        }else{
            symbolState = ""
            isContinuousOnclickSymbol = false
            if btn.tag == 50{
                isContinuousOnclickSymbol = true
            }
        }
        //
       
    }
    let arrNum:Array<Int> = [20,21,22,30,31,32,40,41,42,50,51]//数字
    let arrSym:Array<Int> = [23,33,43,53,52]//数字

    //收集输入的数值
    private func getCount(btnTag tag:Int,symbolName symbolCount:String){

        if arrNum.contains(tag) {
            //输入数字前保存上一个运算符号
            if isContinuousOnclickSymbol == true{
                arrSymbol.append(symbolState)
            }
            
            perfectCharsCount += symbolCount
            
        }else if arrSym.contains(tag){
            //输入运算符保存上一个输入的数值
            if !perfectCharsCount.isEmpty{
                arrNumber.append(perfectCharsCount)
            }
            perfectCharsCount = ""
        }
    }
    
    //MARK - 避免重复输入运算符号
    func replaceChar(_ currentChar:String){
        if isEqualOnclickSymbol == false{
            if isContinuousOnclickSymbol == true{
                chars.remove(at: chars.index(before: chars.endIndex))
                chars = chars + currentChar
            }else{
                chars += currentChar
            }
        }
    }

    private func changeOnclickSelecteSate(_ stateStr:String){
        
        switch stateStr {
        case "multiply":
            divideBtn?.isSelected = false
            multiplyBtn?.isSelected = true
            addBtn?.isSelected = false
            subtractBtn?.isSelected = false

        case "divide":
            divideBtn?.isSelected = true
            multiplyBtn?.isSelected = false
            addBtn?.isSelected = false
            subtractBtn?.isSelected = false
            
        case "add":
            divideBtn?.isSelected = false
            multiplyBtn?.isSelected = false
            addBtn?.isSelected = true
            subtractBtn?.isSelected = false
        case "subtract":
            divideBtn?.isSelected = false
            multiplyBtn?.isSelected = false
            addBtn?.isSelected = false
            subtractBtn?.isSelected = true
        default:
            
            divideBtn?.isSelected = false
            multiplyBtn?.isSelected = false
            addBtn?.isSelected = false
            subtractBtn?.isSelected = false
        }
    }
    //MARK - 初始化属性值
    private func initProperty(){
        symbolState = ""
        chars = ""
        resultFinish = ""
        isContinuousOnclickSymbol = false
        arrSymbol = []
        arrNumber = []
        isEqualOnclickSymbol = false

    }
    
    //MARK - 运算符号算法
    private func add(num1:Double,num2:Double) -> Double{//加
        let result:Double = num1 + num2
        return result
    }
    private func subtract(num1:Double,num2:Double) -> Double{//减
        let result:Double = num1 - num2
        return result
    }
    private func multiply(num1:Double,num2:Double) -> Double{//乘
        let result:Double = num1 * num2
        return result
    }
    private func divide(num1:Double,num2:Double) -> Double{//除
        let result:String = String(format:"%.2f",num1/num2)
        return stringToDouble(result)
    }
    
    private func searchSymbolWay(stateStr:String,num1:Double,num2:Double) -> Double{
         
        switch stateStr {
        case "add":
            return add(num1: num1, num2: num2)
        case "subtract":
            return subtract(num1: num1, num2: num2)
        case "multiply":
            return multiply(num1: num1, num2: num2)
        case "divide":
            return divide(num1: num1, num2: num2)
        default:
            return 0
        }
    }
    
    
    private func delegateCharacter(){//删除单个字符
        
    }
    private func delegateItem(){//删除单个数
        
    }
    private func delegateAll(){//删除全部计算
        
    }

  
    //MARK - 生成一个指定颜色的图片
    func createImageWithColor(_ color: UIColor, frame: CGRect) -> UIImage? {
        // 开始绘图
        UIGraphicsBeginImageContext(frame.size)
         
        // 获取绘图上下文
        let context = UIGraphicsGetCurrentContext()
        // 设置填充颜色
        context?.setFillColor(color.cgColor)
        // 使用填充颜色填充区域
        context?.fill(frame)
         
        // 获取绘制的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
         
        // 结束绘图
        UIGraphicsEndImageContext()
        return image
    }
     
    private func resultOfCount(_ arrNumberR:Array<String>, _ arrSymbolR:Array<String>){
        var currentResut:Double = stringToDouble(arrNumberR[0])
        
        var i = 1
        for symbol in arrSymbolR{
            if !symbol.isEmpty{
                currentResut = searchSymbolWay(stateStr: symbol, num1: currentResut, num2: stringToDouble(arrNumberR[i]))
                i += 1
            }
        }
        resultFinish = doubleToString(currentResut)
        print("运算结果是：\(currentResut)")
    }
    
    
    deinit {
        //移除监听
        self.removeObserver(self, forKeyPath: "symbolState")
    }
    
}

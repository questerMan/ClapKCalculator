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

let LOGO_0_COLOR = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)//100,149,237
let LOGO_1_COLOR = UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1)//175,238,238
let LOGO_2_COLOR = UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 1)//0,139,139
let LOGO_3_COLOR = UIColor(red: 128/255, green: 128/255, blue: 0/255, alpha: 1)//128,128,0
let LOGO_4_COLOR = UIColor(red: 255/255, green: 222/255, blue: 173/255, alpha: 1)//255,222,173
let LOGO_5_COLOR = UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 1)//240,128,128


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

    @objc optional func changeShowCharsText(textStr:String)
    @objc optional func changeResultText(textStr:String)
    @objc optional func changeShowSymbolText(textStr:String)
    @objc optional func changeShowSymbolTextOfOnclickEqual()
    @objc optional func tellNew(str:String)
    @objc optional func tellResultTextEmpty()
    @objc optional func changeLOGOColor(k:Int)

}

class PrefixTool: NSObject {
    
    override init() {
        super.init()
    
        // 添加观察者
        self.addObserver(self, forKeyPath: "symbolOfCurrentSate", options: [.new,.old], context: nil)
        self.addObserver(self, forKeyPath: "result", options: [.new,.old], context: nil)
        self.addObserver(self, forKeyPath: "numberOfChars", options: [.new,.old], context: nil)

        let name = Notification.Name(rawValue: "changeBtnColor")
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: name, object: nil)
    }
    @objc func change(sender:Notification){
        print("接收广播成功")
        print(sender.name)
        print(sender.userInfo!)
        
    }
    /// KVO监听属性
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "symbolOfCurrentSate" {
        
            let newValue:String = change?[.newKey] as! String
            print("新的name属性的值为: \(newValue)")
            changeOnclickSelecteSateForBGColor(newValue)
            delegate?.changeShowSymbolText?(textStr: newValue)
        
        }else if keyPath == "result" {
            let newValue:Double = change?[.newKey] as! Double
            print("新的ResultText属性的值为: \(newValue)")
            delegate?.changeResultText?(textStr: doubleToString(newValue))
           
        }else if keyPath == "numberOfChars" {
            let newValue:String = change?[.newKey] as! String
            print("新的name属性的值为: \(newValue)")
            delegate?.changeShowCharsText?(textStr: newValue)
        }
    }

    var meBtn:UIButton?

    var addBtn:UIButton?
    var subtractBtn:UIButton?
    var multiplyBtn:UIButton?
    var divideBtn:UIButton?
    var equalBtn:UIButton?

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
                case 10:
                    meBtn = btn
                case 23:
                    multiplyBtn = btn
                case 33:
                    divideBtn = btn
                case 43:
                    addBtn = btn
                case 53:
                    subtractBtn = btn
                case 52:
                    equalBtn = btn
                default:
                    break
                }
            }
        }
    }
    
    //字符串转换成浮点型Double
    func stringToDouble(_ str:String) -> Double{
        return Double((str as NSString).doubleValue)
    }
    
    //浮点型Double转换成字符串
    func doubleToString(_ number:Double) -> String{
        return String(format: "%.2f", number)
    }
  

    

    

    //声明定义变量:保存数值的空数组
    private var arrNumber:Array<String> = []
    //声明定义变量:拼接数值
    @objc dynamic var numberOfChars:String = ""
    //被监听的对象属性>声明定义变量:拼接数值
    @objc dynamic var symbolOfCurrentSate:String = ""

    //声明定义变量:保存运算符的空数组
    private var arrSymbol:Array<String> = []
    //每一步的计算结果
    @objc dynamic var result:Double = 0
    //是否重复点击运算符号
    var isOnclickSymbol:Bool = false
    //是否重复点击等于号
    var isOnclickEqual:Bool = false
    //
    var isOnclickEqualNoOnclickSymbol:Bool = false
    //是否重复点击运算符号
    var isOnclickNumber:Bool = false
    
    private var k:Int = 0
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
            print("改变LOGO颜色")
            delegate?.changeLOGOColor?(k:k)
            if k > 5{
                k = 0
            }else{
                k += 1
            }
            
        case 11://全删除
            print("全删除按钮")
            initAllProperty()
            delegate?.tellResultTextEmpty?()
            
        case 12://部分删除
            print("部分删除按钮")
            delegateItem()
        case 13://单个删除
            print("单个删除按钮")
            delegateCharacter()
        case 20://数字1
            print("数字1按钮")
            getValue(btn: btn, currentValue: number1)
            
        case 21://数字2
            print("数字2按钮")
            getValue(btn: btn, currentValue: number2)

        case 22://数字3
            print("数字3按钮")
            getValue(btn: btn, currentValue: number3)
            
        case 23://乘
            print("乘号按钮")
            getValue(btn: btn, currentValue: symbolMultiply)
        
            
            
        case 30://数字4
            print("数字4按钮")
            getValue(btn: btn, currentValue: number4)
            
        case 31://数字5
            print("数字5按钮")
            getValue(btn: btn, currentValue: number5)
            
        case 32://数字6
            print("数字6按钮")
            getValue(btn: btn, currentValue: number6)
            
        case 33://除
            getValue(btn: btn, currentValue: symbolDivide)
            
            print("除号按钮")
        case 40://数字7
            print("数字7按钮")
            getValue(btn: btn, currentValue: number7)
            
        case 41://数字8
            print("数字8按钮")
            getValue(btn: btn, currentValue: number8)
            
        case 42://数字9
            print("数字9按钮")
            getValue(btn: btn, currentValue: number9)
            
        case 43://加
            print("加号按钮")
            getValue(btn: btn, currentValue: symbolAdd)
            
            
        case 50://点号
            print("点号按钮")
            getValue(btn: btn, currentValue: number100)
            
        case 51://数字0
            print("数字0按钮")
            getValue(btn: btn, currentValue: number0)
            
            
        case 52://等于号
            print("等于号按钮")
            getValue(btn: btn, currentValue: "")
            
        case 53://减
            print("减号按钮")
            getValue(btn: btn, currentValue: symbolSubtract)
            

        default:
            break
        }
    
       
    }
    let arrNum:Array<Int> = [20,21,22,30,31,32,40,41,42,50,51]//数字
    let arrSym:Array<Int> = [23,33,43,53]//运算符号
    let arrEquar:Array<Int> = [52] //运算符号等于号
    var iC:Int = 0
    private func getValue(btn:UIButton, currentValue:String){

        let btnTag:Int = btn.tag
        if arrNum.contains(btnTag) {
            isOnclickNumber = true
            if isOnclickEqualNoOnclickSymbol == true{
                initAllProperty()
            }
            
            if !symbolOfCurrentSate.isEmpty{
                //不为空的数值保存
                arrSymbol.append(symbolOfCurrentSate)
            }
           
            symbolOfCurrentSate = ""
            if numberOfChars.isEmpty && btnTag == 50{
                numberOfChars += "0"+currentValue
            }else{
                //如果有重复的点不在输入点号
                if btnTag == 50 && numberOfChars.contains(currentValue){}else{
                    numberOfChars += currentValue
                }
            }
            
            isOnclickSymbol = false
            isOnclickEqual = false
            iC = 0
        }else if arrSym.contains(btnTag){
            
            if !numberOfChars.isEmpty{
                //不为空的数值保存
                if numberOfChars.last == "."{
                    numberOfChars += "0"
                    arrNumber.append(numberOfChars)
                }else{
                    arrNumber.append(numberOfChars)
                }
            }

            if isOnclickSymbol == false &&  isOnclickEqual == false{
                reckoning()
            }
            numberOfChars = ""
            symbolOfCurrentSate = currentValue
            isOnclickSymbol = true
            isOnclickEqual = false
            isOnclickEqualNoOnclickSymbol = false
            isOnclickNumber = false
            iC = 0
        }else if arrEquar.contains(btnTag){
             delegate?.changeShowSymbolTextOfOnclickEqual?()
    
             if !numberOfChars.isEmpty && isOnclickEqualNoOnclickSymbol == false{
                //不为空的数值保存
                if numberOfChars.last == "."{
                    numberOfChars += "0"
                    arrNumber.append(numberOfChars)
                }else{
                    arrNumber.append(numberOfChars)
                }
                
            }
            //计算
            if isOnclickSymbol == false &&  isOnclickEqual == false && isOnclickEqualNoOnclickSymbol == false{
                reckoning()
            }else{
                //您尚未点击运算符号
                //delegate?.tellNew?(str:"您尚未点击运算符号")
            }
            //点击等于符号
            numberOfChars = ""
            symbolOfCurrentSate = ""
            isOnclickSymbol = false
            isOnclickEqual = true
            isOnclickEqualNoOnclickSymbol = true
            isOnclickNumber = false
            
            if iC >= 1{//重复按等于号实现最后一个数连续相同的模式进行运算：如 3+1=3 再按=+1。+1。+1。+1如此反复。4*2=8，*2. *2. *2...
                if arrNumber.count > 0 && arrSymbol.count > 0{
                    numberOfChars = arrNumber.last!
                    symbolOfCurrentSate = arrSymbol.last!
                    arrNumber.append(numberOfChars)
                    arrSymbol.append(symbolOfCurrentSate)
                    reckoning()
                }
             
            }
            iC += 1
        }
        
        print("numberOfChars:\(numberOfChars)===symbolOfCurrentSate\(symbolOfCurrentSate)===arrNumber\(arrNumber)===arrSymbol\(arrSymbol)")

        
    }
    
   

    //选中运算符号做出相应的背景颜色
    private func changeOnclickSelecteSateForBGColor(_ stateStr:String){
        switch stateStr {
        case "✖️":
            divideBtn?.isSelected = false
            multiplyBtn?.isSelected = true
            addBtn?.isSelected = false
            subtractBtn?.isSelected = false

        case "➗":
            divideBtn?.isSelected = true
            multiplyBtn?.isSelected = false
            addBtn?.isSelected = false
            subtractBtn?.isSelected = false
            
        case "➕":
            divideBtn?.isSelected = false
            multiplyBtn?.isSelected = false
            addBtn?.isSelected = true
            subtractBtn?.isSelected = false
        case "➖":
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
    //MARK - 计算结果reckoning
    private func reckoning(){
        if (arrSymbol.isEmpty && !arrNumber.isEmpty) || (!arrSymbol.isEmpty && !arrNumber.isEmpty && arrNumber.count == 1){
            result = stringToDouble(arrNumber[0])
        }else if !arrSymbol.isEmpty && !arrNumber.isEmpty{
            
           
            if arrSymbol.count == arrNumber.count{
                arrSymbol.removeLast()
            }
            
            result = searchSymbolWay(stateStr: arrSymbol.last ?? ""
                , num1: result, num2: stringToDouble(arrNumber.last ?? ""))
         
            
        }else if arrSymbol.isEmpty && arrNumber.isEmpty{
            result = 0
        }
        print("result:\(result)")
    }
    
    //MARK - 初始化属性值
    private func initAllProperty(){
 
        arrNumber = []
        numberOfChars = ""
        symbolOfCurrentSate = ""
        arrSymbol = []
        result = 0
        isOnclickEqualNoOnclickSymbol = false
        isOnclickEqual = false
        isOnclickSymbol = false
        isOnclickNumber = false
    }
    
    //MARK - 运算符号算法
    private func add(num1:Double,num2:Double) -> Double{//加
        let resultF:Double = num1 + num2
        
        return resultF
    }
    private func subtract(num1:Double,num2:Double) -> Double{//减
        let resultF:Double = num1 - num2
        return resultF
    }
    private func multiply(num1:Double,num2:Double) -> Double{//乘
        let resultF:Double = num1 * num2
        
        return resultF
    }
    private func divide(num1:Double,num2:Double) -> Double{//除
        let resultF:String = String(format:"%.2f",num1/num2)
        
        return stringToDouble(resultF)
    }
    
    
    private func searchSymbolWay(stateStr:String,num1:Double,num2:Double) -> Double{
         
        switch stateStr {
        case "➕":
            return add(num1: num1, num2: num2)
        case "➖":
            return subtract(num1: num1, num2: num2)
        case "✖️":
            return multiply(num1: num1, num2: num2)
        case "➗":
            return divide(num1: num1, num2: num2)
        default:
            return 0
        }
    }
    
    
    private func delegateCharacter(){//删除单个字符
        if !numberOfChars.isEmpty{
            numberOfChars.remove(at: numberOfChars.index(before: numberOfChars.endIndex))
        }
    }
    private func delegateItem(){//删除单个数
        numberOfChars = ""
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
    func removePiontCount(string:String) -> String{

        var str:String = string
        
        if stringToDouble(str).truncatingRemainder(dividingBy: 1) == 0{
            if !str.isEmpty{
                str.remove(at: str.index(before: str.endIndex))
            }
            if !str.isEmpty{
                str.remove(at: str.index(before: str.endIndex))
            }
            if !str.isEmpty{
                str.remove(at: str.index(before: str.endIndex))
            }
            return str
        }else{
            return string
        }
        
    }
    
    
     deinit {
        //移除监听
        self.removeObserver(self, forKeyPath: "symbolState")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeBtnColor"), object: nil)

    }
    
}

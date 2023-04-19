//
//  HZLEditPr.swift
//  RichEditing
//
//  Created by 郝忠良 on 2023/4/19.
//

import UIKit
/**
 注意！！！！！ 彩色块和自动检测的url颜色不可一致
 */
struct HZLEdit {
    
    var base : HZLEditView
    
    init(base:HZLEditView) {
        self.base = base
        HZLRichEdit.editView = base
    }
    /**
     添加彩色文字块
     showText 显示文字
     codeText 需要的源码
     textColor 显示颜色
     endSpace 默认是否添加空格
     */
    mutating func insertColorText(showText:String,codeText:String,textColor:String,endSpace:Bool = false){
        insert(attr: HZLRichEdit.creatColorAttr(text: showText, soure: codeText, showColor: textColor,endSpace: endSpace))
    }
    /**
     添加图
     icon 显示图片
     code 需要的源码
     endSpace 默认是否添加空格
     */
    mutating func insertIcon(icon:String,code:String,endSpace:Bool = false){
        insert(attr: HZLRichEdit.creatIconAttr(icon: icon, soure: code, endSpeace: endSpace))
    }
    /**
     检测url 在每次编辑框变化时调用
     */
    mutating func autoUrl(){
        let selectRange = base.selectRange
        guard let attr = HZLRichEdit.checkHasUrl(soureAttr: base.attr) else {return}
        base.attr = attr
        base.selectRange = selectRange
    }
    /**
     插入富文本并定位光标
     */
    mutating func insert(attr:NSAttributedString?){
        guard let attr = attr else {return}
        let selectRange = base.selectRange
        let relAttr = NSMutableAttributedString(attributedString: base.attr)
        relAttr.insert(attr, at: selectRange.location)
        base.attr = relAttr
        base.selectRange = .init(location: selectRange.location + attr.length, length: 0)
    }
    
    func getCode() -> String {
        let attr = base.attr
        if attr.length == 0 {
            return ""
        }
        return HZLRichEdit.getSoureText(soureAttr: attr)
    }
}

protocol HZLEditView {
    var selectRange : NSRange {set get}
    var attr : NSAttributedString {set get}
    var editColor : UIColor {get}
    var editFont : UIFont {get}
    var edit : HZLEdit { set get }
    func delete()
}

extension HZLEditView {
    var edit : HZLEdit {
        set{
            
        }
        get{
            return .init(base: self)
        }
    }
}

extension UITextView : HZLEditView {
    
    var editColor: UIColor {
        get{
            return textColor ?? .black
        }
    }
    
    var editFont: UIFont {
        get{
            return font ?? .systemFont(ofSize: 16)
        }
    }
    
    var selectRange: NSRange {
        get {
            return selectedRange
        }
        set {
            selectedRange = newValue
        }
    }
    
    var attr: NSAttributedString {
        get{
            return attributedText
        }
        set{
            attributedText = newValue
        }
    }
    
    func delete() {
        deleteBackward()
    }
}

extension UITextField : HZLEditView {
    
    var editColor: UIColor {
        get{
            return textColor ?? .black
        }
    }
    
    var editFont: UIFont {
        get{
            return font ?? .systemFont(ofSize: 16)
        }
    }
    
    var selectRange: NSRange {
        get {
            guard let select = selectedTextRange else {return .init(location: 0, length: 0)}
            let index = offset(from: beginningOfDocument, to: select.start)
            return .init(location: index, length: 0)
        }
        set {
            guard let select = selectedTextRange else {return}
            let offsetIndex = newValue.location
            var currentIndex = offset(from: endOfDocument, to: select.end)
            currentIndex += offsetIndex
            guard let newPos = position(from: endOfDocument, offset: currentIndex) else {return}
            selectedTextRange = textRange(from: newPos, to: newPos)
        }
    }
    
    var attr: NSAttributedString {
        get{
            return attributedText ?? NSAttributedString()
        }
        set{
            attributedText = newValue
        }
    }
    
    func delete() {
        deleteBackward()
    }
}

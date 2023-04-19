//
//  HZLRichEdit.swift
//  kaiheila_ios
//
//  Created by 忠良 on 2021/7/23.
//  Copyright © 2021 admin. All rights reserved.
//

import UIKit

struct HZLRichEdit {
    /**
     特殊颜色
     */
    static var especialColors : Set<String> = []
    static var config : HZLEditConfig = .default
    static var editView : HZLEditView = UITextView()
    static let CodeMark = "\u{2061}"
    
    static func norAttrKey(attr:NSMutableAttributedString,range:NSRange){
        attr.addAttribute(NSAttributedString.Key.font, value: editView.editFont, range: range)
    }
    
    /*
     是否包含空格
     */
    static func creatMarkAttr(isKong:Bool = true) -> NSMutableAttributedString {
        
        let str = isKong ? CodeMark + " " : CodeMark
        let attr = NSMutableAttributedString.init(string: str)
        let range = NSRange.init(location: 0, length: str.count)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: editView.editColor, range: range)
        attr.addAttribute(NSAttributedString.Key.font, value: editView.editFont, range: range)
        return attr
    }
    
    /**
     创建不同颜色文本块
     */
    static func creatColorAttr(text:String,soure:String,showColor:String,endSpace:Bool) -> NSMutableAttributedString? {
        
        if text.isEmpty {return nil }
        let showColor = showColor.uppercased()
        let relText : NSString = NSString.init(string: text)
        let attr = NSMutableAttributedString.init(string: text)
        let range = NSRange.init(location: 0, length: relText.length)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value:KHBgColor.init(hex: showColor), range: range)
        //添加附件
        let soureStr = KHAttachmentIcon.init()
        soureStr.text = text
        soureStr.soureText = soure
        soureStr.bounds = CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5)
        soureStr.image = UIImage.init(color: .clear)
        let attachment = NSAttributedString.init(attachment: soureStr)
        attr.append(attachment)
        attr.append(creatMarkAttr(isKong: endSpace))
        attr.insert(creatMarkAttr(isKong: false), at: 0)
        norAttrKey(attr: attr, range: NSRange.init(location: 0, length: attr.length))
        especialColors.insert(showColor)
        return attr
    }
    
    /**
     图文混排
     */
    static func creatIconAttr(icon:String,soure:String,endSpeace:Bool) -> NSMutableAttributedString? {
        
        guard let img = config.getIconImage(icon) else {
            return nil
        }        
        let soureMA = NSMutableAttributedString()
        
        let iconStr = KHAttachmentIcon.init()
        iconStr.soureText = soure
        iconStr.type = 1
        iconStr.image = img
        iconStr.bounds = CGRect.init(x: 0, y: -3 , width: 18, height: 18)

        let attr = NSAttributedString.init(attachment: iconStr)
        soureMA.append(creatMarkAttr(isKong: false))
        soureMA.append(attr)
        soureMA.append(creatMarkAttr(isKong: endSpeace))
        norAttrKey(attr: soureMA, range: NSRange.init(location: 0, length: soureMA.length))
        return soureMA
    }
    
    /**
     支持检测 动态检测url
     */
    static func checkHasUrl(soureAttr:NSAttributedString) -> NSMutableAttributedString?{
        let text = soureAttr.string
        if text.isEmpty || config.urlCode == nil{
            return nil
        }
        let regex = try? NSRegularExpression(pattern: config.autoUrl)
        let range = NSRange(text.startIndex..., in: text)
        let urls = regex?.matches(in: text, range: range) ?? []
        let orAttr = urlToNormal(soureAttr: soureAttr)
        if urls.count > 0 {
            for match in urls {
                let range = match.range
                let o = orAttr.attributes(at: range.location, effectiveRange: nil)
                if let color = o[NSAttributedString.Key.foregroundColor] as? UIColor , especialColors.contains(where: { hex in
                    return color == UIColor.init(hex: hex)
                }){
                   continue
                }
                orAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: config.urlColor), range: range)
            }
        }
        
        return orAttr
    }
    
    //还原url
    static func  urlToNormal(soureAttr:NSAttributedString) -> NSMutableAttributedString{
        let editText = soureAttr.string
        let relEditText : NSString = NSString.init(string: editText)
        let range = NSRange.init(location: 0, length: relEditText.length)
        let orAttr = NSMutableAttributedString.init(attributedString: soureAttr)
        soureAttr.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: range, options: NSAttributedString.EnumerationOptions.reverse) { (info, range, point) in
            guard let info = info as? UIColor else {return}
            if info == UIColor.init(hex: config.urlColor) {
                orAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: editView.editColor, range: range)
            }
        }
        return orAttr
    }
    
    static func getKeyValue(soureAttr:NSAttributedString) -> [KHAttachmentIcon]{
        
        var soureAm : [KHAttachmentIcon] = []
        
        let relEditText : NSString = NSString.init(string: soureAttr.string)
        let range = NSRange.init(location: 0, length: relEditText.length)
        
        soureAttr.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: range, options: NSAttributedString.EnumerationOptions.reverse) { (info, range, point) in
            
            guard let info = info as? UIColor else {return}
            
            if especialColors.contains(where: { hex in
                return info == UIColor.init(hex: hex)
            }) {
                let attment = KHAttachmentIcon.init()
                attment.text = relEditText.substring(with: range)
                attment.soureText = attment.text
                attment.range = range
                soureAm.append(attment)
            }else if info == UIColor.init(hex: config.urlColor) {
                let attment = KHAttachmentIcon.init()
                attment.text = relEditText.substring(with: range)
                attment.soureText =  config.urlCode?(attment.text) ?? ""
                attment.range = range
                soureAm.append(attment)
            }
        }
        
        soureAttr.enumerateAttribute(NSAttributedString.Key.attachment, in: range, options: NSAttributedString.EnumerationOptions.reverse) { (info, range, point) in
            guard let khInfo = info as? KHAttachmentIcon else{return}
            if khInfo.type == 0 {
                //插入附件替换源
                for item in soureAm {
                    if range.location == (item.range.location + item.range.length) && item.text == khInfo.text {
                        item.soureText = khInfo.soureText
                        item.soureMo = khInfo.soureMo
                        break
                    }
                }
                //剔除附件
                let newKhInfo = KHAttachmentIcon()
                newKhInfo.text = ""
                newKhInfo.range = range
                newKhInfo.soureText = ""
                soureAm.append(newKhInfo)
            }else{
                khInfo.range = range
                soureAm.append(khInfo)
            }
        }
        
        soureAm.sort { (val1, val2) -> Bool in
            return val1.range.location > val2.range.location
        }
        return soureAm
    }
    
    static func getSoureText(soureAttr:NSAttributedString) -> String{
        let tex = soureAttr.string
        if tex.isEmpty { return tex}
        let soureAm = getKeyValue(soureAttr: soureAttr)
        let nsText : NSMutableString = NSMutableString.init(string: soureAttr.string)
        for attachment in soureAm {
            
            nsText.replaceCharacters(in: attachment.range, with: attachment.soureText)
        }
        return nsText.replacingOccurrences(of: CodeMark, with: "")
    }
    
    /**
     是否删除整个彩色块
     */
    static func delectText(delStr:String,textEditView:HZLEditView) -> Bool {
        
        guard delStr == CodeMark else { return false}
        var textEditView = textEditView
        textEditView.delete()
        let selRange = textEditView.selectRange
        let soureAttr = textEditView.attr
        let selLoction = selRange.location
        let nsStr : NSString = NSString.init(string: soureAttr.string)
        let subStr = nsStr.substring(to: selLoction)
        let nsSubStr : NSString =  NSString.init(string: subStr)
        let loction = nsSubStr.range(of: CodeMark, options: NSString.CompareOptions.backwards).location
        if loction != NSNotFound {
            let soureMA =
                NSMutableAttributedString.init(attributedString: soureAttr)
            soureMA.replaceCharacters(in: NSRange.init(location: loction, length: selLoction - loction), with: "")
            textEditView.attr = soureMA
            textEditView.selectRange = NSRange.init(location: loction, length: 0)
        }
        
        return true
    }

}


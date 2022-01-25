//
//  ChatEditTool.swift
//  kaiheila_ios
//
//  Created by 忠良 on 2021/7/23.
//  Copyright © 2021 admin. All rights reserved.
//

import UIKit


class ChatEditTool: NSObject {
    
    
    var decodeItems : [EditDecodeItemModel] = []
    
    var especialColor : String = "#FF6666CC"
    
    var textEdit : UITextView = UITextView.init()
    
    var textSoures : [String : String]  = [:]
    
    var iconImage : [String:UIImage] = [:]
    
    var selRange : NSRange{
        return textEdit.selectedRange
    }
    
    var soureAttr : NSAttributedString {
        return textEdit.attributedText
    }
    
    var editText : String {
        return textEdit.text
    }
    
    var decodeAttr : NSMutableAttributedString = NSMutableAttributedString.init()
    
    override init() {
        super.init()
    }
    
    
    func norAttrKey(attr:NSMutableAttributedString,range:NSRange){
        
//        var color = ThemeManager.color(for: "ufcolor.#333436")
//        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: range)
    }
    
    func creatNorTextAttr(text:String) {
        
        if text.isEmpty {
            return
        }
        
        var attr = NSMutableAttributedString.init(string: text)
        var range = NSRange.init(location: 0, length: NSString.init(string: text).length)
        var color = UIColor.init(hex: "#333436")
        
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: range)
        decodeAttr.append(attr)
    }
    
    
    func creatNorAttr(isKong:Bool = true) -> NSMutableAttributedString {
        
        var str = "\u{2061}"
        
        if isKong {
            
            str = "\u{2061} "
        }
        
        var attr = NSMutableAttributedString.init(string: str)
        
        var range = NSRange.init(location: 0, length: str.count)
        var color = UIColor.init(hex: "#333436")
        
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: range)
                
        return attr
    }
    //@
    func creatMentionAttr(text:String,soure:String,isDecode:Bool = false) {
        
        if text.isEmpty {
            return
        }
        var sattr = soureAttr
        if !isDecode {
           sattr =  self.insertLocation(type: 0)
        }
        var soureMA = NSMutableAttributedString.init(attributedString: sattr)
        var relText : NSString = NSString.init(string: text)
        
        var attr = NSMutableAttributedString.init(string: text)
        var range = NSRange.init(location: 0, length: relText.length)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value:KHBgColor.init(hex: self.especialColor), range: range)
        
        var soureStr = KHAttachmentIcon.init()
        soureStr.text = text
        soureStr.soureText = soure
        soureStr.bounds = CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5)
        soureStr.image = UIImage.init(color: .clear)
        
        var attachment = NSAttributedString.init(attachment: soureStr)
        attr.append(attachment)
        
        self.norAttrKey(attr: attr, range: range)
    
        if isDecode {
            
            self.decodeAttr.append(self.creatNorAttr(isKong: false))
            self.decodeAttr.append(attr)
            self.decodeAttr.append(self.creatNorAttr(isKong: false))
            
        }else{
            
            soureMA.insert(self.creatNorAttr(), at: selRange.location)
            soureMA.insert(attr, at: selRange.location)
            soureMA.insert(self.creatNorAttr(isKong: false), at: selRange.location)
            textEdit.attributedText = soureMA
        }
        
        
        textSoures[text] = soure
    }
    
    //#
    func creatChannelAttr(text:String,soure:String,isDecode:Bool = false) {
        
        if text.isEmpty {
            return
        }
        var sattr = soureAttr
        if !isDecode {
           sattr =  self.insertLocation(type: 1)
        }
        var soureMA = NSMutableAttributedString.init(attributedString: sattr)
            
        var attr = NSMutableAttributedString.init(string: text)
        let reStr = NSString.init(string: text)
        var range = NSRange.init(location: 0, length: reStr.length)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value:KHBgColor.init(hex: self.especialColor), range: range)
        
        
        var soureStr = KHAttachmentIcon.init()
        soureStr.text = text
        soureStr.soureText = soure
        soureStr.bounds = CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5)
        soureStr.image = UIImage.init(color: .clear)
        var attachment = NSAttributedString.init(attachment: soureStr)
        attr.append(attachment)
        
        self.norAttrKey(attr: attr, range: range)

        if isDecode {
            
            self.decodeAttr.append(self.creatNorAttr(isKong: false))
            self.decodeAttr.append(attr)
            self.decodeAttr.append(self.creatNorAttr(isKong: false))
            
        }else{
            
            soureMA.insert(self.creatNorAttr(), at: selRange.location)
            soureMA.insert(attr, at: selRange.location)
            soureMA.insert(self.creatNorAttr(isKong: false), at: selRange.location)
            textEdit.attributedText = soureMA
        }
                
        textSoures[text] = soure
    }
    
    //服务器表情
    func creatIconAttr(icon:String,soure:String,isDecode:Bool = false) {
        
        //EmojiHeadUrl + "\(icon).png"
        
        guard let img = self.geticonImg(keyStr: "icon.png") else {
            return
        }        
        var soureMA = NSMutableAttributedString.init(attributedString: soureAttr)
        
        var iconStr = KHAttachmentIcon.init()
        
        iconStr.soureText = soure
        iconStr.image = img
        iconStr.type = 1
        
        iconStr.bounds = CGRect.init(x: 0, y: -3 , width: 18, height: 18)

        var attr = NSAttributedString.init(attachment: iconStr)
        
        if isDecode {
            
            self.decodeAttr.append(self.creatNorAttr(isKong: false))
            self.decodeAttr.append(attr)
            self.decodeAttr.append(self.creatNorAttr(isKong: false))
            
        }else{
            
            soureMA.insert(self.creatNorAttr(isKong: true), at: selRange.location)
            soureMA.insert(attr, at: selRange.location)
            soureMA.insert(self.creatNorAttr(isKong: false), at: selRange.location)
            
            textEdit.attributedText = soureMA
        }
       
        
    }
    
    func insertLocation(type:Int) -> NSAttributedString{
        
        var selLoction = self.selRange.location
        
        var nsStr : NSString = NSString.init(string: editText)
        var subStr = nsStr.substring(to: selLoction)

        var nsSubStr : NSString =  NSString.init(string: subStr)
        
        let loction = nsSubStr.range(of: (type == 0 ? "@" : "#"), options: NSString.CompareOptions.backwards).location
        
        if loction != NSNotFound {
            
            var subRange = NSRange.init(location: loction, length: selLoction - loction)
            var reStr = nsStr.substring(with: subRange)
            
            if !reStr.contains("\u{2061}") {
                
                var soureMA =
                     NSMutableAttributedString.init(attributedString: soureAttr)
                soureMA.replaceCharacters(in:subRange , with: "")
                textEdit.selectedRange = NSRange.init(location: loction, length: 0)
                return soureMA
            }
           
        }
       
        return textEdit.attributedText
    }

    var soureAm : [KHAttachmentIcon] = []
    
    func getKeyValue(){

        soureAm.removeAll()
        
        var relEditText : NSString = NSString.init(string: editText)
        var range = NSRange.init(location: 0, length: relEditText.length)
    
        soureAttr.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: range, options: NSAttributedString.EnumerationOptions.reverse) { (info, range, point) in
    
            let str = "\(info)"
            //此字符串和 定义的 透明度
            if str == "Optional(#6666CCFF)" {
                var attment = KHAttachmentIcon.init()
                attment.text = relEditText.substring(with: range)
                attment.soureText = attment.text
                attment.range = range
                soureAm.append(attment)
            }
            
        }
        
        soureAttr.enumerateAttribute(NSAttributedString.Key.attachment, in: range, options: NSAttributedString.EnumerationOptions.reverse) { (info, range, point) in
            
            guard let khInfo = info as? KHAttachmentIcon else{return}
            
            if khInfo.type == 0 {
                
                for item in self.soureAm {
                    if range.location == (item.range.location + item.range.length) && item.text == khInfo.text {
                        item.soureText = khInfo.soureText
                        break
                    }
                }
                
                var newKhInfo = KHAttachmentIcon()
                newKhInfo.text = ""
                newKhInfo.range = range
                newKhInfo.soureText = ""
                soureAm.append(newKhInfo)
                
            }else{
                
                khInfo.range = range
                soureAm.append(khInfo)
            }
            
        }
        
        
        try? soureAm.sort { (val1, val2) -> Bool in
            
            return val1.range.location > val2.range.location
        }
        

    }
   
    
    func getSoureText() -> String{
        
        let tex = textEdit.text ?? ""
        
        if tex.isEmpty {
            return tex
        }
        
        getKeyValue()
    
        var nsText : NSMutableString = NSMutableString.init(string: editText)

        for attachment in soureAm {
            
            nsText.replaceCharacters(in: attachment.range, with: attachment.soureText)
        }
        
        return nsText.replacingOccurrences(of: "\u{2061}", with: "")
    }
    
    func delectText(loction:Int){
        
        var selLoction = self.selRange.location
        
        var nsStr : NSString = NSString.init(string: editText)
        var subStr = nsStr.substring(to: selLoction)

        var nsSubStr : NSString =  NSString.init(string: subStr)
        
        let loction = nsSubStr.range(of: "\u{2061}", options: NSString.CompareOptions.backwards).location
        
        if loction != NSNotFound {
            
            var soureMA =
                NSMutableAttributedString.init(attributedString: soureAttr)
            
            soureMA.replaceCharacters(in: NSRange.init(location: loction, length: selLoction - loction), with: "")
            
            textEdit.attributedText = soureMA
        }
       
        
    }
    
    //TODO:
    func didChangeSelection(){

    }
    
    
    func geticonImg(keyStr:String) -> UIImage?{
        
//        var path = ImageCache.default.cachePath(forKey: keyStr)
        var path = keyStr
        return UIImage.init(contentsOfFile: path)
        
    }

    
    func decodeSoure(soureText:String) -> NSMutableAttributedString  {

        if soureText.isEmpty {
            return self.decodeAttr
        }


        var newContent = soureText
        
        //  处理出来的 items
        self.dealContentStr()
        
        var nsSourtStr : NSString = NSString.init(string: newContent)
        
        self.decodeItems.sort { (val1, val2) -> Bool in
            
            return val1.range.location < val2.range.location
        }
        
        for codeItem in self.decodeItems.reversed() {
            
            let ra = codeItem.range
            if (ra.location + ra.length > nsSourtStr.length) || ra.location < 0 {
                continue
            }
            nsSourtStr =  nsSourtStr.replacingCharacters(in: ra, with: "\u{2064}") as NSString
        }
        
        var soureStrs = nsSourtStr.components(separatedBy: "\u{2064}")
        
        for (i,str) in soureStrs.enumerated() {
            
            self.creatNorTextAttr(text: str)
            if i < self.decodeItems.count {
                
                var item = self.decodeItems[i]
                
                if item.type == 0 {
                    
                    self.creatMentionAttr(text: item.text, soure: item.soureText,isDecode: true)
                }else{
                    self.creatIconAttr(icon: item.text, soure: item.soureText,isDecode: true)
                }
                
            }
        }

        return self.decodeAttr

    }
    
    func dealContentStr() {
        
        //依赖正则 把符合的str 转为
        
        self.decodeItems = []
        
//        let textContent = "\\[#(\\d+);\\]".r?.replaceAll(in: newContent, using: { (macth) -> String? in
//            let i = Int(macth.group(at: 1)!, radix: 10) ?? 0
//            let s = macth.group(at: 0) ?? ""
//            if Utils.isUniCodeInt(a: i) , let a =  UnicodeScalar(i) {
//                return  String(a)
//            }
//            return s
//        }) ?? newContent
//
//        var mentionUsers:[String] = []
//
//        var mentions = "(@[^#]{0,60})#(\\d{1,11})".r?.findAll(in: textContent)
//
//        for macth in mentions! {
//            let userId = macth.group(at: 2) ?? ""
//            mentionUsers.append(userId)
//            var item = EditDecodeItemModel.init()
//            item.text = "\(macth.group(at: 1) ?? "")"
//            item.soureText = macth.group(at: 0) ?? ""
//            item.range =  NSRange.init(macth.range, in: textContent)
//            self.decodeItems.append(item)
//        }
//
//        var alls = "@全体成员".r?.findAll(in: textContent)
//
//        for match in alls! {
//
//            var item = EditDecodeItemModel.init()
//            item.text = "\(match.group(at: 0)!)"
//            item.soureText = match.group(at: 0) ?? ""
//            item.range = NSRange.init(match.range, in: textContent)
//
//            self.decodeItems.append(item)
//
//        }
//
//        var lines = "@在线成员".r?.findAll(in: textContent)
//
//        for match in lines! {
//
//            var item = EditDecodeItemModel.init()
//            item.text = "\(match.group(at: 0)!)"
//            item.soureText = match.group(at: 0) ?? ""
//            item.range = NSRange.init(match.range, in: textContent)
//            self.decodeItems.append(item)
//        }
//
//        var roles = "@role:(\\d+);".r?.findAll(in: textContent)
//
//        for match in roles! {
//
//            var deitem = EditDecodeItemModel.init()
//            let roleId = match.group(at: 1)!
//            let roles = guildNetworkService.curGuild?.roles ?? []
//            for (index,item) in roles.enumerated() {
//                if "\(item.role_id)" == roleId {
//
//                    deitem.text = "@\(item.name)"
//                    deitem.soureText = match.group(at: 0) ?? ""
//
//                    break;
//                }
//            }
//
//            if deitem.text == "" {
//                deitem.text = "@角色已删除"
//            }
//            deitem.range = NSRange.init(match.range, in: textContent)
//            self.decodeItems.append(deitem)
//
//        }
//
//        var channels = "#channel:(\\d+);".r?.findAll(in: textContent)
//        for macth in channels! {
//
//            var deitem = EditDecodeItemModel.init()
//
//            let channelId = (macth.group(at: 1)!)
//            if let channel = guildNetworkService.channelIdToChannelModel(channelId){
//
//                    deitem.text = "#\(channel.name)"
//                    deitem.soureText = macth.group(at: 0) ?? ""
//
//            }else{
//
//                deitem.text = "#频道已删除"
//                deitem.soureText = macth.group(at: 0) ?? ""
//            }
//
//            deitem.range = NSRange.init(macth.range, in: textContent)
//            self.decodeItems.append(deitem)
//
//        }
//
//
//        var icons = "\\[:[^:]+:([0-9a-zA-Z/]+)\\]".r?.findAll(in: textContent)
//
//        for match in icons! {
//
//            var deitem = EditDecodeItemModel.init()
//            deitem.text = match.group(at: 1) ?? ""
//            deitem.soureText = match.group(at: 0) ?? ""
//            deitem.range = NSRange.init(match.range, in: textContent)
//            deitem.type = 1
//            self.decodeItems.append(deitem)
//
//        }
        
    }
    
}


class KHAttachmentIcon: NSTextAttachment {
    
    var text : String = "" //原text
    var soureText : String = ""
    var range : NSRange = NSRange.init(location: 0, length: 0)
    var type : Int = 0 // 0 text  1 icon
}

class EditDecodeItemModel : NSObject{
    
    var text : String = ""
    var soureText : String = ""
    var range : NSRange = NSRange.init(location: 0, length: 0)
    var type : Int = 0 // 0 text 1 icon
    
}


class KHBgColor: UIColor {
        
    var soureText : String = ""
}

extension UIColor {

    @objc
    public convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let alpha, red, green, blue: UInt32
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha) / 255)
    }

}

extension UIImage {

    @objc
    public convenience init(color: UIColor?) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color?.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }

}

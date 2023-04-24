//
//  HZLClass.swift
//  RichEditing
//
//  Created by 郝忠良 on 2023/4/10.
//

import UIKit

class KHAttachmentIcon: NSTextAttachment {
    var text : String = "" //原text
    var soureText : String = "" //若为url  soure是href
    var range : NSRange = NSRange.init(location: 0, length: 0)
    var type : Int = 0 // 0 text  1 icon
    var soureMo : Any? // GuildUserModel or GuildRoleModel
    var urlEq : Bool = false
}

class KHBgColor: UIColor {
    var soureText : String = ""
}

//MARK: -HZLEditConfig

struct HZLEditConfig {
    
    static var `default` = HZLEditConfig()
    /**
     编辑文字默认颜色
     */
    var normalColor : String = "#333333"
    /**
     编辑文字默认字体
     */
    var normalFont : UIFont = .systemFont(ofSize: 16)
    /**
     图文混排图片地址
     */
    var getIconImage : (String)->(UIImage?) = {_ in nil }
    /*
     图大小
     */
    var iconBouns : CGRect = .zero
    /**
     配置自动检测链接的正则表达式
     */
    var autoUrl : String = "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
    /**
     匹配到url的颜色配置
     */
    var urlColor : String = "#0096FC" {
        didSet{
            urlColor = urlColor.uppercased()
        }
    }
    /**
     url对应的源码
     配置则检测 不配置不检测
     */
    var urlCode : ((String)->(String))?

}




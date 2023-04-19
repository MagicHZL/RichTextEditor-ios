//
//  ViewController.swift
//  RichEditing
//
//  Created by 郝忠良 on 2023/4/10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var codeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HZLRichEdit.config.urlColor = "#333333"
        HZLRichEdit.config.urlCode = { url in
            return "我是url"
        }
        HZLRichEdit.config.getIconImage = {icon in
            return .init(named: icon)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        textView.becomeFirstResponder()
    }

    @IBAction func one(_ sender: Any) {
        
        textView.edit.insertColorText(showText: "aaa", codeText: "bbb", textColor: "#b85aad")
        
    }
    
    @IBAction func two(_ sender: Any) {
        textView.edit.insertColorText(showText: "aaa", codeText: "ccc", textColor: "#779d86")
    }
    @IBAction func three(_ sender: Any) {
        
        textView.edit.insertIcon(icon: "icon", code: "我是图1")
    }
    
    @IBAction func four(_ sender: Any) {
        textView.edit.insertIcon(icon: "icon", code: "我是图2")
    }
    
    @IBAction func five(_ sender: Any) {
        textView.edit.autoUrl()
    }
    
    @IBAction func delect(_ sender: Any) {
        
        if textView.selectRange.location = 0 {
            return
        }
        
        //模拟获取删除
        let nsText = NSString(string: textView.text)
        let delStr = nsText.substring(with:.init(location: textView.selectRange.location - 1, length: 1))
        textView.edit.delect(delStr: delStr)
        
    }
    @IBAction func get(_ sender: Any) {
        codeText.text = textView.edit.getCode()
    }
}


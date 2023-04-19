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
    
    @IBAction func get(_ sender: Any) {
        codeText.text = textView.edit.getCode()
    }
}


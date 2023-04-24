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
        textView.delegate = self
        
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
    
    @IBAction func get(_ sender: Any) {
        codeText.text = textView.edit.getCode()
    }
}

extension ViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        defer{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.textView.edit.autoUrl()
            }
        }
        return !self.textView.edit.delect(text: text, range: range)
    }

}


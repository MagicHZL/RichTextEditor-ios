# RichEditing
## 简介
一款简单的使你的编辑框支持富文本编辑器的插件

## 使用方式

### 引入
直接把 **Soure** 目录下的源码引入即可

### 配置

**HZLEditConfig** 做为配置文件有详细的配置说明 可直接修改配置 或者代码动态修改

**Color**配置为 16进制字符串
``` swift
HZLRichEdit.config.urlColor = "#333333"
HZLRichEdit.config.urlCode = { url in
    return "somthing code"
}
HZLRichEdit.config.getIconImage = {icon in
    //TODO:获取图片
    return .init(named: icon)
}
```

### 基本使用

#### 添加文本色块

``` swift
textView.edit.insertColorText(showText: "aaa", codeText: "bbb", textColor: "#b85aad")

```
#### 添加icon
``` swift
textView.edit.insertIcon(icon: "icon", code: "我是图1")
```
#### 自动检测是否存在链接
需要在文字改变时调用
``` swift
textView.edit.autoUrl()
```

#### 删除
需要在删除时调用
``` swift
textView.edit.delect(delStr: "")
```

#### 获取源码
``` swift
let code = textView.edit.getCode()
```

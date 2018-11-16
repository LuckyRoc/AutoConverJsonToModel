//
//  ViewController.swift
//  AutoConverJsonToModel
//
//  Created by 程瑞朋 on 2018/11/16.
//  Copyright © 2018 LuckyRoc. All rights reserved.
//

import Cocoa
import AppKit

class ViewController: NSViewController {
    @IBOutlet weak var jsonText: NSTextField!
    @IBOutlet weak var swiftCode: NSTextField!
    @IBOutlet weak var ifCode: NSComboBox!
    @IBOutlet weak var languageType: NSComboBox!
    @IBOutlet weak var Model: NSTextField!
    @IBAction func tranAction(sender: AnyObject) {
        if languageType.indexOfSelectedItem == 1 {
            //            genericOC()
        }else{
            swiftCode.stringValue = "import HandyJSON\n"
            let json = jsonText.stringValue
            genericSwift(key: "DataModel", json: json)
        }
    }
    var classArray = [String]()
    var jsonDicts = [JsonDictionaryModel]()
    var jsonArrays = [JsonArrayModel]()
    
    func genericSwift(key: String, json: String) {
        do {
            let dic = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            let dict = dic as! [String:AnyObject]
            swiftCode.stringValue += "}\nclass \(key): HandyJSON {\n"
            for (key, value) in dict {
                switch value {
                case is Int:
                    swiftCode.stringValue += "\tvar \(key): Int?\n"
                case is String:
                    swiftCode.stringValue += "\tvar \(key): String?\n"
                case is Bool:
                    swiftCode.stringValue += "\tvar \(key): Bool?\n"
                case is Array<Any>:
                    swiftCode.stringValue += "\tvar \(key): [\(key.capitalized)Model]?\n"
                    jsonArrays.append(JsonArrayModel(key: key, value: value as? Array))
                case is Dictionary<String, Any>:
                    swiftCode.stringValue += "\tvar \(key): \(key.capitalized)Model?\n"
                    jsonDicts.append(JsonDictionaryModel(key: key, value: value as? Dictionary))
                default:
                    break
                }
            }
            dowsfas()
        }
        catch{
            
        }
    }
    func dowsfas() {
        for (index, item) in jsonArrays.enumerated() {
            if item.value != nil {
                jsonArrays.remove(at: index)
                arrayTojson(key: item.key, value: item.value!)
            }
        }
        for (index, item)  in jsonDicts.enumerated() {
            if item.value != nil {
                jsonDicts.remove(at: index)
                stringToJson(key: item.key, value: item.value!)
            }
        }
    }
    func stringToJson(key: String, value: Dictionary<String, Any>) {
        let data = try? JSONSerialization.data(withJSONObject: value, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        self.genericSwift(key: key.capitalized + "Model", json: str!)
    }
    func arrayTojson(key: String, value: Array<Any>) {
        if value.count > 0 {
            let dict = value[0]
            let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            let str = String(data: data!, encoding: String.Encoding.utf8)
            self.genericSwift(key: key.capitalized + "Model", json: str!)
        } else {
            swiftCode.stringValue += "}"
        }
    }
    
    func isCoder() -> Bool {
        return ifCode.indexOfSelectedItem == 1 ? true : false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ifCode.isHidden = true
        languageType.isHidden = true
        Model.isHidden = true
    }
    
    
    //    func genericOC()  {
    //        let json =  jsonText.stringValue
    //        do {
    //            let dic = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments)
    //            let dict = dic as! [String:AnyObject]
    //            swiftCode.stringValue += "@interface \(Model.stringValue) : JSONModel\n\n"
    //            for (key,value) in dict {
    //                switch value {
    //                case is NSNumber,is NSInteger:
    //                    swiftCode.stringValue += "@property (assign, nonatomic) int \(key);\n"
    //                case is NSString:
    //                    swiftCode.stringValue += "@property (strong, nonatomic) NSString* \(key);\n"
    //                case is Bool:
    //                    swiftCode.stringValue += "@property (assign, nonatomic) Bool \(key);\n"
    //                default:
    //                    swiftCode.stringValue += "@property (strong, nonatomic) \(value.classForCoder!)* \(key);\n"
    //                }
    //            }
    //            swiftCode.stringValue += "\n@end\n"
    //
    //            swiftCode.stringValue += "@implementation \(Model.stringValue) \n@end"
    //        }
    //        catch{
    //
    //        }
    //    }
    override var representedObject: Any? {
        didSet {
        }
    }
    
    
}

class JsonDictionaryModel {
    var key: String!
    var value: Dictionary<String, Any>?
    init(key: String, value: Dictionary<String, Any>?) {
        self.key = key
        self.value = value
    }
    
}
class JsonArrayModel {
    var key: String!
    var value: Array<Any>?
    init(key: String, value: Array<Any>?) {
        self.key = key
        self.value = value
    }
}

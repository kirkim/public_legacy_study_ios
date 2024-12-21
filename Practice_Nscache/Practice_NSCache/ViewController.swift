//
//  ViewController.swift
//  Practice_NSCache
//
//  Created by 김기림 on 2022/08/02.
//

import UIKit

class Storage {
    var value:Int = 0
    var string:[String] = []
}

class ViewController: UIViewController {
    
    private let cache = NSCache<NSString, Storage>()
    private var dic: [String: Storage] = [:]
    private let lock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    private func initData() {
        cache.setObject(Storage(), forKey: NSString(string:"cache"))
        dic["dic"] = Storage()
    }
    
    @IBAction func addCacheValue(_ sender: Any) {
        //        DispatchQueue.global().async {
        //            self.addCacheValue2(str: "a")
        //        }
        //        DispatchQueue.global().async {
        //            self.addCacheValue2(str: "b")
        //        }
        //        DispatchQueue.global().async {
        //            self.addCacheValue2(str: "c")
        //        }
        DispatchQueue.global().async {
            self.addCacheValue()
        }
        DispatchQueue.global().async {
            self.addCacheValue()
        }
        DispatchQueue.global().async {
            self.addCacheValue()
        }
    }
    
    @IBAction func addDicValue(_ sender: Any) {
        //        DispatchQueue.global().async {
        //            self.addDicValue2(str: "a")
        //        }
        //        DispatchQueue.global().async {
        //            self.addDicValue2(str: "b")
        //        }
        //        DispatchQueue.global().async {
        //            self.addDicValue2(str: "c")
        //        }
        DispatchQueue.global().async {
            self.addDicValue()
        }
        DispatchQueue.global().async {
            self.addDicValue()
        }
        DispatchQueue.global().async {
            self.addDicValue()
        }
    }
    
    
    
    func addCacheValue() {
        sleep(1)
        guard let cacheValue = self.cache.object(forKey: NSString(string:"cache")) else {
            print("Cache fail!")
            return
        }
        cacheValue.value += 1
        self.cache.setObject(cacheValue, forKey: NSString(string:"cache"))
        print("cache: ", cacheValue.value)
    }
    
    func addDicValue() {
//        sleep(1)
//        self.lock.lock()
//        defer { self.lock.unlock() }
        guard let dicValue = self.dic["dic"] else {
            print("dictionary fail!")
            return
        }
        dicValue.value += 1
        self.dic.updateValue(dicValue, forKey: "dic")
        print("dictionary: ", dicValue.value)
    }
    
    func addCacheValue2(str: String) {
        guard let cacheValue = self.cache.object(forKey: NSString(string:"cache")) else {
            print("Cache fail!")
            return
        }
        cacheValue.string.append(str)
        self.cache.setObject(cacheValue, forKey: NSString(string:"cache"))
        print("cache: ", cacheValue.string)
    }
    
    func addDicValue2(str: String) {
        guard let dicValue = self.dic["dic"] else {
            print("dictionary fail!")
            return
        }
        dicValue.string.append(str)
        self.dic.updateValue(dicValue, forKey: "dic")
        print("dictionary: ", dicValue.string)
    }
}


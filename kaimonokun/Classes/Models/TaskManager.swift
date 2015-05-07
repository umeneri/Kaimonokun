//
//  TaskManager.swift
//  kaimonokun
//
//  Created by umeneri on 2015/05/07.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation

// finalはシングルトンクラスとして必要
final class TaskManager {
    let STORE_KEY = "TaskManager.store_key"
    
    // TaskManagerを単一インスタンスに
    // ここはかなり詰まった。 さらにバージョンによって書き方が変わる
    //let sharedInstance = TaskManager()
    class var sharedInstance : TaskManager {
        struct Static {
            static let instance : TaskManager = TaskManager()
        }
        return Static.instance
    }
    //
    //    class var sharedInstance : TaskManager {
    //        struct Static {
    //            static var instance : TaskManager?
    //        }
    //
    //        if !Static.instance {
    //            Static.instance = TaskManager()
    //        }
    //        return Static.instance!
    //    }
    //
    var taskList : [Task]
    var size : Int {
        get {
            return taskList.count
        }
        set {
            println(newValue)
        }
    }
    
    
    // private はシングルトンの場合は必須
    private init() {
        /* ストレージからデータ読み出し*/
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data  = defaults.objectForKey(self.STORE_KEY) as? [String] {
            self.taskList = data.map { title in
                Task(title: title)
            }
        } else {
            self.taskList = []
        }
    }
    
    func save() {
        /* ストレージへデータ書き出し*/
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = self.taskList.map { Task in
            Task.title
        }
        defaults.setObject(data, forKey: self.STORE_KEY)
        defaults.synchronize()
    }
    
    class func validate(task: Task!) -> Bool {
        // sample にミスが
        //return Task != nil && Task.title != ""
        return task.title != ""
    }
    
    func create(task: Task!) -> Bool {
        if TaskManager.validate(task) {
            self.taskList.append(task)
            self.save()
            return true
        }
        
        println("not valid")
        
        return false
    }
    
    func update(task: Task!, at index: Int) -> Bool {
        if index >= self.taskList.count {
            return false
        }
        
        
        if TaskManager.validate(task) {
            taskList[index] = task
            self.save()
            return true
        }
        println("not valid")
        return false
    }
    
    func remove(index: Int) -> Bool {
        if index >= self.taskList.count {
            return false
        }
        self.taskList.removeAtIndex(index)
        self.save()
        
        return true
    }
    
    func insert(task: Task!,  index: Int) -> Bool {
        if index >= self.taskList.count {
            return false
        }
        
        self.taskList.insert(task, atIndex: index)
        self.save()
        
        return true
    }
    
    subscript(index: Int) -> Task {
        return taskList[index]
    }
    
}
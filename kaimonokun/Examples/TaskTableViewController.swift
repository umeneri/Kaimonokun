//
//  TaskTableViewController.swift
//  TaskApp
//
//  Created by umeneri on 2015/04/29.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation
import UIKit

enum TaskAlertViewType {
    case Create, Update(Int), Remove(Int)
}

class TaskTableViewController : UIViewController {
    var taskManager = TaskManager.sharedInstance
    var tableView : UITableView?
    var alertType : TaskAlertViewType?
    // widthなどがメンバ変数の場合はinitが必要
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var width : CGFloat
        var height : CGFloat
        width = self.view.frame.size.width
        height = self.view.frame.size.height
        println(UIScreen.mainScreen().bounds.size.width)
        
        let header = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 64))
        header.image = UIImage(named: "header")
        // header をタッチ可能領域にする
        header.userInteractionEnabled = true
        
        let title = UILabel(frame: CGRect(x: 10, y: 20, width: width, height: 44))
        title.text = "Taskリスト 🐶"
        header.addSubview(title)
        
        // as!での型変換がないとだめ
        let button = UIButton.buttonWithType(.System) as! UIButton
        button.frame = CGRect(x: 320 - 100, y: 20, width: 100, height: 44)
        button.setTitle("(ΦωΦ)", forState: .Normal)
        button.addTarget(self, action:"showCreateView", forControlEvents: .TouchUpInside)
        header.addSubview(button)
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: width, height: height - 60))
        //  ?
        self.tableView!.dataSource = self
        println(self.tableView?.bounds.size)
        self.view.addSubview(self.tableView!)
        self.view.addSubview(header)
    }
    
    // Task 追加時のダイアログ
    var alertController : UIAlertController?
    
    // Task 追加時の View
    func showCreateView() {
        self.alertType = TaskAlertViewType.Create
        self.alertController = UIAlertController(title: "Task追加🐱", message: nil, preferredStyle: .Alert)
        self.alertController!.addTextFieldWithConfigurationHandler({ textField in
            textField.delegate = self
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertController?.addAction(okAction)
        
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
}

extension TaskTableViewController : UITextFieldDelegate {
    
    // textField への文字入力終了後の処理
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let type = self.alertType {
            println(type)
            
            switch type {
            case .Create:
                let task = Task(title: textField.text)
                if self.taskManager.create(task) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .Update(index):
                let task = Task(title: textField.text)
                if self.taskManager.update(task, at:index) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .Remove(index):
                break
            }
        }
        
        // alert を閉じる
        self.alertController!.dismissViewControllerAnimated(false, completion: nil)
        return true
    }
}

extension TaskTableViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskManager.size
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = TaskTableViewCell(style: .Default, reuseIdentifier: nil)
        cell.delegate = self
        cell.textLabel?.text = self.taskManager[indexPath.row].title
        cell.tag = indexPath.row
        
        return cell
    }
    
}

extension TaskTableViewController : TaskTableViewCellDelegate {
    func updateTask(index: Int) {
        self.alertType = TaskAlertViewType.Update(index)
        
        self.alertController = UIAlertController(title: "編集😺", message: nil, preferredStyle: .Alert)
        self.alertController!.addTextFieldWithConfigurationHandler({ textField in
            textField.text = self.taskManager[index].title
            textField.delegate = self
        })
        
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    func removeTask(index: Int) {
        self.alertType = TaskAlertViewType.Update(index)
        
        self.alertController = UIAlertController(title: "削除😹", message: nil, preferredStyle: .Alert)
        self.alertController!.addAction(UIAlertAction(title: "Delete", style: .Destructive) { action in
            self.taskManager.remove(index)
            self.tableView!.reloadData()
        })
        
        self.alertController!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
     
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
}


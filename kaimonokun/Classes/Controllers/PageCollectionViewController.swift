//
//  PageCollectionViewController.swift
//  kaimonokun
//
//  Created by umeneri on 2015/05/07.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation
import UIKit

// ページ配列
struct Pages {
    var viewControllers:[UIViewController] = []
}

class PageCollectionViewController: UICollectionViewController {
    
    var pages:Pages = Pages(){
        didSet { self.collectionView?.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "PageCollectionViewCell")
        
        // ダミーページ追加
        let page1 = TaskTableViewController()
        self.pages.viewControllers.append(page1)
        
        let page2 = UIViewController()
        page2.view.backgroundColor = UIColor.blueColor()
        self.pages.viewControllers.append(page2)
    }
    
    // MARK: - UICollectionViewDelegate
    
    // ページ数取得
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.viewControllers.count
    }
    
    // 現在ページ返却
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("PageCollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        let view = self.pages.viewControllers[indexPath.row].view
        cell.contentView.addSubview(view)
        return cell
    }
    
    // サイズ返却
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var pageViewRect = self.view.bounds
        return CGSize(width: pageViewRect.width, height: pageViewRect.height)
    }
    
    // 線幅?
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    // ページ間距離
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
}
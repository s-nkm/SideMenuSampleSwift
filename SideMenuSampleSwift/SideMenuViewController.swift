//
//  SideMenuViewController.swift
//  SideMenuSampleSwift
//
//  Created by N on 2015/10/14.
//  Copyright (c) 2015年 Nakama. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController_SideMenu,UITableViewDelegate,UITableViewDataSource,SideMenuDelegate {
    
    var tableView:UITableView?
    var titleCell:[String] = ["コンテンツ","設定","ヘルプ"]
    //var imageCell:[String] = ["home_icon","setting_icon","help_icon"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView = UITableView(frame:
            CGRectMake(0,
            (self.view.frame.size.height - 54*3)/2,
            self.view.frame.size.width,
            54*3))
        tableView!.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleWidth
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.backgroundColor = UIColor.clearColor()
        tableView!.backgroundView = nil
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView!)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            var  viewController = UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("firstViewController") as! UIViewController)
            self.sideMenuViewController!.setContentViewController(viewController, animated: true)
            self.sideMenuViewController?.hideMenuViewController()
        case 1:
            var  viewController = UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("secondViewController") as! UIViewController)
            self.sideMenuViewController!.setContentViewController(viewController, animated: true)
            self.sideMenuViewController?.hideMenuViewController()
        default:
            break
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.selectedBackgroundView = UIView()
            cell!.textLabel!.textColor = UIColor.whiteColor()
            cell!.textLabel!.font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
        }
        cell?.textLabel?.text = titleCell[indexPath.row]
        //cell?.imageView?.image = UIImage(named: imageCell[indexPath.row])
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

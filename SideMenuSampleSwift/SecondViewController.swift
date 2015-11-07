//
//  SecondViewController.swift
//  SideMenuSampleSwift
//
//  Created by N on 2015/10/14.
//  Copyright (c) 2015年 Nakama. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController_SideMenu {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲージョンバーアイコン設定
        let button:UIButton = UIButton(frame: CGRectMake(0, 0, 33, 33))
        button.setImage(UIImage(named: "menu_icon"), forState: UIControlState.Normal)
        button.addTarget(self, action: "onMenuButton:", forControlEvents: UIControlEvents.TouchUpInside)
        let buttonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = buttonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

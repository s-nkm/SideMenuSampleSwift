//
//  RootViewController.swift
//  SideMenuSampleSwift
//
//  Created by N on 2015/10/14.
//  Copyright (c) 2015年 Nakama. All rights reserved.
//

import UIKit

class RootViewController: SideMenu,SideMenuDelegate{
    
    override func awakeFromNib() {
        self.contentViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("contentViewController"))! as UIViewController
        self.menuViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("menuViewController"))! as UIViewController
        self.backGroundImage = UIImage(named: "background")
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func willShowMenuViewController(sideMenu: SideMenu, contentViewController: UIViewController) {
        print("willShowMenuViewController")
    }
    
    func didShowMenuViewController(sideMenu: SideMenu, contentViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    func willHideMenuViewController(sideMenu: SideMenu, contentViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    func didHideMenuViewController(sideMenu: SideMenu, contentViewController: UIViewController) {
        print("didHideMenuViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
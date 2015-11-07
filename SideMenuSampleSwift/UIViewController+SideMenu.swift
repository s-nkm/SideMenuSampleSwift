//
//  UIViewController+SideMenu.swift
//  SideMenuSampleSwift
//
//  Created by N on 2015/10/21.
//  Copyright (c) 2015年 Nakama. All rights reserved.
//

import UIKit

class UIViewController_SideMenu: UIViewController {
    
    var sideMenuViewController:SideMenu?{
        get{
            print("getter of SideMenu")
            var viewController = self.parentViewController
            while viewController != nil {
                if viewController!.isKindOfClass(SideMenu)
                {
                    return viewController as? SideMenu
                }else if viewController != nil &&
                    viewController?.parentViewController != viewController
                {
                    viewController = viewController?.parentViewController
                }else{
                    viewController = nil
                }
            }
            return nil
        }
    }
    
    @IBAction func onMenuButton(sender:AnyObject){
        self.sideMenuViewController!.presentMenuViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  SideMenu.swift
//  SideMenuSampleSwift
//
//  Created by N on 2015/10/14.
//  Copyright (c) 2015年 Nakama. All rights reserved.
//

import UIKit

@objc protocol SideMenuDelegate{
    optional func willShowMenuViewController(sideMenu:SideMenu,contentViewController:UIViewController)
    optional func didShowMenuViewController(sideMenu:SideMenu,contentViewController:UIViewController)
    optional func willHideMenuViewController(sideMenu:SideMenu,contentViewController:UIViewController)
    optional func didHideMenuViewController(sideMenu:SideMenu,contentViewController:UIViewController)
}

class SideMenu: UIViewController {
    
    //必須
    var contentViewController:UIViewController?
    var menuViewController:UIViewController?
    
    var contentViewContainer:UIView?
    var menuViewContainer:UIView?
    var backGroundImage:UIImage?
    var backGroundImageView:UIImageView?
    var contentButton:UIButton?
    
    weak var delegate:AnyObject?
    
    //画面遷移アニメーション設定
    //アニメーションの速さ
    var animationDuration:NSTimeInterval = 0.35
    //コンテントビューのサイズ変化
    var isScaleContentView:Bool = true
    var scaleContentViewValue:CGFloat = 0.7
    //メニュービューのサイズ変化
    var isScaleMenuView:Bool = true
    var menuViewControllerTransformation:CGAffineTransform = CGAffineTransformMakeScale(1.5, 1.5)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    func commonInit(){
        self.contentViewContainer = UIView()
        self.menuViewContainer = UIView()
    }
    
    //メニューコントローラ表示
    func presentMenuViewController(){
        self.showMenuViewController()
    }
    
    func showMenuViewController(){
        //メニュー表示開始を通知
        self.menuViewController!.beginAppearanceTransition(true, animated: true)
        //メニュー表示開始メソッドを通知
        if (self.delegate is SideMenuDelegate && self.delegate?.respondsToSelector("willShowMenuViewController:") != nil){
            self.delegate?.willShowMenuViewController!(self, contentViewController: self.menuViewController!)
        }
        //(メニューから戻る際の)コンテントビューのタッチボタンをビューに追加
        if self.contentButton?.superview == nil{
            self.contentButton?.frame = self.contentViewContainer!.bounds
            self.contentButton!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.contentViewContainer?.addSubview(self.contentButton!)
        }
        //アニメーション
        UIView.animateWithDuration(0.35,
            animations: {()->Void in
                if self.isScaleContentView{
                    //サイズ変化の場合
                    self.contentViewContainer!.transform = CGAffineTransformMakeScale(self.scaleContentViewValue, self.scaleContentViewValue)
                }else{
                    //サイズ変わらない場合
                    self.contentViewContainer!.transform = CGAffineTransformIdentity
                }
                self.contentViewContainer?.center = CGPointMake(CGRectGetWidth(self.view.frame),self.contentViewContainer!.center.y)
                self.menuViewContainer!.transform = CGAffineTransformIdentity
            },
            completion: {(Bool)->Void in
                //メニュー表示完了を通知
                self.menuViewController!.endAppearanceTransition()
                //メニュー表示完了メソッドを通知
                if (self.delegate is SideMenuDelegate && self.delegate?.respondsToSelector("didShowMenuViewController:") != nil){
                    self.delegate?.didShowMenuViewController!(self, contentViewController: self.menuViewController!)
                }
            }
        )
        self.menuViewContainer!.transform = CGAffineTransformIdentity
        self.menuViewContainer!.alpha = 1.0
    }
    
    //メニューコントローラー非表示
    func hideMenuViewController(){
        self.hideMenuViewControllerAnimated(true)
    }
    
    func hideMenuViewControllerAnimated(animated:Bool){
        //メニュー非表示開始を通知
        self.menuViewController!
            .beginAppearanceTransition(false, animated: animated)
        //メニュー非表示開始メソッドを通知
        if (self.delegate is SideMenuDelegate && self.delegate?.respondsToSelector("willHideMenuViewController:") != nil){
            self.delegate?.willHideMenuViewController!(self, contentViewController: self.menuViewController!)
        }
        //(メニューから戻る際の)コンテントビューのタッチボタンを外す
        self.contentButton?.removeFromSuperview()
        //アニメーションクロージャ
        let animationBlock: () -> () = {[weak self] in
            self!.contentViewContainer!.transform = CGAffineTransformIdentity
            self!.contentViewContainer!.frame = self!.view.bounds
            if self!.isScaleMenuView{
                self!.menuViewContainer?.transform = self!.menuViewControllerTransformation
            }
            self!.menuViewContainer!.alpha = 0
            self!.contentViewContainer!.alpha = 1
            
        }
        let completionBlock: () -> () = {[weak self] in
            //メニュー非表示完了を通知
            self?.menuViewController!.endAppearanceTransition()
            //メニュー非表示完了メソッドを通知
            if (self!.delegate is SideMenuDelegate && self!.delegate?.respondsToSelector("didHideMenuViewController:") != nil){
                self!.delegate?.didHideMenuViewController!(self!, contentViewController: self!.menuViewController!)
            }
        }
        if animated {
            // タッチイベント無効
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            UIView.animateWithDuration(self.animationDuration,
                animations: {()->Void in
                    animationBlock()
                },
                completion: {(Bool)->Void in
                    // タッチイベント有効
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    completionBlock()
                }
            )
        }
    }
    
    //その他共通処理
    func hideViewController(viewController:UIViewController){
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func setContentViewController(contentViewController:UIViewController,animated:Bool){
        if self.contentViewController == contentViewController{
            return
        }
        if animated {
            self.addChildViewController(contentViewController)
            contentViewController.view.alpha = 0
            contentViewController.view.frame = self.contentViewContainer!.bounds
            self.contentViewContainer?.addSubview(contentViewController.view)
            UIView.animateWithDuration(self.animationDuration,
                animations: {()->Void in
                    contentViewController.view.alpha = 1
                },
                completion: {(finished:Bool) -> Void in
                    self.hideViewController(self.contentViewController!)
                    contentViewController.didMoveToParentViewController(self)
                    self.contentViewController = contentViewController
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        //全体ビューの幅と高さを自動調整
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        //背景イメージビューの設定
        let imageView:UIImageView = UIImageView(frame: self.view.bounds)
        imageView.image = self.backGroundImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.backGroundImageView = imageView
        //(メニューから戻る際の)コンテントビューのタッチボタンを作成
        let button:UIButton = UIButton(frame: CGRectNull)
        button.addTarget(self, action: "hideMenuViewController", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentButton = button
        //コンテント・メニューコンテナ・背景イメージビューの追加
        self.view.addSubview(backGroundImageView!)
        self.view.addSubview(self.menuViewContainer!)
        self.view.addSubview(self.contentViewContainer!)
        //メニューコンテナの設定
        self.menuViewContainer?.frame = self.view.bounds
        self.menuViewContainer?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.addChildViewController(menuViewController!)
        self.menuViewController!.view.frame = self.view.bounds
        self.menuViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.menuViewContainer?.addSubview(self.menuViewController!.view)
        self.menuViewController!.didMoveToParentViewController(self)
        //コンテントコンテナの設定
        self.contentViewContainer?.frame = self.view.bounds
        self.contentViewContainer?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.addChildViewController(contentViewController!)
        self.contentViewController!.view.frame = self.view.bounds
        self.contentViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.contentViewContainer?.addSubview(self.contentViewController!.view)
        self.contentViewController!.didMoveToParentViewController(self)
        //画面遷移前の状態設定
        self.menuViewContainer?.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

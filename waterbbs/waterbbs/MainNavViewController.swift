//
//  MainNavViewController.swift
//  waterbbs
//
//  Created by y on 15/12/12.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MainNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //设置StatusBar为白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.nextResponder()!.touchesMoved(touches, withEvent: event)
    }
 
    

}

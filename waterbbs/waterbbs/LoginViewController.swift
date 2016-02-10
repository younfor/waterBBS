//
//  LoginViewController.swift
//  waterbbs
//
//  Created by y on 16/2/10.
//  Copyright © 2016年 younfor. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var username: UITextField!
  
  @IBOutlet weak var cancel: UIButton!
  @IBOutlet weak var password: UITextField!
  
  @IBAction func onCancel(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  // 登陆
  @IBAction func onLogin(sender: AnyObject) {
    if username.text != "" && password.text != "" {
      HttpTool.getHttpTool().login(username.text!, password: password.text!, onSuccess: { () -> Void in
        self.dismissViewControllerAnimated(true, completion: nil)
        }, onFail: nil)
    }
  }
  
  override func viewDidLoad() {
    setupKeyBoard()
  }
  // 键盘弹出
  func setupKeyBoard() {
    // 监听键盘弹出
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"onKeyBoard:" , name: UIKeyboardWillChangeFrameNotification, object: nil)
  }

  func onKeyBoard(note:NSNotification) {
    let durtion = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.floatValue
    let f = note.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
    if f?.origin.y == self.view.frame.height {
      // 没有弹出键盘
      UIView.animateWithDuration((NSTimeInterval)(durtion!), animations: {
        self.view!.transform = CGAffineTransformIdentity
      })
    } else {
      UIView.animateWithDuration((NSTimeInterval)(durtion!), animations: {                self.view!.transform = CGAffineTransformMakeTranslation(0, -f!.size.height + UIScreen.mainScreen().bounds.height - CGRectGetMaxY(self.cancel.frame) - 2);
      })
    }
  }

}

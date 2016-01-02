//
//  Extention+UITextView.swift
//  waterbbs
//
//  Created by y on 16/1/2.
//  Copyright © 2016年 younfor. All rights reserved.
//

import UIKit

extension UITextView {
  func heightForContent() -> CGFloat {
    let ver = UIDevice.currentDevice().systemVersion as NSString
    let verNum = ver.floatValue
    if verNum >= 7 {
      let textFrame = self.layoutManager.usedRectForTextContainer(self.textContainer)
      return textFrame.size.height
    } else {
      return self.heightForContent()
    }
  }
}

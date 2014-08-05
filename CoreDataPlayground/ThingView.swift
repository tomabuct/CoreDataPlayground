//
//  ThingView.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 7/31/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit

class ThingView : UIView {
  var title : String = "" {
  didSet { titleTextField.text = title }
  }

  var titleTextField = UITextField()

  convenience override init() {
    self.init(frame: CGRectNull)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor.whiteColor()

    titleTextField.backgroundColor = UIColor.redColor()
    addSubview(titleTextField)
  }

  convenience required init(coder aDecoder: NSCoder!) {
    self.init(frame: CGRectNull)
  }

  override func layoutSubviews() {
    titleTextField.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(bounds), height: 100)
  }
}
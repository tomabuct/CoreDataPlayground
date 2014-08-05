//
//  ThingAddView.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 7/31/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit

class ThingAddView: UIView {
  var titleTextField = UITextField()
  var otherThingTitleTextField = UITextField()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor.whiteColor()

    titleTextField.backgroundColor = UIColor.grayColor()
    addSubview(titleTextField)

    otherThingTitleTextField.backgroundColor = UIColor.grayColor()
    addSubview(otherThingTitleTextField)
  }

  convenience required init(coder aDecoder: NSCoder!) {
    self.init(frame: CGRectZero)
  }

  override func layoutSubviews() {
    var y : CGFloat = 17.5

    titleTextField.frame = CGRect(x: 0, y: y, width: CGRectGetWidth(bounds), height: 20)

    y += 40

    otherThingTitleTextField.frame = CGRect(x: 0, y: y, width: CGRectGetWidth(bounds), height: 20)
  }
}
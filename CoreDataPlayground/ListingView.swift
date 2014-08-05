//
//  ThingsView.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 8/3/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit

class ListingView : UIView {
  var thingsView : UIView
  var otherThingsView : UIView

  init(thingsView : UIView, otherThingsView : UIView) {
    self.thingsView = thingsView
    self.otherThingsView = otherThingsView

    super.init(frame: CGRectNull)

    addSubview(thingsView)
    addSubview(otherThingsView)

    installConstraints()
  }

  required init(coder aDecoder: NSCoder!) {
    fatalError("NSCoding not supported")
  }

  func installConstraints() {
    let views = [ "thingsView" : thingsView, "otherThingsView" : otherThingsView ]._bridgeToObjectiveC()

    thingsView.setTranslatesAutoresizingMaskIntoConstraints(false)
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[thingsView][otherThingsView(==thingsView)]|",
      options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[thingsView]|",
      options: NSLayoutFormatOptions(0), metrics: nil, views: views))

    otherThingsView.setTranslatesAutoresizingMaskIntoConstraints(false)
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[otherThingsView]|",
      options: NSLayoutFormatOptions(0), metrics: nil, views: views))
  }
}

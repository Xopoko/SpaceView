//
//  SpaceView.swift
//  SpaceView
//
//  Created by user on 25.12.16.
//  Copyright © 2016 horoko. All rights reserved.
//

import Foundation
import UIKit
import Foundation

public class SpaceView {
    
    private var mWindow: UIWindow?
    private var window: UIWindow?
    private var offsetX: CGFloat = 0.0
    private var offsetY: CGFloat = 0.0
    private var isTouched = false
    
    var spaceColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.90)
    var spaceDescription = ""
    var spaceTitle = ""
    var spaceHeight: CGFloat = 64
    var canHideByTap = true
    var tapAction: (() -> ())? = nil
    var spaceView: UIView?
    var spaceHideTimer = 2.0
    var spaceShowDuration = 0.3
    var spaceHideDuration = 0.25
    var spaceReturnDuration = 0.25
    var spaceHideDelay = 0.0
    var spaceShowDelay = 0.0
    var spaceReturnDelay = 0.0
    var possibleDirectionToHide = [HideDirection.left, HideDirection.right, HideDirection.top]
    var image: UIImage? = nil
    var titleView = UILabel()
    var descriptionView = UILabel()
    var titleColor = UIColor.white
    var descriptionColor = UIColor.white
    var titleFont = UIFont.systemFont(ofSize: 17)
    var descriptionFont = UIFont.systemFont(ofSize: 17)
    var shouldAutoHide = true
    var spaceStyle: SpaceStyles? = nil
    
    
    init (spaceOptions: [spaceOptions]?) {
        if let options = spaceOptions {
            setOptions(options: options)
        }
    }
    
    init (title: String, spaceOptions: [spaceOptions]?) {
        self.spaceTitle = title
        if let options = spaceOptions {
            setOptions(options: options)
        }
    }
    
    init (title: String, description: String, spaceOptions: [spaceOptions]?) {
        self.spaceTitle = title
        self.spaceDescription = description
        if let options = spaceOptions {
            setOptions(options: options)
        }
    }
    
    func show() {
        mWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: screenWidth, height: spaceHeight))
        mWindow?.windowLevel = UIWindowLevelStatusBar
        mWindow?.isHidden = false
        mWindow?.makeKeyAndVisible()
        mWindow?.windowLevel = (UIWindowLevelStatusBar + 1)
        if spaceView == nil {
            spaceView = makeContent()
        }
        mWindow?.addSubview(spaceView!)
        spaceView?.frame = CGRect(x: 0, y: 0 - spaceHeight, width: (mWindow?.frame.width)!, height: spaceHeight)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        spaceView?.addGestureRecognizer(tap)
        
        spaceView?.isUserInteractionEnabled = true
        
        self.animateShow()
        self.addHideGesture()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if self.tapAction != nil {
            self.tapAction!()
        } else {
            if self.canHideByTap {
                self.hideSpaceView(direction: .top)
            }
        }
    }
    
    func hideSpaceView(direction: HideDirection) {
        UIView.animate(withDuration: spaceHideDuration, delay: spaceHideDelay, options: .curveEaseOut, animations: ({
            switch direction {
            case .left:
                self.spaceView?.x = -(self.spaceView?.w)!
                break
            case .right:
                self.spaceView?.x = (self.spaceView?.w)!
                break
            case .top:
                self.spaceView?.y = 0 - self.spaceHeight
                break
            }
        }), completion: ({ some in
            self.removeWindow()
        }))
    }
    
    private func setOptions(options: [spaceOptions]) {
        for option in options {
            switch (option) {
            case let .spaceColor(color): spaceColor = color
            case let .spaceDescription(text): spaceDescription = text
            case let .spaceTitle(text) : spaceTitle = text
            case let .spaceHeight(height) : spaceHeight = height
            case let .spaceHideTimer(timer) : spaceHideTimer = timer
            case let .customView(view) : spaceView = view
            case let .tapAction(action) : tapAction = action
            case let .spaceShowDuration(duration) : spaceShowDuration = duration
            case let .spaceHideDuration(duration) : spaceHideDuration = duration
            case let .spaceReturnDuration(duration) : spaceReturnDuration = duration
            case let .spaceHideDelay(delay) : spaceHideDelay = delay
            case let .spaceShowDelay(delay) : spaceShowDelay = delay
            case let .spaceReturnDelay(delay) : spaceReturnDelay = delay
            case let .possibleDirectionToHide(directions) : possibleDirectionToHide = directions
            case let .image(img) : image = img
            case let .titleView(view) : titleView = view
            case let .descriptionView(view) : descriptionView = view
            case let .titleColor(color) : titleColor = color
            case let .descriptionColor(color) : descriptionColor = color
            case let .titleFont(font) : titleFont = font
            case let .descriptionFont(font) : descriptionFont = font
            case let .shouldAutoHide(should) : shouldAutoHide = should
            case let .spaceStyle(style) : spaceStyle = style
                
                
            }
        }
    }
    
    private func animateShow() {
        UIView.animate(withDuration: spaceShowDuration, delay: spaceShowDelay, options: .curveEaseOut, animations: ({
            self.spaceView?.y = 0
        }), completion: ({ a in
            self.startTimer()
        }))
    }
    
    private func returnView() {
        UIView.animate(withDuration: spaceReturnDuration, delay: spaceReturnDelay, options: .curveEaseOut, animations: ({
            self.spaceView?.x = 0
            self.spaceView?.y = 0
        }), completion: ({ a in
            self.offsetX = 0
            self.offsetY = 0
            self.startTimer()
        }))
    }
    
    private func startTimer() {
        runThisAfterDelay(seconds: shouldAutoHide && !self.isTouched ? self.spaceHideTimer : Double(INT32_MAX)) { () -> () in
            self.hideSpaceView(direction: .top)
        }
    }
    
    private func removeWindow() {
        mWindow?.windowLevel = (UIWindowLevelStatusBar - 1)
        mWindow?.removeFromSuperview()
        mWindow = nil
        spaceView = nil
        image = nil
        tapAction = nil
    }
    
    private func addHideGesture() {
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handleHideGesture(_:)))
        self.spaceView?.addGestureRecognizer(tap)
    }
    
    @objc func handleHideGesture(_ gesture: UIPanGestureRecognizer) {
        if let spaceView = spaceView {
            switch (gesture.state) {
            case .ended, .cancelled, .possible:
                self.isTouched = false
                
                self.offsetX = spaceView.frame.x
                self.offsetY = spaceView.frame.y
                
                if spaceView.frame.x < -(spaceView.w / 4) || (spaceView.frame.x > spaceView.w / 4) {
                    self.hideSpaceView(direction: spaceView.frame.x > 0 ? .right : .left)
                    break
                } else {
                    self.returnView()
                }
                
                if (self.offsetY < -(spaceView.h / 4)) {
                    self.hideSpaceView(direction: .top)
                } else {
                    self.returnView()
                }
            case.changed:
                self.isTouched = true
                for direction in self.possibleDirectionToHide {
                    switch direction {
                    case .left:
                        if gesture.velocity(in: spaceView).x < 0 {
                            if gesture.translation(in: spaceView).x != 0 {
                                if spaceView.frame.y == 0 {
                                    spaceView.frame.x = gesture.translation(in: spaceView).x + self.offsetX
                                }
                            }
                        }
                        break
                    case .right:
                        if spaceView.frame.x > 0 || gesture.velocity(in: spaceView).x > 0 {
                            if gesture.translation(in: spaceView).x != 0 {
                                if spaceView.frame.y == 0 {
                                    spaceView.frame.x = gesture.translation(in: spaceView).x + self.offsetX
                                }
                            }
                        }
                        break
                    case .top:
                        if gesture.velocity(in: spaceView).y < 0 {
                            if gesture.translation(in: spaceView).x == 0 {
                                if spaceView.frame.x == 0 {
                                    if gesture.translation(in: spaceView).y <= 0 {
                                        spaceView.frame.y = gesture.translation(in: spaceView).y + self.offsetY
                                    }
                                }
                            }
                        }
                        break
                    }
                }
                break
            case .began:
                self.isTouched = true
            default:
                break
            }
        }
    }
    
    private func makeContent() -> UIView {
        let contentView = UIView()
        if spaceStyle != nil {
            switch spaceStyle! {
            case .success:
                contentView.backgroundColor = UIColor(red: 27.0/255.0, green: 94.0/255.0, blue: 32.0/255.0, alpha: 0.90)
            case .error:
                contentView.backgroundColor = UIColor(red: 183.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 0.90)
            case .warning:
                contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 127.0/255.0, blue: 23.0/255.0, alpha: 0.90)
            }
        } else {
            contentView.backgroundColor = spaceColor
        }
        
        var imageView: UIImageView? = nil
        
        if image != nil {
            imageView = UIImageView()
            imageView!.image = image
            contentView.addSubview(imageView!)
            imageView!.translatesAutoresizingMaskIntoConstraints = false

            let imageCenterY = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            let imageLeading = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8)
            let imageHeight = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35)
            let imageWidth = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35)
            contentView.addConstraints([imageCenterY, imageLeading, imageHeight, imageWidth])
        }
        
        let titleView = UILabel()
        titleView.text = spaceTitle
        titleView.textColor = .white
        titleView.textAlignment = .center
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleCenterY = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        var titleLeading = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let titleTrailing = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        if let imgView = imageView {
            titleLeading = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8)
        }
        
        if !spaceDescription.isEmpty {
            descriptionView.text = spaceDescription
            descriptionView.textColor = .white
            descriptionView.lineBreakMode = .byTruncatingTail
            descriptionView.numberOfLines = 2
            descriptionView.textAlignment = .center
            contentView.addSubview(descriptionView)
            
            descriptionView.translatesAutoresizingMaskIntoConstraints = false
            let titleTop = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 8)

            let descrTop = NSLayoutConstraint(item: descriptionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: titleView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8)
            let descBot = NSLayoutConstraint(item: descriptionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -8)
            var descLeading = NSLayoutConstraint(item: descriptionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8)
            let descTrailing = NSLayoutConstraint(item: descriptionView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -8)
            if let imgView = imageView {
                descLeading = NSLayoutConstraint(item: descriptionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8)
            }
            contentView.addConstraints([titleTop, titleLeading, titleTrailing, descrTop, descBot, descLeading, descTrailing])
            
        } else {
            contentView.addConstraints([ titleCenterY, titleLeading, titleTrailing])
        }
    
        return contentView
    }
    
    
    /// EZSE: Returns current screen orientation
    var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    /// EZSE: Returns screen width
    var screenWidth: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    private func runThisAfterDelay(seconds: Double, after: @escaping () -> ()) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }
    
    private func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
}

public enum HideDirection {
    case right
    case left
    case top
}

public enum SpaceStyles {
    case success
    case error
    case warning
}

public enum spaceOptions {
    case spaceColor(color: UIColor)
    case spaceDescription(text: String)
    case spaceTitle(text: String)
    case spaceHeight(height: CGFloat)
    case spaceHideTimer(timer: Double)
    case customView(view: UIView)
    case tapAction(() -> ())
    case spaceShowDuration(duration: Double)
    case spaceHideDuration(duration: Double)
    case spaceReturnDuration(duration: Double)
    case spaceHideDelay(delay: Double)
    case spaceShowDelay(delay: Double)
    case spaceReturnDelay(delay: Double)
    case possibleDirectionToHide([HideDirection])
    case image(img: UIImage?)
    case titleView(view: UILabel)
    case descriptionView(view: UILabel)
    case titleColor(color: UIColor)
    case descriptionColor(color: UIColor)
    case titleFont(font: UIFont)
    case descriptionFont(font: UIFont)
    case shouldAutoHide(should: Bool)
    case spaceStyle(style: SpaceStyles?)
    
    
}

extension UIView {
    fileprivate var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    fileprivate var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    fileprivate var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    fileprivate var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }
}

extension CGRect {
    
    fileprivate var x: CGFloat {
        get {
            return self.origin.x
        } set(value) {
            self.origin.x = value
        }
    }
    
    fileprivate var y: CGFloat {
        get {
            return self.origin.y
        } set(value) {
            self.origin.y = value
        }
    }
    
    fileprivate var w: CGFloat {
        get {
            return self.size.width
        } set(value) {
            self.size.width = value
        }
    }
    
    fileprivate var h: CGFloat {
        get {
            return self.size.height
        } set(value) {
            self.size.height = value
        }
    }
}


extension UIViewController {
    public func showSpace(spaceOptions: [spaceOptions]?) {
        let m = SpaceView(spaceOptions: nil)
        m.show()
    }
    public func showSpace(title: String, spaceOptions: [spaceOptions]?) {
        let m = SpaceView(title: title, spaceOptions: spaceOptions)
        m.show()
    }
    public func showSpace(title: String, description: String, spaceOptions: [spaceOptions]?) {
        let m = SpaceView(title: title, description: description, spaceOptions: spaceOptions)
        m.show()
    }
}

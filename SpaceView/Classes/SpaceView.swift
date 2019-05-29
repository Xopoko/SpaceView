//
//  SpaceView.swift
//  SpaceView
//
//  Created by user on 25.12.16.
//  Copyright © 2016 horoko. All rights reserved.
//

import UIKit

public class SpaceView {
    var spaceColor: UIColor = UIColor(white: 0, alpha: 0.9)
    var spaceDescription = ""
    var spaceTitle = ""
    var spaceHeight: CGFloat = UIDevice.current.hasNotch ? 88 : 64
    var canHideByTap = true
    var tapAction: (() -> Void)?
    var swipeAction: (() -> Void)?
    var buttonAction: (() -> Void)?
    var spaceView: UIView?
    var spaceHideTimer = 2.0
    var spaceShowDuration = 0.3
    var spaceHideDuration = 0.25
    var spaceReturnDuration = 0.25
    var spaceHideDelay = 0.0
    var spaceShowDelay = 0.0
    var spaceReturnDelay = 0.0
    var possibleDirectionToHide: [HideDirection] = [.left, .right, .top, .bot]
    var image: UIImage?
    var titleView = UILabel()
    var descriptionView = UILabel()
    var titleColor = UIColor.white
    var descriptionColor = UIColor.white
    var titleFont = UIFont.systemFont(ofSize: 17)
    var descriptionFont = UIFont.systemFont(ofSize: 17)
    var shouldAutoHide = true
    var spaceStyle: SpaceStyles?
    var spacePosition: SpacePosition = .top
    
    private var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    private var screenWidth: CGFloat {
        if UIInterfaceOrientation.portrait == screenOrientation {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    private var screenHeight: CGFloat {
        if UIInterfaceOrientation.portrait == screenOrientation {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }
    }
    
    private var topInset: CGFloat {
        if #available(iOS 11.0, *) {
            return spaceWindow?.safeAreaInsets.top ?? 44
        } else {
            return 0
        }
    }
    
    private var spaceWindow: UIWindow?
    private var offsetX: CGFloat = 0.0
    private var offsetY: CGFloat = 0.0
    private var offsetAlpha: CGFloat = 0.0
    private var isTouched = false
    private var canRemoveWindow = true
    
    init(spaceOptions: [SpaceOptions]?) {
        if let options = spaceOptions {
            setOptions(options: options)
        }
    }
    
    init(title: String, spaceOptions: [SpaceOptions]?) {
        spaceTitle = title
        if let options = spaceOptions {
            setOptions(options: options)
        }
    }
    
    init(title: String, description: String, spaceOptions: [SpaceOptions]?) {
        spaceTitle = title
        spaceDescription = description
        if let options = spaceOptions {
            setOptions(options: options)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func show() {
        var windowFrame = CGRect(x: 0, y: 0, width: screenWidth, height: spaceHeight)
        var spaceFrame = CGRect(x: 0, y: 0 - spaceHeight, width: screenWidth, height: spaceHeight)
        if spacePosition == .bot {
            windowFrame = CGRect(x: 0, y: screenHeight - spaceHeight, width: screenWidth, height: spaceHeight)
            spaceFrame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: spaceHeight)
        }
        spaceWindow = UIWindow(frame: windowFrame)
        spaceWindow?.windowLevel = UIWindow.Level.statusBar
        spaceWindow?.isHidden = false
        spaceWindow?.makeKeyAndVisible()
        spaceWindow?.windowLevel = (UIWindow.Level.statusBar + 1)
        if spaceView == nil {
            spaceView = makeContent()
        }
        spaceWindow?.addSubview(spaceView!)
        spaceView?.frame = spaceFrame
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        spaceView?.addGestureRecognizer(tap)
        spaceView?.isUserInteractionEnabled = true
        
        animateShow()
        addHideGesture()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        tapAction?()
        if canHideByTap {
            hideSpaceView(direction: .top, isManualy: true)
        }
    }

    @objc func handleHideGesture(_ gesture: UIPanGestureRecognizer) {
        guard let spaceView = spaceView else { return }
        switch (gesture.state) {
        case .ended, .cancelled, .possible:
            isTouched = false
            offsetX = spaceView.frame.origin.x
            offsetY = spaceView.frame.origin.y
            let translation = gesture.translation(in: spaceView)
            switch true {
            case translation.x > screenWidth / 4:
                hideSpaceView(direction: .right, isManualy: false)
                swipeAction?()
            case translation.x < -(screenWidth / 4):
                hideSpaceView(direction: .left, isManualy: false)
                swipeAction?()
            case spacePosition == .top ? translation.y > spaceView.h : translation.y < -(spaceView.h / 3):
                hideSpaceView(direction: spacePosition == .bot ? .top : .bot, isManualy: false)
                swipeAction?()
            case spacePosition == .top ? translation.y < -(spaceView.h / 3) : translation.y > spaceView.h / 3:
                hideSpaceView(direction: spacePosition == .top ? .top : .bot, isManualy: false)
                swipeAction?()
            default:
                returnView()
            }
        case.changed:
            self.isTouched = true
            let velocity = gesture.velocity(in: spaceView)
            let translation = gesture.translation(in: spaceView)
            if abs(velocity.x) > abs(velocity.y) && spaceView.frame.origin.y == 0 {
                for direction in possibleDirectionToHide {
                    switch direction {
                    case .left:
                        if translation.x <= 0 {
                            spaceView.frame.origin.x = translation.x
                            spaceView.alpha = 1.00 + ((gesture.translation(in: spaceView).x) / 200)
                        } else {
                            if possibleDirectionToHide.contains(.right) {
                                break
                            } else {
                                spaceView.frame.origin.x = 0
                            }
                        }
                    case .right:
                        if translation.x >= 0 {
                            spaceView.frame.origin.x = translation.x
                            spaceView.alpha = 1.00 - ((gesture.translation(in: spaceView).x) / 200)
                        } else {
                            if possibleDirectionToHide.contains(.left) {
                                break
                            } else {
                                spaceView.frame.origin.x = 0
                            }
                        }
                    default:
                        break
                    }
                }
            }
            if abs(velocity.y) > abs(velocity.x) && spaceView.frame.origin.x == 0 {
                for direction in possibleDirectionToHide {
                    switch direction {
                    case .top:
                        if translation.y <= 0 {
                            spaceView.frame.origin.y = translation.y
                            spaceView.alpha = 1.00 + ((gesture.translation(in: spaceView).y) / 100)
                        } else {
                            if possibleDirectionToHide.contains(.bot) {
                                break
                            } else {
                                spaceView.frame.origin.y = 0
                            }
                        }
                    case .bot:
                        if translation.y >= 0 {
                            spaceView.frame.origin.y = translation.y
                            spaceView.alpha = 1.00 - ((gesture.translation(in: spaceView).y) / 100)
                        } else {
                            if possibleDirectionToHide.contains(.top) {
                                break
                            } else {
                                spaceView.frame.origin.y = 0
                            }
                        }
                    default:
                        break
                    }
                }
            }
            break
        case .began:
            self.isTouched = true
        default:
            break
        }
    }
    
    private func hideSpaceView(direction: HideDirection, isManualy: Bool) {
        UIView.animate(withDuration: spaceHideDuration, delay: spaceHideDelay, options: .curveEaseOut, animations: ({
            guard let spaceView = self.spaceView else { return }
            switch direction {
                case .left:
                    if self.possibleDirectionToHide.contains(.left) {
                        spaceView.x = -spaceView.w
                        spaceView.alpha = 0
                        self.canRemoveWindow = true
                        break
                    }
                    self.canRemoveWindow = false
                case .right:
                    if self.possibleDirectionToHide.contains(.right) {
                        spaceView.x = spaceView.w
                        spaceView.alpha = 0
                        self.canRemoveWindow = true
                        break
                    }
                    self.canRemoveWindow = false
                case .top:
                    if self.possibleDirectionToHide.contains(.top) || isManualy {
                        spaceView.y = self.offsetY - self.spaceHeight
                        spaceView.alpha = 0
                        self.canRemoveWindow = true
                        break
                    }
                    self.canRemoveWindow = false
                case .bot:
                    if self.possibleDirectionToHide.contains(.bot) || isManualy {
                        spaceView.frame.origin.y = self.offsetY + self.spaceHeight
                        spaceView.alpha = 0
                        self.canRemoveWindow = true
                        break
                    }
                    self.canRemoveWindow = false
            }
        }), completion: ({ a in
            if self.canRemoveWindow {
                self.removeWindow()
            }
            self.canRemoveWindow = true
        }))
    }
    
    private func setOptions(options: [SpaceOptions]) {
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
            case let .spacePosition(position) : spacePosition = position
            case let .swipeAction(action) : swipeAction = action
            case let .buttonAction(action) : buttonAction = action
            }
        }
    }
    
    private func animateShow() {
        UIView.animate(withDuration: spaceShowDuration, delay: spaceShowDelay, options: .curveEaseOut, animations: ({
            self.spaceView?.y = 0
        }), completion: ({ _ in
            self.startTimer()
        }))
    }
    
    private func returnView() {
        UIView.animate(withDuration: spaceReturnDuration, delay: spaceReturnDelay, options: .curveEaseOut, animations: ({
            self.spaceView?.x = 0
            self.spaceView?.y = 0
            self.spaceView?.alpha = 1.0
        }), completion: ({ _ in
            self.offsetX = 0
            self.offsetY = 0
            self.startTimer()
        }))
    }
    
    private func startTimer() {
        runThisAfterDelay(seconds: shouldAutoHide && !self.isTouched ? self.spaceHideTimer : Double(INT32_MAX)) { () -> () in
            self.hideSpaceView(direction: self.spacePosition == .top ? .top : .bot, isManualy: true)
        }
    }
    
    private func removeWindow() {
        spaceWindow?.windowLevel = (UIWindow.Level.statusBar - 1)
        spaceWindow?.removeFromSuperview()
        spaceWindow = nil
        spaceView = nil
        image = nil
        tapAction = nil
    }
    
    private func addHideGesture() {
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handleHideGesture(_:)))
        self.spaceView?.addGestureRecognizer(tap)
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

            let imageCenterY = NSLayoutConstraint(item: imageView!,
                                                  attribute: NSLayoutConstraint.Attribute.centerY,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: contentView,
                                                  attribute: NSLayoutConstraint.Attribute.centerY,
                                                  multiplier: 1,
                                                  constant: 0)
            let imageLeading = NSLayoutConstraint(item: imageView!,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: contentView,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  multiplier: 1,
                                                  constant: 8)
            let imageHeight = NSLayoutConstraint(item: imageView!,
                                                 attribute: NSLayoutConstraint.Attribute.height,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 35)
            let imageWidth = NSLayoutConstraint(item: imageView!,
                                                attribute: NSLayoutConstraint.Attribute.width,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                multiplier: 1,
                                                constant: 35)
            contentView.addConstraints([imageCenterY, imageLeading, imageHeight, imageWidth])
        }
        
        titleView.text = spaceTitle
        titleView.textColor = .white
        titleView.numberOfLines = 2
        titleView.textAlignment = .center
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleCenterY = NSLayoutConstraint(item: titleView,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: contentView,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              multiplier: 1,
                                              constant: 0)
        var titleLeading = NSLayoutConstraint(item: titleView,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: contentView,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1,
                                              constant: 16)
        let titleTrailing = NSLayoutConstraint(item: titleView,
                                               attribute: NSLayoutConstraint.Attribute.trailing,
                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                               toItem: contentView,
                                               attribute: NSLayoutConstraint.Attribute.trailing,
                                               multiplier: 1,
                                               constant: -16)
        
        if let imgView = imageView {
            titleLeading = NSLayoutConstraint(item: titleView,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: imgView,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1,
                                              constant: 8)
        }
        
        if !spaceDescription.isEmpty {
            descriptionView.text = spaceDescription
            descriptionView.textColor = .white
            descriptionView.lineBreakMode = .byTruncatingTail
            descriptionView.numberOfLines = 2
            descriptionView.textAlignment = .center
            contentView.addSubview(descriptionView)
            
            descriptionView.translatesAutoresizingMaskIntoConstraints = false
            let titleTop = NSLayoutConstraint(item: titleView,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: contentView,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              multiplier: 1,
                                              constant: UIDevice.current.hasNotch ? topInset - 8 : 8)

            let descrTop = NSLayoutConstraint(item: descriptionView,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                              toItem: titleView,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              multiplier: 1,
                                              constant: 8)
            let descBot = NSLayoutConstraint(item: descriptionView,
                                             attribute: NSLayoutConstraint.Attribute.bottom,
                                             relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                             toItem: contentView,
                                             attribute: NSLayoutConstraint.Attribute.bottom,
                                             multiplier: 1,
                                             constant: -8)
            var descLeading = NSLayoutConstraint(item: descriptionView,
                                                 attribute: NSLayoutConstraint.Attribute.leading,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: contentView,
                                                 attribute: NSLayoutConstraint.Attribute.leading,
                                                 multiplier: 1,
                                                 constant: 16)
            let descTrailing = NSLayoutConstraint(item: descriptionView,
                                                  attribute: NSLayoutConstraint.Attribute.trailing,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: contentView,
                                                  attribute: NSLayoutConstraint.Attribute.trailing,
                                                  multiplier: 1,
                                                  constant: -16)
            if let imgView = imageView {
                descLeading = NSLayoutConstraint(item: descriptionView,
                                                 attribute: NSLayoutConstraint.Attribute.leading,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: imgView,
                                                 attribute: NSLayoutConstraint.Attribute.trailing,
                                                 multiplier: 1,
                                                 constant: 16)
            }
            contentView.addConstraints([titleTop, titleLeading, titleTrailing, descrTop, descBot, descLeading, descTrailing])
        } else {
            contentView.addConstraints([titleCenterY, titleLeading, titleTrailing])
        }
    
        return contentView
    }
    
    private func runThisAfterDelay(seconds: Double, after: @escaping () -> ()) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: after)
    }
}

public enum HideDirection {
    case right
    case left
    case top
    case bot
}

public enum SpacePosition {
    case top
    case bot
}

public enum SpaceStyles {
    case success
    case error
    case warning
}

public enum SpaceOptions {
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
    case spacePosition(position: SpacePosition)
    case swipeAction(() -> ())
    case buttonAction(() -> ())
}

internal extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame = CGRect(x: newValue, y: y, width: w, height: h)
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame = CGRect(x: x, y: newValue, width: w, height: h)
        }
    }
    
    var w: CGFloat {
        get {
            return frame.size.width
        } set {
            frame = CGRect(x: x, y: y, width: newValue, height: h)
        }
    }
    
    var h: CGFloat {
        get {
            return frame.size.height
        } set {
            frame = CGRect(x: x, y: y, width: w, height: newValue)
        }
    }
}

public extension UIViewController {
    func showSpace(spaceOptions: [SpaceOptions]?) {
        SpaceView(spaceOptions: nil).show()
    }
    
    func showSpace(title: String, spaceOptions: [SpaceOptions]?) {
        SpaceView(title: title, spaceOptions: spaceOptions).show()
    }
    
    func showSpace(title: String, description: String, spaceOptions: [SpaceOptions]?) {
        SpaceView(title: title, description: description, spaceOptions: spaceOptions).show()
    }
}

internal extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
        } else {
            return false
        }
    }
}

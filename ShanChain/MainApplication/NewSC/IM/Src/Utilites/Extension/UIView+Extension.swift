//
//  UIView+Extension.swift
//  YLDatePicker
//
//  Created by yl on 2017/11/15.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

//UIView+Extension

struct RuntimeKey {
    static let zm_playgroundKey = UnsafeRawPointer.init(bitPattern: "zm_playgroundKey".hashValue)
    static let zm_animatorKey = UnsafeRawPointer.init(bitPattern: "zm_animatorKey".hashValue)
    static let zm_snapBehavior = UnsafeRawPointer.init(bitPattern: "zm_snapBehaviorKey".hashValue)
    static let zm_attachmentBehavior = UnsafeRawPointer.init(bitPattern: "zm_attachmentBehaviorKey".hashValue)
    static let zm_panGesture = UnsafeRawPointer.init(bitPattern: "zm_panGestureKey".hashValue)
    static let zm_centerPoint = UnsafeRawPointer.init(bitPattern: "zm_centerPointKey".hashValue)
    static let zm_damping = UnsafeRawPointer.init(bitPattern: "zm_dampingKey".hashValue)
}


// MARK: - 约束拓展
extension UIView {
    /*----------------------------添加约束----------------------------*/
    
    /// 添加约束 -> edgeInsets
    func addLayoutConstraints(toItem: Any,edgeInsets: UIEdgeInsets) {
        addLayoutConstraints(attributes: [.top,.bottom,.left,.right], toItem: toItem, attributes: nil, constants:[edgeInsets.top,edgeInsets.bottom,edgeInsets.left,edgeInsets.right])
        
    }
    /// 添加约束 -> [attr1]丶toItem丶[attr2]丶constant
    func addLayoutConstraints(attributes attr1s: [NSLayoutAttribute],
                              toItem: Any?,
                              attributes attr2s: [NSLayoutAttribute]?,
                              constant: CGFloat) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? nil:attr2s![i]
            addLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        }
    }
    /// 添加约束 -> [attr1]丶toItem丶[attr2]丶[constant]
    func addLayoutConstraints(attributes attr1s: [NSLayoutAttribute],
                              toItem: Any?,
                              attributes attr2s: [NSLayoutAttribute]?,
                              constants: [CGFloat]) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? nil:attr2s![i]
            let constant = constants[i]
            addLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2, constant: constant)
        }
    }
    /// 添加约束 -> attr1丶toItem丶attr2丶constant
    func addLayoutConstraint(attribute attr1: NSLayoutAttribute,
                             toItem: Any?,
                             attribute attr2: NSLayoutAttribute?,
                             constant: CGFloat) {
        addLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
    }
    /// 添加约束 -> attr1丶relatedBy丶toItem丶attr2丶multiplier丶constant
    func addLayoutConstraint(attribute attr1: NSLayoutAttribute,
                             relatedBy relation: NSLayoutRelation,
                             toItem: Any?,
                             attribute attr2: NSLayoutAttribute?,
                             multiplier: CGFloat,
                             constant: CGFloat) {
        
        var toItem = toItem
        var attr2 = attr2 ?? attr1
        
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        if attr1 == .width || attr1 == .height {
            toItem = nil
            attr2 = .notAnAttribute
        }
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /*----------------------------修改约束----------------------------*/
    
    /// 修改约束 -> edgeInsets
    func updateLayoutConstraints(toItem: Any,edgeInsets: UIEdgeInsets) {
        updateLayoutConstraints(attributes: [.top,.bottom,.left,.right], toItem: toItem, attributes: nil, constants:[edgeInsets.top,edgeInsets.bottom,edgeInsets.left,edgeInsets.right])
        
    }
    /// 修改约束 -> [attr1]丶toItem丶[attr2]丶constant
    func updateLayoutConstraints(attributes attr1s: [NSLayoutAttribute],
                                 toItem: Any?,
                                 attributes attr2s: [NSLayoutAttribute]?,
                                 constant: CGFloat) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            updateLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        }
    }
    /// 修改约束 -> [attr1]丶toItem丶[attr2]丶[constant]
    func updateLayoutConstraints(attributes attr1s: [NSLayoutAttribute],
                                 toItem: Any?,
                                 attributes attr2s: [NSLayoutAttribute]?,
                                 constants: [CGFloat]) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            let constant = constants[i]
            updateLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2, constant: constant)
        }
    }
    /// 修改约束 -> attr1丶toItem丶attr2丶constant
    func updateLayoutConstraint(attribute attr1: NSLayoutAttribute,
                                toItem: Any?,
                                attribute attr2: NSLayoutAttribute?,
                                constant: CGFloat) {
        updateLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
    }
    /// 修改约束 -> attr1丶relatedBy丶toItem丶attr2丶multiplier丶constant
    func updateLayoutConstraint(attribute attr1: NSLayoutAttribute,
                                relatedBy relation: NSLayoutRelation,
                                toItem: Any?,
                                attribute attr2: NSLayoutAttribute?,
                                multiplier: CGFloat,
                                constant: CGFloat) {
        
        removeLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2)
        
        addLayoutConstraint(attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
    }
    
    /*----------------------------删除约束----------------------------*/
    
    /// 删除约束 -> [attr1]丶toItem丶[attr2]
    func removeLayoutConstraints(attributes attr1s: [NSLayoutAttribute],
                                 toItem: Any?,
                                 attributes attr2s: [NSLayoutAttribute]?) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? nil:attr2s![i]
            removeLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2)
        }
    }
    /// 删除约束 -> attr1丶toItem丶attr2
    func removeLayoutConstraint(attribute attr1: NSLayoutAttribute,
                                toItem: Any?,
                                attribute attr2: NSLayoutAttribute?) {
        
        let attr2 = attr2 ?? attr1
        
        if attr1 == .width  || attr1 == .height {
            for constraint in constraints {
                if constraint.firstItem?.isEqual(self) == true &&
                    constraint.firstAttribute == attr1 {
                    NSLayoutConstraint.deactivate([constraint])
                }
            }
            
        }else if let superview = self.superview {
            for constraint in superview.constraints {
                if constraint.firstItem?.isEqual(self) == true &&
                    constraint.firstAttribute == attr1 &&
                    constraint.secondItem?.isEqual(toItem) == true &&
                    constraint.secondAttribute == attr2 {
                    NSLayoutConstraint.deactivate([constraint])
                }
            }
        }
    }
}

extension UIView {
    func signleDragable() -> Void {
        signleDraggableInView(view: self.superview, damping: CGFloat(0.4))
    }
    
    func signleDraggableInView(view: UIView!, damping: CGFloat) -> Void {
        if (view) != nil {
            removeAllDraggable()
            zm_playground = view
            zm_damping = damping
            signleAnimator()
            signleAddPanGesture()
        }
    }
    
    private func removeAllDraggable() -> Void {
        if (zm_panGesture) != nil {
            self.removeGestureRecognizer(zm_panGesture!)
        }
        zm_panGesture = nil
        zm_playground = nil
        zm_animator = nil
        zm_snapBehavior = nil
        zm_attachmentBehavior = nil
        zm_centerPoint = CGPoint.zero
    }
    
    private func signleAnimator() -> Void {
        zm_animator = UIDynamicAnimator.init(referenceView: zm_playground!)
        signleUpdateSnapPoint()
    }
    
    private func signleUpdateSnapPoint() -> Void {
        zm_centerPoint = self.convert(CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2), to: zm_playground!)
        zm_snapBehavior = UISnapBehavior.init(item: self, snapTo: zm_centerPoint!)
        zm_snapBehavior?.damping = zm_damping!
    }
    
    private func signleAddPanGesture() -> Void {
        zm_panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(signlePanGesture(pan:)))
        self.addGestureRecognizer(zm_panGesture!)
    }
    
    @objc func signlePanGesture(pan: UIPanGestureRecognizer) -> Void {
        let panLocation = pan.location(in: zm_playground)
        if pan.state == .began {
            signleUpdateSnapPoint()
            let offSet = UIOffsetMake(panLocation.x - (zm_centerPoint?.x)!, panLocation.y - (zm_centerPoint?.y)!)
            zm_animator?.removeAllBehaviors()
            zm_attachmentBehavior = UIAttachmentBehavior.init(item: self, offsetFromCenter: offSet, attachedToAnchor: panLocation)
            zm_animator?.addBehavior(zm_attachmentBehavior!)
        } else if pan.state == .changed {
            zm_attachmentBehavior?.anchorPoint = panLocation
        } else if (pan.state == .ended) || (pan.state == .cancelled) || (pan.state == .failed) {
            zm_animator?.addBehavior(zm_snapBehavior!)
            zm_animator?.removeBehavior(zm_attachmentBehavior!)
        }
    }
    
    private var zm_playground: UIView? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_playgroundKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_playgroundKey!) as? UIView
        }
    }
    
    private var zm_animator: UIDynamicAnimator? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_animatorKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_animatorKey!) as? UIDynamicAnimator
        }
    }
    
    private var zm_snapBehavior: UISnapBehavior? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_snapBehavior!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_snapBehavior!) as? UISnapBehavior
        }
    }
    
    private var zm_attachmentBehavior: UIAttachmentBehavior? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_attachmentBehavior!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_attachmentBehavior!) as? UIAttachmentBehavior
        }
    }
    
    private var zm_panGesture: UIPanGestureRecognizer? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_panGesture!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_panGesture!) as? UIPanGestureRecognizer
        }
    }
    
    private var zm_centerPoint: CGPoint? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_centerPoint!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_centerPoint!) as? CGPoint
        }
    }
    
    private var zm_damping: CGFloat? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_damping!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_damping!) as? CGFloat
        }
    }
}


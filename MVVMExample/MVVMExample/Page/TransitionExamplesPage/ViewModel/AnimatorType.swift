//
//  TransitionType.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/3/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import RxCocoa
import RxSwift

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

class BasicAnimation : CABasicAnimation, CAAnimationDelegate {
    public var onFinish : (() -> (Void))?
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let onFinish = onFinish {
            onFinish()
        }
    }
}


/*
/// Overidde animateTransition and Implement Animation
///
*/

class FlipAnimator: Animator {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let duration = transitionDuration(using: transitionContext)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        if isPresenting {
            delay(0) { // don't know why, iOS bug?
                UIView.transition(from: fromVC.view, to: toVC.view, duration: duration, options: [.transitionFlipFromRight, .showHideTransitionViews]) { _ in
                    transitionContext.completeTransition(true)
                }
            }
        } else {
            UIView.transition(from: fromVC.view, to: toVC.view, duration: duration, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
}

class ZoomAnimator: Animator {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        
        let size = containerView.frame.size
        
        let zoomView = UIView(frame: CGRect(x: 0, y: 0, width: 2 * size.width, height: size.height))
        containerView.addSubview(zoomView)
        zoomView.addSubview(fromVC.view)
        zoomView.addSubview(toVC.view)
        
        if isPresenting {
            toVC.view.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            
            UIView.animate(withDuration: 0.8) {
                fromVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                toVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.7, options: .beginFromCurrentState, animations: {
                zoomView.transform = CGAffineTransform(translationX: -2 * fromVC.view.frame.width, y: 0)
            })
            
            UIView.animate(withDuration: 0.8, delay: 1.2, options: .beginFromCurrentState, animations: {
                fromVC.view.transform = .identity
                toVC.view.transform = .identity
            }) { _ in
                toVC.view.frame = containerView.bounds
                containerView.addSubview(toVC.view)
                zoomView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        } else {
            fromVC.view.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            zoomView.transform = CGAffineTransform(translationX: -size.width, y: 0)
            
            UIView.animate(withDuration: 0.8) {
                fromVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                toVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }

            UIView.animate(withDuration: 0.5, delay: 0.7, options: .beginFromCurrentState, animations: {
                zoomView.transform = .identity
            })

            UIView.animate(withDuration: 0.8, delay: 1.2, options: .beginFromCurrentState, animations: {
                fromVC.view.transform = .identity
                toVC.view.transform = .identity
            }) { _ in
                toVC.view.frame = containerView.bounds
                containerView.addSubview(toVC.view)
                zoomView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}

class ClockAnimator: Animator {
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let radius = 2 * sqrt(pow(fromVC.view.bounds.size.height / 2, 2) + pow(fromVC.view.bounds.size.width / 2, 2))
        let circleCenter = CGPoint(x: radius ,y: radius)
        
        let circleFromToAngle : ((Double) -> (CGPath)) = { endAngle in
            let path = UIBezierPath()
            path.move(to: circleCenter)
            path.addLine(to: circleCenter)
            path.addArc(withCenter: circleCenter, radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(endAngle), clockwise: true)
            
            return path.cgPath
        }
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: radius, height: radius)
        shapeLayer.position = CGPoint(x: (fromVC.view.frame.size.width / 2) - (radius / 2), y: (fromVC.view.frame.size.height / 2) - (radius / 2))
        shapeLayer.path = circleFromToAngle(2.0 * Double.pi)
        
        fromVC.view.layer.mask = shapeLayer
        
        let cleanup : (() -> (Void)) = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
            fromVC.view.removeFromSuperview()
        }
        
        let runAnimationToPathWithCompletion : ((CGPath, CGPath, @escaping () -> (Void)) -> (Void)) = { pathStart, pathEnd, completion in
            let animation : BasicAnimation = BasicAnimation()
            animation.keyPath = "path"
            animation.duration = 0.5 / 4
            animation.fromValue = pathStart
            animation.toValue = pathEnd
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.autoreverses = false
            animation.onFinish = {
                completion()
            }
            shapeLayer.add(animation, forKey: "path")
        }
        
        runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 2.0), circleFromToAngle(Double.pi * 1.50001), {
            runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 1.5), circleFromToAngle(Double.pi * 1.00001), {
                runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 1.0), circleFromToAngle(Double.pi * 0.50001), {
                    runAnimationToPathWithCompletion(circleFromToAngle(Double.pi * 0.5), circleFromToAngle(Double.pi * 0.0001), {
                        cleanup()
                    })
                })
            })
        })
    }
}

public class CircleAnimator: Animator {
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let radius = sqrt(pow(fromVC.view.bounds.size.height / 2, 2) + pow(fromVC.view.bounds.size.width / 2, 2))
        let circlePathStart = UIBezierPath(arcCenter: CGPoint(x: fromVC.view.bounds.size.width / 2,y: fromVC.view.bounds.size.height / 2), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePathEnd = UIBezierPath(arcCenter: CGPoint(x: fromVC.view.bounds.size.width / 2,y: fromVC.view.bounds.size.height / 2), radius: CGFloat(1), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = circlePathStart.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        shapeLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        fromVC.view.layer.mask = shapeLayer
        
        let animation : BasicAnimation = BasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.5
        animation.fromValue = circlePathStart.cgPath
        animation.toValue = circlePathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
}

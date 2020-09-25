//
//  AnimatorTypes.swift
//  Action
//
//  Created by pham.minh.tien on 9/25/20.
//

import Foundation
import RxCocoa
import RxSwift

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

public class BasicAnimation : CABasicAnimation, CAAnimationDelegate {
    public var onFinish : (() -> (Void))?
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let onFinish = onFinish {
            onFinish()
        }
    }
}

/*
/// Overidde animateTransition and Implement Animation
///
*/

public class FlipAnimator: Animator {
    
    override public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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

public class ZoomAnimator: Animator {
    
    override public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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

public class ClockAnimator: Animator {
    
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
            animation.duration = CFTimeInterval(self.duration / 4)
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
        animation.duration = self.duration
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

public class CrossFadeAnimator: Animator {
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        fromVC.view.alpha = 1.0
        toVC.view.alpha = 0.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.duration, animations: {
            fromVC.view.alpha = 0.0
            toVC.view.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.alpha = 1.0
        }
    }
}

public class RectanglerAnimator: Animator {
    var rectangleGrowthDistance : CGFloat = 60
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        func createRectOutlinePath(_ outerRect: CGRect, completion: (() -> (Void))? = nil) -> CAShapeLayer? {
            let magnitude = (self.rectangleGrowthDistance * 0.2)
            if (self.rectangleGrowthDistance >= outerRect.size.width
                || self.rectangleGrowthDistance >= outerRect.size.height) {
                return nil
            }
            let innerRect = RectanglerAnimator.rectMovedIn(outerRect, magnitude: magnitude)
            if (self.rectangleGrowthDistance >= innerRect.size.width
                || self.rectangleGrowthDistance >= innerRect.size.height) {
                return nil
            }
            
            let path = UIBezierPath(rect: outerRect)
            path.append(UIBezierPath(rect: innerRect))
            path.usesEvenOddFillRule = true
            
            let finalPath = UIBezierPath(rect: outerRect)
            finalPath.append(UIBezierPath(rect: RectanglerAnimator.rectMovedIn(innerRect, magnitude: self.rectangleGrowthDistance)))
            finalPath.usesEvenOddFillRule = true
            
            let runAnimationToPathWithCompletion : ((CGPath, CAShapeLayer, (() -> (Void))?) -> (Void)) = { pathEnd, layer, completion in
                let animation : BasicAnimation = BasicAnimation()
                animation.keyPath = "path"
                animation.duration = self.duration
                animation.fromValue = pathEnd
                animation.toValue = path.cgPath
                animation.autoreverses = false
                animation.isRemovedOnCompletion = false
                animation.onFinish = {
                    if let completion = completion {
                        completion()
                    }
                }
                layer.add(animation, forKey: "path")
            }
            
            let shapeLayer = CAShapeLayer.init()
            shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: outerRect.size.width, height: outerRect.size.height)
            shapeLayer.position = CGPoint(x: outerRect.size.width / 2, y: outerRect.size.height / 2)
            shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
            shapeLayer.path = path.cgPath
            
            runAnimationToPathWithCompletion(finalPath.cgPath, shapeLayer, completion);
            
            return shapeLayer
        }
        
        let cleanup : (() -> (Void)) = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.alpha = 1
            fromVC.view.layer.mask = nil
        }
        
        let maskLayer = CALayer.init()
        maskLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        maskLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        for i in (0..<8) {
            let magnitude = CGFloat(i) * self.rectangleGrowthDistance
            if magnitude <= fromVC.view.bounds.width && magnitude <= fromVC.view.bounds.height {
                let startRect = RectanglerAnimator.rectMovedIn(fromVC.view.bounds, magnitude: magnitude)
                if let sublayer = createRectOutlinePath(startRect, completion: nil) {
                    maskLayer.addSublayer(sublayer)
                }
            }
        }
        
        fromVC.view.layer.mask = maskLayer
        
        UIView.animate(withDuration: self.duration) {
            fromVC.view.alpha = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.duration), execute: {
            cleanup()
        })
    }
}

public class MultiCircleAnimator: Animator {
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let cleanup = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.removeFromSuperview()
            fromVC.view.layer.mask = nil
        }
        
        
        let createRectOutlinePath : ((CGPoint, CGSize, CGFloat, (() -> (Void))?) -> (CAShapeLayer)) = { circleCenter, circleSize, circleRadius, completion in
            let pathStart = UIBezierPath()
            pathStart.addArc(withCenter: circleCenter, radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            let pathEnd = UIBezierPath()
            pathEnd.addArc(withCenter: circleCenter, radius: circleSize.width, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
            let rect = CGRect.init(x: circleCenter.x - (circleSize.width / 2), y: circleCenter.y - (circleSize.height / 2), width: circleSize.width, height: circleSize.height)
            
            let shapeLayer = CAShapeLayer.init()
            shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
            shapeLayer.position = CGPoint(x: (rect.origin.x + rect.size.width) - (circleSize.width / 2), y: (rect.origin.y + rect.size.height) - (circleSize.height / 2))
            shapeLayer.path = pathStart.cgPath
            
            let animation : BasicAnimation = BasicAnimation()
            animation.keyPath = "path"
            animation.duration = self.duration
            animation.fromValue = pathEnd.cgPath
            animation.toValue = pathStart.cgPath
            animation.autoreverses = false
            animation.onFinish = {
                if let completion = completion {
                    completion()
                }
            }
            shapeLayer.add(animation, forKey: "path")
            
            return shapeLayer
        }
        
        guard let view = fromVC.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        let maskLayer = CALayer.init()
        maskLayer.bounds = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        maskLayer.position = CGPoint(x: (view.frame.size.width / 2), y: (view.frame.size.height / 2))
        
        let circleSize = CGSize(width: 20, height: 20)
        for rowIndex in (0..<Int(1 + ceilf(Float(view.bounds.size.height / circleSize.height)))) {
            for colIndex in (0..<Int(2 + ceilf(Float(view.bounds.size.width / circleSize.width)))) {
                let circleCenter = CGPoint(x: (circleSize.width / 2) + (CGFloat(colIndex) * circleSize.width), y: (circleSize.height / 2) + (CGFloat(rowIndex) * circleSize.height))
                
                maskLayer.addSublayer(createRectOutlinePath(circleCenter, circleSize, 1, rowIndex == 0 && colIndex == 0 ? cleanup : nil))
            }
        }
        
        fromVC.view.layer.mask = maskLayer
    }
}


public class TiledFlipAnimator: Animator {
    private func flipSegment(toViewImage: UIImage, fromViewImage: UIImage, delay: TimeInterval, rect: CGRect, animationTime: CGFloat, parentView: UIView) {
        guard let cgToImage = toViewImage.cgImage,
            let cgFromImage = fromViewImage.cgImage,
            let toImageRef = cgToImage.cropping(to: CGRect(x: toViewImage.scale * rect.origin.x, y: toViewImage.scale * rect.origin.y,width: toViewImage.scale * rect.size.width, height: toViewImage.scale * rect.size.height)),
            let fromImageRef = cgFromImage.cropping(to: CGRect(x: fromViewImage.scale * rect.origin.x, y: fromViewImage.scale * rect.origin.y,width: fromViewImage.scale * rect.size.width, height: fromViewImage.scale * rect.size.height)) else {
            return
        }
        
        let toImage = UIImage.init(cgImage: toImageRef)
        let toImageView = UIImageView()
        toImageView.clipsToBounds = true
        toImageView.frame = rect
        toImageView.image = toImage
        
        let fromImage = UIImage.init(cgImage: fromImageRef)
        let fromImageView = UIImageView()
        fromImageView.clipsToBounds = true
        fromImageView.frame = rect
        fromImageView.image = fromImage
        
        let containerView = UIView()
        containerView.frame = fromImageView.frame
        containerView.backgroundColor = UIColor.clear
        
        fromImageView.frame.origin = CGPoint.zero
        toImageView.frame.origin = CGPoint.zero
        
        containerView.addSubview(fromImageView)
        parentView.addSubview(containerView)
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .curveEaseInOut]
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: containerView, duration: TimeInterval(animationTime), options: transitionOptions, animations: {
                containerView.addSubview(toImageView)
                fromImageView.removeFromSuperview()
            })
        })
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshotToVc = snapshot(toVC.view),
            let snapshotFromVc = snapshot(fromVC.view)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        fromVC.view.removeFromSuperview()
        
        let parentView = UIView()
        parentView.backgroundColor = UIColor.clear
        parentView.frame = fromVC.view.frame
        containerView.addSubview(parentView)
        
        let cleanup = {
            containerView.addSubview(toVC.view)
            parentView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let squareSizeWidth : CGFloat = fromVC.view.bounds.size.width / 5
        let squareSizeHeight : CGFloat = fromVC.view.bounds.size.height / 10
        
        let numRows = 1 + Int(toVC.view.bounds.size.width / squareSizeWidth)
        let numCols = 1 + Int(toVC.view.bounds.size.height / squareSizeWidth)
        for x in (0...numRows) {
            for y in (0...numCols) {
                let rect = CGRect(x: (CGFloat(x) * squareSizeWidth),y: (CGFloat(y) * squareSizeHeight), width:squareSizeWidth, height: squareSizeHeight)
                
                let randomPercent = Float(arc4random()) / Float(UINT32_MAX)
                let delay = TimeInterval(Float(self.duration * 0.5) * randomPercent)
                
                flipSegment(toViewImage: snapshotToVc, fromViewImage: snapshotFromVc, delay: delay, rect: rect, animationTime: CGFloat(self.duration / 2), parentView: parentView)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.duration), execute: {
            cleanup()
        })
    }
}

public class ImageRepeatingAnimator: Animator {
    var imageStepPercent : CGFloat = 0.05
    var imageViews : [UIImageView] = []
    
    override public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let numberOfImageViews = Int(0.5 / imageStepPercent)
        return (self.duration / 10)  * TimeInterval(numberOfImageViews * 2)
    }
    
    private func removeImageView(transitionContext: UIViewControllerContextTransitioning) {
        let imageView = imageViews.first
        imageView?.removeFromSuperview()
        self.imageViews = Array(imageViews.dropFirst())
        
        if imageViews.count ==  0 {
            transitionContext.completeTransition(true)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (self.duration / 10), execute: { [weak self] in
            self?.removeImageView(transitionContext: transitionContext)
        })
    }
    
    private func addImageView(transitionContext: UIViewControllerContextTransitioning, fromViewImage: UIImage, imageViewRect: CGRect) {
        let imageView = UIImageView.init(frame: imageViewRect)
        imageView.clipsToBounds = true
        imageView.image = fromViewImage
        transitionContext.containerView.addSubview(imageView)
        imageViews.append(imageView)
        
        let widthStep = transitionContext.containerView.bounds.size.width * imageStepPercent
        let heightStep = transitionContext.containerView.bounds.size.height * imageStepPercent
        
        if (imageViewRect.size.width - (widthStep * 2) <= 0 || imageViewRect.size.height - (heightStep * 2) <= 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + (self.duration / 10), execute: { [weak self] in
                self?.removeImageView(transitionContext: transitionContext)
            })
            return
        }
        
        let nextImageViewRect = CGRect.init(x: imageViewRect.origin.x + widthStep, y: imageViewRect.origin.y + heightStep, width: imageViewRect.size.width - (widthStep * 2), height: imageViewRect.size.height - (heightStep * 2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (self.duration / 10), execute: { [weak self] in
            if let self = self {
                self.addImageView(transitionContext: transitionContext, fromViewImage: fromViewImage, imageViewRect: nextImageViewRect)
            }
        })
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromViewControllerImage = snapshot(fromVC.view)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        addImageView(transitionContext: transitionContext, fromViewImage: fromViewControllerImage, imageViewRect: containerView.bounds)
    }
}


public class MultiFlipRetroAnimator: Animator {
    var stepDistance : CGFloat = 0.333
    private var fromContainer: UIView?
    
    private func flipTo(transitionContext: UIViewControllerContextTransitioning, view: UIView, scale: CGFloat) {
        var transform = view.layer.transform
        view.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        transform = CATransform3DRotate(transform, CGFloat(Double.pi), 0.0, 1.0, 0.0)
        transform = CATransform3DScale(transform, scale, scale, 1.0)
        
        let nextScale = scale - stepDistance
        
        UIView.animate(withDuration: self.duration / 3, delay: 0.0, options: [.curveEaseInOut], animations: {
            view.layer.transform = transform
        }) { [weak self] (_) in
            if nextScale > 0 {
                self?.flipTo(transitionContext: transitionContext, view: view, scale: nextScale)
            } else {
                transitionContext.completeTransition(true)
                view.layer.transform = CATransform3DIdentity
                if let fromContainer = self?.fromContainer {
                    fromContainer.removeFromSuperview()
                }
            }
        }
    }
    
    override public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        fromContainer = UIView()
        fromContainer?.frame = fromVC.view.bounds
        containerView.addSubview(fromContainer!)
        
        fromContainer?.addSubview(fromVC.view)
        
        flipTo(transitionContext: transitionContext, view: fromVC.view, scale: 1.0 - stepDistance)
    }
}

public class AngleLineAnimator: Animator {
    var cornerToSlideFrom : UIRectCorner = .topLeft
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let size: CGSize = fromVC.view.frame.size
        
        let toPath = UIBezierPath()
        let fromPath = UIBezierPath()
        
        if (cornerToSlideFrom == .topRight) {
            toPath.move(to: CGPoint.init(x: -size.width, y: 0))
            toPath.addLine(to: CGPoint.init(x: size.width, y: size.height * 2))
            toPath.addLine(to: CGPoint.init(x: -size.width, y: size.height * 2))
            toPath.close()
            
            fromPath.move(to: CGPoint.init(x: 0, y: -size.height))
            fromPath.addLine(to: CGPoint.init(x: size.width * 2, y: size.height))
            fromPath.addLine(to: CGPoint.init(x: 0, y: size.height))
            fromPath.close()
        } else if (cornerToSlideFrom == .bottomLeft) {
            toPath.move(to: CGPoint.init(x: size.width * 2, y: size.height))
            toPath.addLine(to: CGPoint.init(x: 0, y: -size.height))
            toPath.addLine(to: CGPoint.init(x: size.width * 2, y: -size.height))
            toPath.close()
            
            fromPath.move(to: CGPoint.init(x: size.width, y: size.height * 2))
            fromPath.addLine(to: CGPoint.init(x: -size.width, y: 0))
            fromPath.addLine(to: CGPoint.init(x: size.width, y: 0))
            fromPath.close()
        } else if (cornerToSlideFrom == .bottomRight) {
            toPath.move(to: CGPoint.init(x: -size.width, y: size.height))
            toPath.addLine(to: CGPoint.init(x: size.width, y: -size.height))
            toPath.addLine(to: CGPoint.init(x: -size.width, y: -size.height))
            toPath.close()
            
            fromPath.move(to: CGPoint.init(x: 0, y: size.height * 2))
            fromPath.addLine(to: CGPoint.init(x: size.width * 2, y: 0))
            fromPath.addLine(to: CGPoint.zero)
            fromPath.close()
        } else if (cornerToSlideFrom == .topLeft) {
            toPath.move(to: CGPoint.init(x: size.width * 2, y: size.height))
            toPath.addLine(to: CGPoint.init(x: 0, y: size.height * 2))
            toPath.addLine(to: CGPoint.init(x: size.width * 2, y: size.height * 2))
            toPath.close()
            
            fromPath.move(to: CGPoint.init(x: size.width, y: size.height * -2))
            fromPath.addLine(to: CGPoint.init(x: -size.width, y: size.height))
            fromPath.addLine(to: CGPoint.init(x: size.width, y: size.height))
            fromPath.close()
        }
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = fromPath.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        shapeLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        fromVC.view.layer.mask = shapeLayer
        
        let animation : BasicAnimation = BasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = fromPath.cgPath
        animation.toValue = toPath.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
}

public class StraightLineAnimator: Animator {
    var sideToSlideFrom : UIRectEdge = .left
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let size: CGSize = fromVC.view.frame.size
        
        var toPath = UIBezierPath()
        let fromPath = UIBezierPath(rect: fromVC.view.bounds)
        
        if (sideToSlideFrom == .top) {
            toPath = UIBezierPath(rect: CGRect.init(x: 0, y: size.height, width: size.width, height: 0))
        } else if (sideToSlideFrom == .left) {
            toPath = UIBezierPath(rect: CGRect.init(x: size.width, y: 0, width: size.width, height: size.height))
        } else if (sideToSlideFrom == .right) {
            toPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: 0, height: size.height))
        } else if (sideToSlideFrom == .bottom) {
            toPath = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: size.width, height: 0))
        }
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = fromPath.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        shapeLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        fromVC.view.layer.mask = shapeLayer
        
        let animation : BasicAnimation = BasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = fromPath.cgPath
        animation.toValue = toPath.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
}


public class CollidingDiamondsAnimator: Animator {
    
    enum CollidingDiamondsOrientation {
        case vertical
        case horizontal
    }
    
    var orientation : CollidingDiamondsOrientation = .horizontal

    internal func animatedDiamondPath(startCenter: CGPoint, endCenter : CGPoint, size: CGSize, screenBounds: CGRect, completion: (() -> (Void))?) -> CALayer {
        let pathStart = UIBezierPath()
        pathStart.move(to: CGPoint.init(x: startCenter.x - (size.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (size.height / 2)))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x + (size.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (size.height / 2)))
        
        let pathEnd = UIBezierPath()
        pathEnd.move(to: CGPoint.init(x: endCenter.x - (size.width / 2), y: endCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x, y: endCenter.y - (size.height / 2)))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x + (size.width / 2), y: endCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x, y: endCenter.y + (size.height / 2)))
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = pathStart.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        shapeLayer.position = CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height / 2)
        
        let animation : BasicAnimation = BasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = pathStart.cgPath
        animation.toValue = pathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            if let completion = completion {
                completion()
            }
        }
        shapeLayer.add(animation, forKey: "path")
        
        return shapeLayer
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let diamondSize = CGSize.init(width: fromVC.view.bounds.size.width * 2, height: fromVC.view.bounds.size.height * 2)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        
        let containerLayer = CALayer.init()
        containerLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        containerLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toVC.view.layer.mask = nil
        }
        
        if (orientation == .vertical) {
            var start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: diamondSize.height / -2)
            var layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y + diamondSize.height), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
            containerLayer.addSublayer(layer)
            
            start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: (diamondSize.height * 0.5) + fromVC.view.bounds.height)
            layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y - diamondSize.height), size: diamondSize, screenBounds: fromVC.view.bounds, completion: completion)
            containerLayer.addSublayer(layer)
        } else {
            var start = CGPoint.init(x: diamondSize.width / -2, y: fromVC.view.bounds.height / 2)
            var layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x + diamondSize.width, y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
            containerLayer.addSublayer(layer)
            
            start = CGPoint.init(x: fromVC.view.bounds.width + (diamondSize.width * 0.5), y: fromVC.view.bounds.height / 2)
            layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x - diamondSize.width, y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: completion)
            containerLayer.addSublayer(layer)
        }
        
        
        
        toVC.view.layer.mask = containerLayer
    }
}


public class ShrinkingGrowingDiamondsAnimator: Animator {
    
    private func animatedDiamondPath(startCenter: CGPoint, startSize: CGSize, endSizeLarge: CGSize, endSizeSmall: CGSize, screenBounds: CGRect, completion: (() -> (Void))?) -> CALayer {
        let pathStart = UIBezierPath()
        pathStart.move(to: CGPoint.init(x: startCenter.x - (startSize.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (startSize.height / 2)))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x + (startSize.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (startSize.height / 2)))
        
        let pathStart2 = UIBezierPath()
        pathStart2.move(to: CGPoint.init(x: startCenter.x - (startSize.width / 2), y: startCenter.y))
        pathStart2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (startSize.height / 2)))
        pathStart2.addLine(to: CGPoint.init(x: startCenter.x + (startSize.width / 2), y: startCenter.y))
        pathStart2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (startSize.height / 2)))
        pathStart.append(pathStart2)
        
        pathStart.usesEvenOddFillRule = true
        
        let pathEnd = UIBezierPath()
        pathEnd.move(to: CGPoint.init(x: startCenter.x - (endSizeLarge.width / 2), y: startCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (endSizeLarge.height / 2)))
        pathEnd.addLine(to: CGPoint.init(x: startCenter.x + (endSizeLarge.width / 2), y: startCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (endSizeLarge.height / 2)))
        
        let pathEnd2 = UIBezierPath()
        pathEnd2.move(to: CGPoint.init(x: startCenter.x - (endSizeSmall.width / 2), y: startCenter.y))
        pathEnd2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (endSizeSmall.height / 2)))
        pathEnd2.addLine(to: CGPoint.init(x: startCenter.x + (endSizeSmall.width / 2), y: startCenter.y))
        pathEnd2.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (endSizeSmall.height / 2)))
        pathEnd.append(pathEnd2)
        
        pathEnd.usesEvenOddFillRule = true
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = pathStart.cgPath
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        shapeLayer.position = CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height / 2)
        
        let animation : BasicAnimation = BasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = pathStart.cgPath
        animation.toValue = pathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            if let completion = completion {
                completion()
            }
        }
        shapeLayer.add(animation, forKey: "path")
        
        return shapeLayer
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let diamondSize = fromVC.view.bounds.size
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        
        let containerLayer = CALayer.init()
        containerLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        containerLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toVC.view.layer.mask = nil
        }
        
        let start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: diamondSize.height / 2)
        
        let layer = animatedDiamondPath(startCenter: start, startSize: diamondSize, endSizeLarge: CGSize.init(width: diamondSize.width * 2, height: diamondSize.height * 2), endSizeSmall: CGSize.init(width: 1, height: 1), screenBounds: fromVC.view.bounds, completion: completion)
        containerLayer.addSublayer(layer)
        
        toVC.view.layer.mask = containerLayer
    }
}

public class SplitFromCenterAnimator: Animator {
    
    internal func animatedDiamondPath(startCenter: CGPoint, endCenter : CGPoint, size: CGSize, screenBounds: CGRect, completion: (() -> (Void))?) -> CALayer {
        let pathStart = UIBezierPath()
        pathStart.move(to: CGPoint.init(x: startCenter.x - (size.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y - (size.height / 2)))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x + (size.width / 2), y: startCenter.y))
        pathStart.addLine(to: CGPoint.init(x: startCenter.x, y: startCenter.y + (size.height / 2)))
        
        let pathEnd = UIBezierPath()
        pathEnd.move(to: CGPoint.init(x: endCenter.x - (size.width / 2), y: endCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x, y: endCenter.y - (size.height / 2)))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x + (size.width / 2), y: endCenter.y))
        pathEnd.addLine(to: CGPoint.init(x: endCenter.x, y: endCenter.y + (size.height / 2)))
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = pathStart.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        shapeLayer.position = CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height / 2)
        
        let animation : BasicAnimation = BasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = self.duration
        animation.fromValue = pathStart.cgPath
        animation.toValue = pathEnd.cgPath
        animation.autoreverses = false
        animation.onFinish = {
            if let completion = completion {
                completion()
            }
        }
        shapeLayer.add(animation, forKey: "path")
        
        return shapeLayer
    }
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let diamondSize = CGSize.init(width: fromVC.view.bounds.size.width * 2, height: fromVC.view.bounds.size.height * 2)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        
        let containerLayer = CALayer.init()
        containerLayer.bounds = CGRect.init(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
        containerLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)
        
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.layer.mask = nil
        }
        
        var start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: (fromVC.view.bounds.height / 2) - (diamondSize.height / 2))
        var layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y - (diamondSize.height / 2)), size: diamondSize, screenBounds: fromVC.view.bounds, completion: completion)
        containerLayer.addSublayer(layer)
        
        start = CGPoint.init(x: fromVC.view.bounds.width / 2, y: (fromVC.view.bounds.height / 2) + (diamondSize.height / 2))
        layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x, y: start.y + (diamondSize.height / 2)), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
        containerLayer.addSublayer(layer)
        
        start = CGPoint.init(x: (fromVC.view.bounds.width / 2) + (diamondSize.width / 2), y: fromVC.view.bounds.height / 2)
        layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x + (diamondSize.width / 2), y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
        containerLayer.addSublayer(layer)
        
        start = CGPoint.init(x: (fromVC.view.bounds.width / 2) - (diamondSize.width / 2), y: fromVC.view.bounds.height / 2)
        layer = animatedDiamondPath(startCenter: start, endCenter: CGPoint.init(x: start.x - (diamondSize.width / 2), y: start.y), size: diamondSize, screenBounds: fromVC.view.bounds, completion: nil)
        containerLayer.addSublayer(layer)
        
        fromVC.view.layer.mask = containerLayer
    }
}

public class SwingInAnimator: Animator {
    enum InitialDirection {
        case left
        case right
    }
    var initialDirection : InitialDirection = .left
    
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        
        let toContainerView = UIView()
        toContainerView.backgroundColor = UIColor.clear
        toContainerView.frame = toVC.view.bounds
        toContainerView.frame.origin = CGPoint.init(x: initialDirection == .left ? -fromVC.view.bounds.width : fromVC.view.bounds.width * 2, y: 0)
        
        toContainerView.addSubview(toVC.view)
        containerView.addSubview(toContainerView)
        
        toVC.view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        
        UIView.animate(withDuration: self.duration, delay: 0.0, options: [.curveEaseOut], animations: {
            toVC.view.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
            toContainerView.frame = fromVC.view.bounds
        }, completion: nil)
    }
}

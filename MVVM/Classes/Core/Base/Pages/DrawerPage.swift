//
//  DrawerPage.swift
//  MVVM
//

import UIKit
import RxSwift
import Action

class OverlayView: AbstractControlView {
    public let tapGesture = UITapGestureRecognizer()

    override func setupView() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        addGestureRecognizer(tapGesture)
    }

    static func addToPage(_ page: UIViewController) -> OverlayView {
        let overlayView = OverlayView()
        page.view.addSubview(overlayView)
        overlayView.autoPinEdgesToSuperviewEdges()
        
        return overlayView
    }
}

public enum DrawerLayout {
    case under, over
}

public enum DrawerAnimation {
    case slide, slideAndZoom

    var duration: TimeInterval {
        switch self {
        case .slide:
            return 0.25

        case .slideAndZoom:
            return 0.3
        }
    }
}

public enum DrawerWidth {
    /// Fix drawer width
    case fix(CGFloat)
    /// Drawer width ratio compare to screen width
    case ratio(CGFloat)
}

/// A navigation drawer page
// swiftlint:disable type_body_length
public class DrawerPage: UIViewController, IDestroyable {
    public private(set) var detailPage: UIViewController?
    public private(set) var mainPage: UIViewController?
    private let mainContentView = UIView()
    private let detailContentView = UIView()
    private let overlayView = OverlayView()
    private lazy var tapAction: Action<Void, Void> = {
        return Action { .just(self.closeDrawer(true)) }
    }()

    public override var prefersStatusBarHidden: Bool {
        if isOpen {
            return mainPage?.prefersStatusBarHidden ?? false
        }
        return detailPage?.prefersStatusBarHidden ?? false
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if isOpen {
            return mainPage?.preferredStatusBarStyle ?? .default
        }
        return detailPage?.preferredStatusBarStyle ?? .default
    }
    
    private var widthConstraint: NSLayoutConstraint?
    /// Public properties for configurations
    public private(set) var isOpen = false
    /// Allow drawer to open or not
    public var isEnabled = true
    /*
     Drawer widths:
     - fix: set a fix width for drawer. For under layout, this should be the visible area
     - ratio: set a ratio width compare to screen width
     */
    public var drawerWidth: DrawerWidth = .fix(280) {
        didSet { updateDrawerWidth() }
    }
    /*
     Drawer animations:
     - slide: slide from left (can be different with drawer layout)
     - slideAndZoom: better with under layout, slide the detail page and zoom a bit
     */
    public var drawerAnimation: DrawerAnimation = .slide
    /*
     Drawer layout:
     - over: over the detail page
     - under: udner the detail page
     Animation will also depend on this to make correct animation senses
     */
    public var drawerLayout: DrawerLayout = .over {
        didSet { updateDrawerLayout() }
    }
    /// Background color for overlay view
    public var overlayColor = UIColor(r: 0, g: 0, b: 0, a: 0.7) {
        didSet { updateOverlayColor() }
    }
    // destroyable interface
    public var disposeBag: DisposeBag? = DisposeBag()

    public init(withDetailPage detailPage: UIViewController? = nil, mainPage: UIViewController? = nil) {
        self.detailPage = detailPage
        self.mainPage = mainPage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func destroy() {
        overlayView.tapGesture.unbindAction()
        detailPage?.removeFromParent()
        mainPage?.removeFromParent()
        (detailPage as? IDestroyable)?.destroy()
        (mainPage as? IDestroyable)?.destroy()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailContentView)
        detailContentView.autoPinEdgesToSuperviewEdges()
        overlayView.isHidden = true
        overlayView.alpha = 0
        detailContentView.addSubview(overlayView)
        overlayView.autoPinEdgesToSuperviewEdges()
        overlayView.tapGesture.bind(to: tapAction, input: ())
        mainContentView.isHidden = true
        view.addSubview(mainContentView)
        mainContentView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)

        updateDrawerLayout()

        if let detailPage = detailPage {
            addChild(detailPage)
            detailContentView.addSubview(detailPage.view)
            detailPage.view.autoPinEdgesToSuperviewEdges()
            detailPage.didMove(toParent: self)
            detailContentView.sendSubviewToBack(detailPage.view)
        }

        if let mPage = mainPage {
            addChild(mPage)
            mainContentView.addSubview(mPage.view)
            mPage.view.autoPinEdgesToSuperviewEdges()
            mPage.didMove(toParent: self)
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailPage?.beginAppearanceTransition(true, animated: animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailPage?.endAppearanceTransition()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        detailPage?.beginAppearanceTransition(false, animated: animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        detailPage?.endAppearanceTransition()
    }

    public func replaceMainPage(_ mainPage: UIViewController) {
        (self.mainPage as? IDestroyable)?.destroy()
        self.mainPage?.view.removeFromSuperview()
        self.mainPage?.removeFromParent()
        addChild(mainPage)
        mainContentView.addSubview(mainPage.view)
        mainPage.view.autoPinEdgesToSuperviewEdges()
        mainPage.didMove(toParent: self)
        self.mainPage = mainPage
    }

    public func replaceDetailPage(_ detailPage: UIViewController, animated: Bool = true) {
        (self.detailPage as? IDestroyable)?.destroy()
        self.detailPage?.view.removeFromSuperview()
        self.detailPage?.removeFromParent()
        addChild(detailPage)
        detailContentView.addSubview(detailPage.view)
        detailPage.view.autoPinEdgesToSuperviewEdges()
        detailPage.didMove(toParent: self)
        detailContentView.sendSubviewToBack(detailPage.view)
        self.detailPage = detailPage
        closeDrawer(animated)
    }

    public func toggleDrawer(_ animated: Bool = true) {
        if isOpen {
            closeDrawer(animated)
        } else {
            openDrawer(animated)
        }
    }

    public func openDrawer(_ animated: Bool = true) {
        if isOpen {
            return
        }
        let duration: TimeInterval = animated ? drawerAnimation.duration : 0
        overlayView.isHidden = false
        mainContentView.isHidden = false
        mainPage?.beginAppearanceTransition(true, animated: animated)
        openDrawerAnimation(duration: duration) { _ in
            self.mainPage?.endAppearanceTransition()
            self.isOpen.toggle()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    // swiftlint:disable function_body_length
    private func openDrawerAnimation(duration: TimeInterval, completion: @escaping ((Bool) -> Void)) {
        switch drawerAnimation {
        case .slide:
            switch drawerLayout {
            case .over:
                mainContentView.transform = CGAffineTransform(translationX: -mainContentView.frame.width, y: 0)
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                    self.overlayView.alpha = 1
                    self.mainContentView.transform = .identity
                }, completion: completion)

            case .under:
                mainContentView.transform = CGAffineTransform(translationX: -(mainContentView.frame.width / 3), y: 0)
                detailContentView.transform = .identity
                let translateX: CGFloat
                switch drawerWidth {
                case .fix(let width):
                    translateX = width

                case .ratio(let ratio):
                    translateX = ratio * view.frame.width
                }

                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                    self.overlayView.alpha = 1
                    self.mainContentView.transform = .identity
                    self.detailContentView.transform = CGAffineTransform(translationX: translateX, y: 0)
                }, completion: completion)
            }

        case .slideAndZoom:
            if drawerLayout == .over {
                mainContentView.transform = CGAffineTransform(translationX: -mainContentView.frame.width, y: 0)
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    self.mainContentView.transform = .identity
                })
            }
            detailContentView.transform = .identity
            let scale: CGFloat = 0.8
            let translateX: CGFloat
            switch drawerWidth {
            case .fix(let width):
                translateX = width

            case .ratio(let ratio):
                translateX = ratio * view.frame.width
            }

            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                self.overlayView.alpha = 1
                var transform = CGAffineTransform(translationX: translateX, y: 0)
                transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
                self.detailContentView.transform = transform
            }, completion: completion)
        }
    }

    public func closeDrawer(_ animated: Bool = true) {
        if !isOpen {
            return
        }
        let duration: TimeInterval = animated ? drawerAnimation.duration : 0
        mainPage?.beginAppearanceTransition(false, animated: animated)
        closeDrawerAnimation(duration: duration) { _ in
            self.overlayView.isHidden = true
            self.mainContentView.isHidden = true
            self.mainPage?.endAppearanceTransition()
            self.isOpen.toggle()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func closeDrawerAnimation(duration: TimeInterval,
                                      completion: @escaping ((Bool) -> Void)) {
        switch drawerAnimation {
        case .slide:
            switch drawerLayout {
            case .over:
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                    self.overlayView.alpha = 0
                    self.mainContentView.transform = CGAffineTransform(translationX: -self.mainContentView.frame.width, y: 0)
                }, completion: completion)

            case .under:
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                    self.overlayView.alpha = 0
                    self.mainContentView.transform = CGAffineTransform(translationX: -(self.mainContentView.frame.width / 3), y: 0)
                    self.detailContentView.transform = .identity
                }, completion: completion)
            }

        case .slideAndZoom:
            if drawerLayout == .over {
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    self.mainContentView.transform = CGAffineTransform(translationX: -self.mainContentView.frame.width, y: 0)
                })
            }

            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                self.overlayView.alpha = 0
                self.detailContentView.transform = .identity
            }, completion: completion)
        }
    }

    private func updateDrawerWidth() {
        widthConstraint?.autoRemove()

        switch drawerLayout {
        case .over:
            switch drawerWidth {
            case .fix(let width):
                widthConstraint = mainContentView.autoSetDimension(.width, toSize: width)

            case .ratio(let ratio):
                widthConstraint = mainContentView.autoMatch(.width, to: .width, of: view, withMultiplier: ratio)
            }

        default:
            widthConstraint = mainContentView.autoMatch(.width, to: .width, of: view)
        }
        view.layoutIfNeeded()
    }

    private func updateDrawerLayout() {
        detailContentView.transform = .identity
        mainContentView.transform = .identity
        mainContentView.isHidden = true
        overlayView.isHidden = true

        switch drawerLayout {
        case .over:
            view.bringSubviewToFront(mainContentView)

        case .under:
            view.sendSubviewToBack(mainContentView)
        }

        updateDrawerWidth()
        updateOverlayColor()
    }

    private func updateOverlayColor() {
        switch drawerLayout {
        case .over:
            overlayView.backgroundColor = overlayColor

        case .under:
            overlayView.backgroundColor = .clear
        }
    }
}

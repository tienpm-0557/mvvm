//
//  ReachabilityPage.swift
//  MVVMExample
//
//  Created by dinh.tung on 7/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

/// AlertType for Reachability screens
public enum AlertType {
    case disposableAlert, dialogAlert
}


class ReachabilityPage: BasePage {

    @IBOutlet weak var btnDialogAlert: UIButton!
    @IBOutlet weak var btnDisposableAlert: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        DependencyManager.shared.registerService(Factory<ReachabilityService> {
            ReachabilityService.share
        })
    }

    override func bindViewAndViewModel() {
        btnDisposableAlert.setTitleColor(.white, for: .selected)
        btnDialogAlert.setTitleColor(.white, for: .selected)
        
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? ReachabilityPageViewModel else {
            return
        }
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        viewModel.rxAlertLabelContent ~> alertLabel.rx.text => disposeBag
        
        self.btnDisposableAlert.rx.bind(to: viewModel.rxDisposableAlertAction, input: ())
        self.btnDialogAlert.rx.bind(to: viewModel.rxDialogAlertAction, input: ())
        
        viewModel.rxReachbilityState.subscribe(onNext: { (state) in
            if state.alertType == .disposableAlert {
                switch state.connection {
                case .cellular:
                    self.layoutDisposableMessage(0)
                case .unavailable:
                    self.layoutDisposableMessage(20)
                case .wifi:
                    self.layoutDisposableMessage(0)
                default:
                    self.layoutDisposableMessage(20)
                }
            } else {
                self.layoutDisposableMessage(0)
                switch state.connection {
                case .cellular:
                    self.displayDialogMessage("Cellular data connected")
                case .unavailable:
                    self.displayDialogMessage("No internet connection")
                case .wifi:
                    self.displayDialogMessage("Wifi connected")
                default:
                    self.displayDialogMessage("No internet connection")
                }
            }
        }) => disposeBag
        
        
    }
    
    @IBAction func disposableAlertTapped(_ sender: Any) {
        btnDisposableAlert.isSelected = true
        btnDialogAlert.isSelected = false
    }
    
    @IBAction func dialogAlertTapped(_ sender: Any) {
        btnDialogAlert.isSelected = true
        btnDisposableAlert.isSelected = false
    }
    
    private func layoutDisposableMessage(_ height: CGFloat) {
        self.alertViewHeightConstraint.constant = height
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func displayDialogMessage(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


              @unknown default:
                fatalError()
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  MailService.swift
//  Action
//
//  Created by pham.minh.tien on 8/3/20.
//

import Foundation
import MessageUI
import RxSwift
import RxCocoa

public class MailService: NSObject, MFMailComposeViewControllerDelegate {
    
    static var shared = MailService()
    public var rxMailComposeState = BehaviorRelay<MFMailComposeResult?>(value: nil)
    public var rxMailSettingValidate = BehaviorRelay<String>(value: "")
    
    public func canSendEmailAndAlert() -> Bool {
        if MFMailComposeViewController.canSendMail() {
            return true
        } else {
            return false
        }
    }
    
    public func sendMailTo(listEmail _emails: [String],
                    withSubject _subject:String,
                    withMessage _message:String,
                    withModalType modalType:UIModalPresentationStyle = .fullScreen) {
        if MailService.shared.canSendEmailAndAlert() {
            let mailer = MFMailComposeViewController()
            mailer.mailComposeDelegate = self
            mailer.modalPresentationStyle = modalType
            mailer.setToRecipients(_emails)
            mailer.setSubject(_subject)
            mailer.setMessageBody(_message, isHTML: false)
            let window = UIApplication.shared.keyWindow
            guard let rootViewContorller = window?.rootViewController else {
                return
            }
            rootViewContorller.present(mailer, animated: true)
        } else {
            rxMailSettingValidate.accept("Please set up mail account in order to send email")
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult, error: Error?) {
        rxMailComposeState.accept(result)
        controller.dismiss(animated: true, completion: nil)
    }
}


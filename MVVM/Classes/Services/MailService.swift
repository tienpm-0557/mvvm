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
    public var mailComposeState = BehaviorRelay<String>(value: "")
    
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
            mailComposeState.accept("Please set up mail account in order to send email")
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            mailComposeState.accept("Mail cancelled: you cancelled the operation and no email message was queued.")
        case .saved:
            mailComposeState.accept("Mail saved: you saved the email message in the drafts folder.")
        case .sent:
            mailComposeState.accept("Mail send: the email message is queued in the outbox. It is ready to send.")
        case .failed:
            mailComposeState.accept("Mail failed: the email message was not saved or queued, possibly due to an error.")
        default:
            mailComposeState.accept("None")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}


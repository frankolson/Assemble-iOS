//
//  ShareEventViewController.swift
//  Assemble
//
//  Created by Will Olson on 10/10/21.
//

import UIKit
import Firebase

class ShareEventViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var inviteLink: UILabel!
    @IBOutlet weak var copyToClipboardButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var event: Event!
    let shareIntro = "Come to my event!"
    let errorText = "The link could not be generated"

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.isEnabled = false
        generateShareLink()
    }

    // MARK: - Actions
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyToClipboard(_ sender: Any) {
        guard let link = inviteLink.text, link != errorText else { return }
        
        UIPasteboard.general.string = "\(shareIntro) \(link)"
        showSuccessfulClipboardAlert()
    }
    
    @IBAction func share(_ sender: Any) {
        guard let link = inviteLink.text, link != errorText else { return }
        
        let activity = UIActivityViewController(
            activityItems: [shareIntro, URL(string: link)!],
            applicationActivities: nil
        )
        present(activity, animated: true, completion: nil)
    }

    // MARK: - Helpers
    
    func generateShareLink() {
        self.activityIndicator.stopAnimating()
        
        guard let inviteURL = event.inviteURL else {
            enableFailureState()
            return
        }
        
        print(inviteURL)
        let linkBuilder = DynamicLinkComponents(link: inviteURL, domainURIPrefix: Constants.URL.dynamicLinksURI)
        
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: Constants.Apple.bundleId)
        linkBuilder?.iOSParameters?.appStoreID = Constants.Apple.appStoreId
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = title
        
        linkBuilder?.shorten(completion: { url, warnings, error in
            if let error = error {
                debugPrint(error)
                self.enableFailureState()
                return
            }
            
            guard let url = url else {
                self.enableFailureState()
                return
            }
            
            self.inviteLink.text = url.absoluteString
            self.shareButton.isEnabled = true
        })
    }
    
    func enableFailureState() {
        inviteLink.text = errorText
        showLinkGenerationFailureAlert()
    }
    
    func showLinkGenerationFailureAlert() {
        let alert = UIAlertController(
            title: "Link Generation Failure",
            message: "The share link could not be generated, try again later",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessfulClipboardAlert() {
        let alert = UIAlertController(title: "Copied to clipboard", message: nil, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}

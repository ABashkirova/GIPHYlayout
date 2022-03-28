//
//  GifPreviewViewController.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import UIKit
import Gifu
import MobileCoreServices
import Photos

protocol GifPreviewInteractionInput: AnyObject {
    func setupImage(model: GifPreviewModel)
    func share(data: Data)
    func openSettings()
    func showMessage(_ message: GifPreviewMessage)
}

final class GifPreviewViewController: UIViewController, GifPreviewInteractionInput {

    @IBOutlet weak var gifImageView: GIFImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var resultContainer: UIView!
    @IBOutlet weak var resultMessage: UILabel!
    private var presenter: GifPreviewPresentationOutput?
    
    var routeToShare: ((Data, UIView) -> UIViewController)?
    var routeToSettings: (() -> Void)?
    
    convenience init(presenter: GifPreviewPresentationOutput) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.didLoadModule()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        gifImageView.stopAnimatingGIF()
        routeToShare = nil
        routeToSettings = nil
    }
    
    func setupImage(model: GifPreviewModel) {
        gifImageView.animate(withGIFData: model.data)
    }
    
    func openSettings() {
        showMessage(.openSettings)
        routeToSettings?()
    }
    
    func share(data: Data) {
        guard let activityViewController = routeToShare?(data, view) else { return }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func showMessage(_ message: GifPreviewMessage) {
        resultMessage.text = message.title
        resultMessage.sizeToFit()
        resultContainer.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 3, options: [.curveEaseInOut]) {
            self.resultContainer.alpha = 0
        } completion: { _ in }
    }
    
    @IBAction func ditTapSaveToCameraRoll(_ sender: Any) {
        presenter?.didRequestToSaveToCameraRoll()
    }
    
    @IBAction func didTapCopyGifLink(_ sender: Any) {
        presenter?.didRequestedCopyLinkGif()
    }
    
    @IBAction func didTapCopyGif(_ sender: Any) {
        presenter?.didRequestedCopyGif()
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        presenter?.didRequestShare()
    }
}

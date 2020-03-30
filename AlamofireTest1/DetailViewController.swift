//
//  DetailViewController.swift
//  AlamofireTest1
//
//  Created by Александр on 29.03.2020.
//  Copyright © 2020 Badmaev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol DetailVCDelegate {
    func deletePhoto()
}

class DetailViewController: UIViewController {
    
    var delegate: DetailVCDelegate?
    var photo: PhotoInfo!
    var imageScrollView: ImageScrollView!
    var progressView: UIProgressView!
    var deleteBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = photo.author
        setupBarButtonItem()
        setupProgressView()
        
        AF.request(photo.url)
            .validate()
            .downloadProgress(closure: { (progress) in
                self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            })
            .responseImage { (image) in
            if let image = image.value {
                self.progressView.isHidden = true
                self.setupImageScrollView()
                self.imageScrollView.set(image: image)
            }
        }
    }
    
    func setupBarButtonItem() {
        deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonAction))
        navigationItem.rightBarButtonItem = deleteBarButton
    }
    
    @objc func deleteBarButtonAction(_ sender: UIBarButtonItem) {
        delegate?.deletePhoto()
        navigationController?.popViewController(animated: true)
    }
    
    func setupImageScrollView() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

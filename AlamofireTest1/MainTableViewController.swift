//
//  MainTableViewController.swift
//  AlamofireTest1
//
//  Created by Александр on 29.03.2020.
//  Copyright © 2020 Badmaev. All rights reserved.
//

import UIKit
import Alamofire

class MainTableViewController: UITableViewController {
    
    var photos = [PhotoInfo]()
    var lastTappedPhotoIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photos"
        navigationItem.leftBarButtonItem = editButtonItem
        loadData()
    }
    
    func loadData() {
        AF.request("https://picsum.photos/v2/list?page=1&limit=20")
        .validate()
        .responseDecodable(of: [PhotoInfo].self) { response in
            guard let photos = response.value else { return }
            self.photos = photos
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if photos.count > 0 {
            let photo = photos[indexPath.row]
            cell.textLabel?.text = "Photo \(indexPath.row + 1). Author: \(photo.author)"
            cell.detailTextLabel?.text = "Size: \(photo.width) x \(photo.height)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastTappedPhotoIndexPath = indexPath
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.photo = photos[indexPath.row]
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            photos.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension MainTableViewController: DetailVCDelegate {
    func deletePhoto() {
        print("deletePhoto")
        if let indexPath = lastTappedPhotoIndexPath {
            photos.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

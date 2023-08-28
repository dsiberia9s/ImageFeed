//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 03.07.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let photosName: [String] = Array(0..<20).map{ "\($0)" }
    let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    let imageListService = ImagesListService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var token: String?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        self.token = oauth2TokenStorage.token
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            
            viewController.image = image
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 != imageListService.photos.count {
            if self.token != nil {
                self.imageListService.fetchPhotosNextPage(self.token!) { _ in }
            }
        }
    }
}


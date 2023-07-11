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
    }
}


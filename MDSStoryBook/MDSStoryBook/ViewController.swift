//
//  ViewController.swift
//  MDSStoryBook
//
//  Created by 최주리 on 4/21/26.
//

import UIKit

import MDS

class ViewController: UIViewController {
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "MDS StoryBook"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(testLabel)
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


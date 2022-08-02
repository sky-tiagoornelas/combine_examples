//
//  JustViewController.swift
//  CombineExample
//
//  Created by Tiago Ornelas on 01/08/2022.
//

import UIKit
import Combine

final class JustViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PublisherOperators"
        cancelButton.isEnabled = false
    }
    
    override func onSubscribeTapped() {
        
    }
}

//
//  ViewController.swift
//  ToyList
//
//  Created by Jonas Rodrigues de Oliveira
//  Copyright © 2022 FIAP. All rights reserved.
//

import UIKit
import Firebase

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelCopyright: UILabel!

    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    	
	private func gotoMainScreen() {
		if let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") {
			show(listTableViewController, sender: nil)
		}
	}
}


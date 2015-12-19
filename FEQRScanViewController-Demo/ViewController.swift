//
//  ViewController.swift
//  FEQRScanViewController-Demo
//
//  Created by Fabian Ehlert on 18.12.15.
//  Copyright © 2015 Fabian Ehlert. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FEQRScanViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Actions
    
    @IBAction func openScanner(sender: AnyObject) {
        let scanner = FEQRScanViewController()
        scanner.delegate = self
        let navController = UINavigationController(rootViewController: scanner)
        presentViewController(navController, animated: true, completion: nil)
    }

    // MARK: FEQRScanViewControllerDelegate
    
    func didScanCodeWithResult(result: String) {
        print("Scanner returned result: \(result)")
    }
}


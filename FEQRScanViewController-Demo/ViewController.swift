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
        let scanner = FEQRScanViewController(closeTitle: "Ciao!")
        scanner.delegate = self
        
        let navController = FENavigationController(rootViewController: scanner)
        presentViewController(navController, animated: true, completion: nil)
    }

    // MARK: FEQRScanViewControllerDelegate
    
    func didScanCodeWithResult(result: String) {
        print("Scanner returned result: \(result)")
        
        let alert = UIAlertController(title: "Result", message: result, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil) 
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}


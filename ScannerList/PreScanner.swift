//
//  PreScanner.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/10/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

class PreScanner: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */

}

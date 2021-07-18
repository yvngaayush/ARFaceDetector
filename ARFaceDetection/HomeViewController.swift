//
//  HomeViewController.swift
//  ARFaceDetection
//
//  Created by Aayush Shah on 7/1/21.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var welcometext: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.backgroundColor = UIColor(hue: 0.5028, saturation: 1, brightness: 0.79, alpha: 1.0) /* #00c6c9 */
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddNotePopupVC.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import UIKit
import RxSwift

class AddNotePopupVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!

    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.rx.value
            .subscribe(onNext: { value in
                print(value)
            })
        .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

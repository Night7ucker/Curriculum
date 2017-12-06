//
//  ViewController.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let bag = DisposeBag()
    let viewModel = LoginViewModel()

    var daysViewController: DaysViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kDaysViewController") as! DaysViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()


//        let ref = Database.database().reference()
//
//        let ref2 = ref.child("Monday")
//
//        ref2.removeValue()
//
//        ref.child("Tuesday").removeValue()
//        ref.child("Wednesday").removeValue()
        // Do any additional setup after loading the view, typically from a nib.
        signUpButton.rx.tap
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe({ _ in
                self.createAlertToSignUp()
            })
            .disposed(by: bag)

//        viewModel.login.asObservable()
//            .subscribe(onNext: {
//
//            })

        setupBindings()
        hideKeyboardWhenTappedAround()

//        self.viewModel.isValid.asObservable()
//            .filter { _ in true }
//            .subscribe({ _ in
//                self.navigationController?.pushViewController(self.daysViewController, animated: true)
//            })
//            .disposed(by: self.bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }

    func setupBindings() {
        loginTextField.rx.text
            .orEmpty.map{ $0 }
            .bind(to: viewModel.login)
            .disposed(by: bag)

        passwordTextField.rx.text
            .orEmpty.map{ $0 }
            .bind(to: viewModel.password)
            .disposed(by: bag)
    }

    func createAlertToSignUp() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Sign UP", message: "Enter login & password to proceed", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Login"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }

                self.navigationController?.pushViewController(self.daysViewController, animated: true)
            })
        }))


        // 4. Present the alert.
        self.present(alert, animated: true) {
            alert.view.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAlertViewTapGesture)))
        }
    }

    @objc func handleAlertViewTapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    func loginDidTouch() {
        if loginTextField.text != "" { // 1
            Auth.auth().signInAnonymously(completion: { (user, error) in // 2
                if let err = error { // 3
                    print(err.localizedDescription)
                    return
                }

//                self.performSegue(withIdentifier: "LoginToChat", sender: nil) // 4
            })
        }
    }

}


//
//  CurriculumViewController.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import UIKit
import Firebase

protocol CurriculumCellDelegate {
    func reloadTableView(cell: CurriculumCell)
}

class CurriculumViewController: UIViewController {

    @IBOutlet weak var curriculumTableView: UITableView!

    private var userCurriculumRef: DatabaseReference!
    private var curriculumRefHandler: DatabaseHandle?

    fileprivate var dataSourceArray = [String]()

    var dayToShowCurriculumOn: String!

    var addNotePopupVC: AddNotePopupVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kAddNotePopupVC") as! AddNotePopupVC
    }

    var idList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        userCurriculumRef = Database.database().reference().child(dayToShowCurriculumOn)

        hideKeyboardWhenTappedAround()
        addRightBarButtonPlus()
        navigationItem.leftBarButtonItem?.tintColor = .white

        curriculumTableView.dataSource = self
        curriculumTableView.delegate = self
        curriculumTableView.tableFooterView?.frame = CGRect.zero
        title = dayToShowCurriculumOn

        curriculumTableView.rowHeight = UITableViewAutomaticDimension
        curriculumTableView.estimatedRowHeight = 88

        observeNotesChanges()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func test() {
//
//
//        userCurriculumRef.observe(.Value, with: { snapshot in
//            //print(snapshot.value)
//            self.dependentsJSON = snapshot.value as? [String : [String : String]]
//
//            for dependent in self.dependentsJSON{
//                idList.append(dependent.key)
//            }
//
//        }, withCancelvalue: { error in
//            print(error)
//        })
//    }

    func observeNotesChanges() {
        userCurriculumRef.observe(DataEventType.value) { (snapshot) in

//            let dependentsJSON = snapshot.value as? [String : [String : String]]
//            print(dependentsJSON)
            guard let notesDictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let notes = notesDictionary["notes"] as? [String: AnyObject] else { return }
            for note in notes {
                self.idList.append(note.key)
            }
            print(self.dataSourceArray)
            // KOSTILE4EK
            for i in 0..<self.idList.count {
                guard let note = notes[self.idList[i]]?["note"] else { return }
                self.dataSourceArray.append(note as! String)
                self.dataSourceArray = Array(Set(self.dataSourceArray))
            }
            print(self.dataSourceArray)
            self.curriculumTableView.reloadData()

//            guard let note = notes["note"] as? String else { return }
//            print(note)
//            self.dataSourceArray.append(note)
//            self.curriculumTableView.reloadData()
        }
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touched")
//        view.endEditing(true)
//    }
    func addRightBarButtonPlus() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))

        navigationItem.rightBarButtonItem = button
    }

    @objc func addNote() {


        let addNoteAlert = UIAlertController(title: "Add note", message: "", preferredStyle: .alert)

        addNoteAlert.addTextField { (textField) in
            textField.placeholder = "Note"
        }

        addNoteAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak addNoteAlert] _ in
            let textField = addNoteAlert?.textFields![0]

            let newChildRef = self.userCurriculumRef.child("notes").childByAutoId()
            let noteItem = [
                "note": textField?.text
            ]
            newChildRef.setValue(noteItem)
//            self.userCurriculumRef.child("notes").setValue(["note": textField?.text])
        }))

        present(addNoteAlert, animated: true) {
            addNoteAlert.view.isUserInteractionEnabled = true
            addNoteAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAlertViewTapGesture)))
        }
    }

    @objc func handleAlertViewTapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        curriculumRefHandler = userCurriculumRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
                //                self.channels.append(Channel(id: id, name: name))
                //                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
}

extension CurriculumViewController: UITableViewDelegate {

}

extension CurriculumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurriculumCell") as! CurriculumCell

        cell.eventTitle = dataSourceArray[indexPath.row]
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSourceArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension CurriculumViewController: CurriculumCellDelegate {
    func reloadTableView(cell: CurriculumCell) {
        let indexPath = curriculumTableView.indexPath(for: cell)
        dataSourceArray[(indexPath?.row)!] = cell.changedEventTitle!
        curriculumTableView.reloadData()
    }
}










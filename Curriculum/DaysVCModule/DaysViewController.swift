//
//  DaysViewController.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class DaysViewController: UIViewController {


    @IBOutlet weak var daysTableView: UITableView!
    
    fileprivate let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 120.0, bottom: 0, right: 0)
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate var daysBackgroundColors = [UIColor]()

//    var curriculumViewController: CurriculumViewController {
//        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kCurriculumViewController") as! CurriculumViewController
//    }

    private lazy var userCurriculumRef: DatabaseReference = Database.database().reference().child("days")
    private var curriculumRefHandler: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setHidesBackButton(true, animated: true)

        formDaysColorsArray()
        print(daysBackgroundColors)
        
        daysTableView.dataSource = self
        daysTableView.delegate = self

        daysTableView.rowHeight = UITableViewAutomaticDimension
        daysTableView.estimatedRowHeight = 88

        title = "Days"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func formDaysColorsArray() {

        var isCurrentDayPassed = false

        for day in days {
            if day == Date().dayOfWeek() {
                daysBackgroundColors.append(UIColor(0, 128, 255, 1))
                isCurrentDayPassed = true
            } else {
                if isCurrentDayPassed {
                    daysBackgroundColors.append(UIColor(243, 21, 245, 1))
                } else {
                    daysBackgroundColors.append(UIColor.green)
                }
            }
        }
    }

    func getImageForDay(day: String, completion: @escaping (Bool, UIImage) -> Void) {
        var imageToReturn = UIImage()
        userCurriculumRef = Database.database().reference().child(day)
        userCurriculumRef.observe(.value) { (snapshot) in
            print(snapshot)
            guard let notesDictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let notes = notesDictionary["notes"] as? [String: AnyObject] else { return }
            print(notes.count)
            switch notes.count {
            case 0..<2:
                imageToReturn = UIImage(named: "greenLightButton")!
            case 2..<5:
                imageToReturn = UIImage(named: "yellowLightButton")!
            case 5..<100:
                imageToReturn = UIImage(named: "redLightButton")!
            default:
                imageToReturn = UIImage(named: "greenLightButton")!
            }
            completion(true, imageToReturn)
        }
    }
}

extension DaysViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.size.height - (navigationController?.navigationBar.frame.size.height)!) / 7
    }

}

extension DaysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell") as! DayCell

        cell.day = days[indexPath.row]
        cell.cellBackgroundColor = daysBackgroundColors[indexPath.row]
//        cell.buttonImage = UIImage(named: "redLightButton")
        getImageForDay(day: days[indexPath.row]) { success, image in
            if success {
                cell.buttonImage = image
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curriculumViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kCurriculumViewController") as! CurriculumViewController
        let selectedCell = tableView.cellForRow(at: indexPath) as! DayCell
        curriculumViewController.dayToShowCurriculumOn = selectedCell.day
        navigationController?.pushViewController(curriculumViewController, animated: true)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

//extension DaysViewController: UICollectionViewDelegate {
//
//}
//
//extension DaysViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 7
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCollectionCell
//
//        cell.day = days[indexPath.row]
////        cell.backgroundColor = daysBackgroundColors[indexPath.row]
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let curriculumViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kCurriculumViewController") as! CurriculumViewController
//        let selectedCell = collectionView.cellForItem(at: indexPath) as! DayCollectionCell
//        curriculumViewController.dayToShowCurriculumOn = selectedCell.day
//        print(selectedCell.day)
//        navigationController?.pushViewController(curriculumViewController, animated: true)
//    }
//}
//
//extension DaysViewController: UICollectionViewDelegateFlowLayout {
//    //1
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //2
////        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
////        let availableWidth = view.frame.width - paddingSpace
////        let widthPerItem = availableWidth / itemsPerRow
////
////
////        return CGSize(width: widthPerItem, height: widthPerItem)
//        return CGSize(width: view.frame.width - 120, height: view.frame.height / 7)
//    }
//
//    //3
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    // 4
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}


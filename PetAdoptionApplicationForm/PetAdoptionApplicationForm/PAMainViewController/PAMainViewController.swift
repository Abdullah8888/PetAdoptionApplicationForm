//
//  ViewController.swift
//  PetAdoptionApplicationForm
//
//  Created by Jimoh Babatunde  on 11/01/2020.
//  Copyright © 2020 Jimoh Babatunde. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import RKDropdownAlert

class PAMainViewController: BaseViews, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    private let titleLabel = UILabel()
    private let parentView = UIView()
    private var cell: UITableViewCell?
    private let navigationStackView   = UIStackView()
    
    
    private let pageTitle = UILabel(frame: CGRect())
    private let imageview = UIImageView()
    private let basicInfoLabel = UILabel()

    private let yardLabel = UILabel()
    private let btnYes  = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    private let btnNo  = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))

    private let submitBtn  = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    
    private let btnNext  = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    private let btnPrevious  = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    private var applicationDetails: JSON = []
    
    private let tableView = UITableView()
    private var currentPage = 0
    private var istherePage = true
    private var isPageExit = false
    private let model = PAMainViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationDetails = model.getApplicationDetails()
        self.header(title: applicationDetails["name"].stringValue)
        self.footer()
        self.mainView(applicationDetails: applicationDetails)
        self.view.backgroundColor = self.hexStringToUIColor(hex: "#016A65")
        NotificationCenter.default.addObserver(self, selector: #selector(didEndPage), name: Notification.Name.didEndPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noPreviousPage), name: Notification.Name.noPreviousPage, object: nil)
    }
    
    func header(title: String)  {
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-bold", size: 18.0)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = UIColor.white
        
        self.view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive  = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
    }
    
    func setUpTableView() {
        //tableView.layer.borderWidth = 3.0
        //tableView.layer.borderColor = UIColor.brown
        tableView.backgroundColor = self.hexStringToUIColor(hex: "#016A65")
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        parentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if currentPage == 0 {
            tableView.topAnchor.constraint(equalTo: basicInfoLabel.safeAreaLayoutGuide.bottomAnchor, constant: 17).isActive  = true
        }
        else {
           tableView.topAnchor.constraint(equalTo: pageTitle.safeAreaLayoutGuide.bottomAnchor, constant: 17).isActive  = true
        }
        tableView.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(currentPage))
    }
    
    //Mark UITextFieldDelegate
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        cell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0))
//        var dd = cell?.subviews.first as? UITextField
//        print("the third is, \(dd?.text)")
//    }
    
    func formatNumeric() {
        
    }
    
    //MARK: UITableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        let sectionIndex = currentPage == 0 ? 1 : 0
        if String(currentPage) == "0" {
            row = self.applicationDetails["pages"][currentPage]["sections"][sectionIndex]["elements"].arrayValue.count
        }
        else if String(currentPage) == "1"{
            row = self.applicationDetails["pages"][currentPage]["sections"][sectionIndex]["elements"].arrayValue.count
        }
        else if String(currentPage) == "2"{
            row = self.applicationDetails["pages"][currentPage]["sections"][sectionIndex]["elements"].arrayValue.count
            print("the row countis , \(row)")
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         cell = tableView.dequeueReusableCell(withIdentifier: String(currentPage), for: indexPath)
         cell?.backgroundColor = self.hexStringToUIColor(hex: "016A65")
        self.alignViews(pos: indexPath.item, cell: cell!)
        return cell!
    }
    
    
    func alignViews(pos: Int, cell: UITableViewCell) {
        let sectionIndex = currentPage == 0 ? 1 : 0
        let view = self.createViews(type: applicationDetails["pages"][currentPage]["sections"][sectionIndex]["elements"][pos]["type"].stringValue)
        if let textField = view as? UITextField {
            self.textFieldSetUp(textField, cell, pos)
        }
        else if let datePicker = view as? UIDatePicker {
            self.dataPickerSetUp(datePicker, cell)
        }
        else if let button = view as? UIButton {
            self.radioButton(button, cell, sectionIndex, pos)
        }
    }
    
    func hideTextField() {
        let dd = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))
        let ddd = dd?.contentView.subviews[1] as? UITextView
        print("the stuff is \(ddd) and \(dd)")
        
    }
    
    func textFieldSetUp(_ textField: UITextField, _ cell: UITableViewCell, _ pos: Int) {
        let sectionIndex = currentPage == 0 ? 1 : 0
        textField.placeholder = applicationDetails["pages"][currentPage]["sections"][sectionIndex]["elements"][pos]["label"].stringValue
        textField.font = UIFont(name: "HelveticaNeue-light", size: 13)
        textField.frame.size.height = 50
        textField.frame.size.width = 200
        textField.tag = pos
        textField.borderStyle = .roundedRect
        
        cell.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        cell.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
        cell.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: -20).isActive = true
        cell.rightAnchor.constraint(equalTo: textField.rightAnchor, constant: 20).isActive = true
    }
    
    func dataPickerSetUp(_ datePicker: UIDatePicker, _ cell: UITableViewCell) {
        let dobLabel = UILabel()
        dobLabel.text = "Date of Birth"
        //dobLabel.textAlignment = .left
        dobLabel.font = UIFont(name: "HelveticaNeue-light", size: 14)
        dobLabel.lineBreakMode = .byWordWrapping
        dobLabel.numberOfLines = 1
        dobLabel.textColor = UIColor.white
        
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillProportionally
        stackView.spacing   = 16.0
        stackView.layer.borderWidth = 3.0
        stackView.addArrangedSubview(dobLabel)
        stackView.addArrangedSubview(datePicker)
        cell.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
    }
    
    func radioButton(_ button: UIButton, _ cell: UITableViewCell, _ sectionIndex: Int, _ pos: Int) {
        yardLabel.text = applicationDetails["pages"][currentPage]["sections"][sectionIndex]["elements"][pos]["label"].stringValue
        yardLabel.font = UIFont(name: "HelveticaNeue-medium", size: 14.0)
        yardLabel.lineBreakMode = .byWordWrapping
        yardLabel.numberOfLines  = 2
        yardLabel.textColor = UIColor.white
        
        btnYes.setTitle("Yes", for: .normal)
        btnYes.layer.borderWidth = 2
        btnYes.layer.borderColor = UIColor.white.cgColor
        btnYes.addTarget(self, action: #selector(yesAction), for: .touchUpInside)
        
        btnNo.setTitle("No", for: .normal)
        btnNo.layer.borderWidth = 2
        btnNo.layer.borderColor = UIColor.white.cgColor
        btnNo.addTarget(self, action: #selector(noAction), for: .touchUpInside)
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillEqually
        stackView.spacing   = 16.0
        stackView.layer.borderWidth = 3.0
        stackView.addArrangedSubview(yardLabel)
        stackView.addArrangedSubview(btnYes)
        stackView.addArrangedSubview(btnNo)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive  = true
        stackView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func alignImageView(imageview: UIImageView, mycell: UITableViewCell) {
        imageview.layer.borderWidth = 1.0
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.cornerRadius = 10.0
        imageview.clipsToBounds = true
        imageview.sd_setImage(with: URL(string: applicationDetails["pages"][0]["sections"][0]["elements"][0]["file"].stringValue))
        mycell.addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        imageview.topAnchor.constraint(equalTo: mycell.safeAreaLayoutGuide.topAnchor, constant: 0).isActive  = true
        imageview.centerXAnchor.constraint(equalTo: mycell.centerXAnchor).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func footer() {
        btnNext.setTitle("next", for: .normal)
        btnNext.setTitleColor(UIColor.white, for: .normal)
        btnNext.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        
        
        btnPrevious.setTitle("previous", for: .normal)
        btnPrevious.setTitleColor(UIColor.white, for: .normal)
        btnPrevious.addTarget(self, action: #selector(beforeAction), for: .touchUpInside)
        
        //Stack View
        navigationStackView.axis  = NSLayoutConstraint.Axis.horizontal
        navigationStackView.distribution  = UIStackView.Distribution.fillEqually
        navigationStackView.spacing   = 16.0
        navigationStackView.layer.borderWidth = 3.0
        navigationStackView.addArrangedSubview(btnPrevious)
        navigationStackView.addArrangedSubview(btnNext)
        navigationStackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(navigationStackView)
        
        navigationStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0).isActive = true
        navigationStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    
}



//Start of first page UIViews
extension PAMainViewController {

    func mainView(applicationDetails: JSON) {
        parentView.backgroundColor = self.hexStringToUIColor(hex: "#016A65")
        self.view.addSubview(parentView)
        parentView.translatesAutoresizingMaskIntoConstraints = false

        parentView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 17).isActive  = true
        parentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        parentView.bottomAnchor.constraint(equalTo: navigationStackView.topAnchor).isActive = true

        uiViewSetup(applicationDetails: applicationDetails)
    }
    
    func uiViewSetup(applicationDetails: JSON) {
        pageTitle(applicationDetails: applicationDetails)
        embededPhoto(applicationDetails: applicationDetails)
        basicInfo(applicationDetails: applicationDetails)
        setUpTableView()
    }
    func pageTitle(applicationDetails: JSON) {
        pageTitle.text = applicationDetails["pages"][currentPage]["sections"][0]["label"].stringValue
        pageTitle.textAlignment = .center
        pageTitle.font = UIFont(name: "HelveticaNeue-medium", size: 16.0)
        pageTitle.lineBreakMode = .byWordWrapping
        pageTitle.textColor = UIColor.white
        parentView.addSubview(pageTitle)
        
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        
        pageTitle.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive  = true
        pageTitle.leftAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        pageTitle.rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        
    }
    
    func embededPhoto(applicationDetails: JSON) {
        print(applicationDetails["pages"][0]["sections"][0]["elements"][0]["file"].stringValue)
        imageview.image = UIImage(named: applicationDetails["pages"][0]["sections"][0]["elements"][0]["file"].stringValue)
        imageview.layer.borderWidth = 2.0
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.cornerRadius = 10.0
        imageview.clipsToBounds = true
        imageview.sd_setImage(with: URL(string: applicationDetails["pages"][0]["sections"][0]["elements"][0]["file"].stringValue))
        self.parentView.addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        imageview.topAnchor.constraint(equalTo: pageTitle.safeAreaLayoutGuide.topAnchor, constant: 30).isActive  = true
        imageview.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    
    func basicInfo(applicationDetails: JSON) {
        basicInfoLabel.text = applicationDetails["pages"][0]["sections"][1]["label"].stringValue
        basicInfoLabel.textAlignment = .left
        basicInfoLabel.font = UIFont(name: "HelveticaNeue-medium", size: 14)
        basicInfoLabel.lineBreakMode = .byWordWrapping
        basicInfoLabel.textColor = UIColor.white
        self.parentView.addSubview(basicInfoLabel)
        
        basicInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        basicInfoLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 30).isActive  = true
        basicInfoLabel.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 20).isActive = true
        basicInfoLabel.rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    @objc func didEndPage(notification: Notification) {
        let sender = notification.object
        
        guard sender as? PAMainViewController != nil else {
            return
        }
        
        self.displayDropDownAlertWithTitle(title: "Warning", message: "page finished", error: true)
    }
    
    @objc func noPreviousPage(notification: Notification) {
        let sender = notification.object
        
        guard sender as? PAMainViewController != nil else {
            return
        }
        
        self.displayDropDownAlertWithTitle(title: "Warning", message: "no previous page", error: true)
    }
    
    @objc func beforeAction(sender: UIButton) {
        if isPageExit {
            parentView.subviews.forEach( {$0.removeFromSuperview()})
            currentPage = currentPage - 1
            istherePage = true
            if currentPage < (self.applicationDetails["pages"].arrayValue.count - 1) {
   
                if currentPage == 0 {
                    isPageExit = false
                    mainView(applicationDetails: applicationDetails)
                }
                pageTitle(applicationDetails: self.applicationDetails)
                setUpTableView()
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(currentPage))
                tableView.reloadData()
                submitBtn.removeFromSuperview()
                
                //parentView.bottomAnchor.constraint(equalTo: navigationStackView.topAnchor, constant: 100).isActive = true
                
            }
        }
        else {
            NotificationCenter.default.post(name: Notification.Name.noPreviousPage, object: self)
        }
        
        
    }
    
    @objc func nextAction(sender: UIButton) {
        if istherePage {
            isPageExit = true
            parentView.subviews.forEach( {$0.removeFromSuperview()})
            currentPage = currentPage + 1
            if currentPage < (self.applicationDetails["pages"].arrayValue.count - 1) {
                pageTitle(applicationDetails: self.applicationDetails)
                setUpTableView()
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(currentPage))
                tableView.reloadData()
                
                
                //self.hideTextField()

            }
            else if currentPage == (self.applicationDetails["pages"].arrayValue.count - 1) {
                pageTitle(applicationDetails: self.applicationDetails)
                setUpTableView()
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(currentPage))
                tableView.reloadData()

                istherePage = false
                submitBtnView()
                //parentView.translatesAutoresizingMaskIntoConstraints = false
                parentView.bottomAnchor.constraint(equalTo: submitBtn.topAnchor, constant: 70).isActive = true
                print("the last, \(currentPage)")
            }
           
        }
        else {
            NotificationCenter.default.post(name: Notification.Name.didEndPage, object: self)
        }
//       for i in 0...3 {
//        cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0))
//        if let ss = cell?.contentView.subviews[0] as? UITextField {
//            print("the cell is \(ss.text)")
//        }
//    }
        
    }
    
    
    //MARK: DropDownAlert
    public func displayDropDownAlertWithTitle(title: String, message: String, error: Bool) {
        if error == true && title == "Warning" {
            RKDropdownAlert.title(title, message: message, backgroundColor: UIColor.yellow, textColor: UIColor.black, time: 2)
        }
        else if error == true {
            RKDropdownAlert.title(title, message: message, backgroundColor: UIColor.red, textColor: UIColor.white, time: 2)
        }
        else{
            RKDropdownAlert.title(title, message: message, backgroundColor: hexStringToUIColor(hex: "#016A65"), textColor: UIColor.white, time: 2)
        }
        
    }
    
    
}
//End of first UIViews

//Start of Second Page UIViews
extension PAMainViewController {
    
    @objc func yesAction(sender: UIButton) {
        print("display textField")
    }
    
    @objc func noAction(sender: UIButton) {
        print("hide textField")
    }
}
//End of Second Page UIViews

//Start of Third Page UIViews
extension PAMainViewController {
    func submitBtnView() {
        submitBtn.setTitle("submit", for: .normal)
        submitBtn.layer.borderWidth = 2
        submitBtn.layer.cornerRadius = 10
        submitBtn.layer.borderColor = UIColor.white.cgColor
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        self.view.addSubview(submitBtn)
        
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        
        submitBtn.bottomAnchor.constraint(equalTo: navigationStackView.topAnchor, constant: -20).isActive = true
        submitBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        submitBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    @objc func submitAction(sender: UIButton) {
        print("gonna validate here")
    }
}
//End of Third Page UIViews

extension PAMainViewController {
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
        return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            )
    }
}



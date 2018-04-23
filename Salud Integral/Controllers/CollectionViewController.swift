//
//  CollectionViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/1/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    
    let realm = try! Realm()
    
    var sections: Results<Section>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                
        loadSections()
        
        self.collectionView?.register(UINib(nibName: "CustomSection", bundle: nil), forCellWithReuseIdentifier: "customSection")
        
        layoutSettings()
        
        title = "Salud Integral"
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()

        collectionView?.reloadData()
    }

    func layoutSettings() {
        let navBarHeight = navigationController!.navigationBar.frame.size.height
        let width = (self.collectionView?.frame.size.width)! / 2
        let height = ((self.collectionView?.frame.size.height)! - navBarHeight - 20) / 4
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.collectionViewLayout = layout
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar() {
        guard let navBar = navigationController?.navigationBar else
        {fatalError("Navigation Controller does not exist.")}
        let navBarColor = FlatNavyBlue().lighten(byPercentage: 0.05)!
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    //MARK - Data Manipulation Methods

    func loadSections() {
        
        sections = realm.objects(Section.self)
        
        if sections?.count == 0 {
            createDefaultSections()
            sections = realm.objects(Section.self)
        }
        collectionView?.reloadData()
    }
    
    func createDefaultSections() {
        do {
            let section1 = Section()
            section1.name = "Alimentación"
            section1.imageName = "food"
            let section2 = Section()
            section2.name = "Ejercicio"
            section2.imageName = "exercise"
            let section3 = Section()
            section3.name = "Medicamentos"
            section3.imageName = "medicine"
            let section4 = Section()
            section4.name = "Finanzas"
            section4.imageName = "finance"
            let section5 = Section()
            section5.name = "Historial"
            section5.imageName = "history"
            let section6 = Section()
            section6.name = "Contactos"
            section6.imageName = "contacts"
            let section7 = Section()
            section7.name = "Sugerencias"
            section7.imageName = "suggestion"
            let section8 = Section()
            section8.name = "Configuración"
            section8.imageName = "configuration"
            try realm.write {
                realm.add(section1)
                realm.add(section2)
                realm.add(section3)
                realm.add(section4)
                realm.add(section5)
                realm.add(section6)
                realm.add(section7)
                realm.add(section8)
            }
            
        } catch {
            print("Error saving context \(error)")
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkListSegue" {
            let checkListVC = segue.destination as! ViewControllerCheckList
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                checkListVC.selectedSection = sections?[indexPath.row]
                checkListVC.sectionID = indexPath.row
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections?.count ?? 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customSection", for: indexPath) as! CustomCollectionViewCell
        
        if let section = sections?[indexPath.row] {
            cell.title.text = section.name
            cell.titleImage.image = UIImage(named: section.imageName)
        }
        cell.layer.borderWidth = 1
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        if cell.title.text == "Historial" {
            performSegue(withIdentifier: "historySegue", sender: cell)
        } else if cell.title.text == "Contactos" {
            performSegue(withIdentifier: "contactsSegue", sender: cell)
        } else if cell.title.text == "Configuración" {
            performSegue(withIdentifier: "configurationSegue", sender: cell)
        } else if cell.title.text == "Sugerencias" {
            performSegue(withIdentifier: "suggestionSegue", sender: cell)
        } else {
            performSegue(withIdentifier: "checkListSegue", sender: cell)
        }
    }

}

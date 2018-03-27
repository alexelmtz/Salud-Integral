//
//  CollectionViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/1/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift

class CollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    
    let realm = try! Realm()
    
    var sections: Results<Section>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                
        loadSections()
        
        self.collectionView?.register(UINib(nibName: "CustomSection", bundle: nil), forCellWithReuseIdentifier: "customSection")
        
        layoutSettings()
        
        self.title = "Inicio"
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    func layoutSettings() {
        let width = (self.collectionView?.frame.size.width)! / 2
        let height = ((self.collectionView?.frame.size.height)! - 100) / 4
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.collectionViewLayout = layout
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
            section1.imageName = "apple"
            let section2 = Section()
            section2.name = "Ejercicio"
            section2.imageName = "exercise"
            let section3 = Section()
            section3.name = "Medicamentos"
            section3.imageName = "medicine"
            let section4 = Section()
            section4.name = "Patrimonio"
            section4.imageName = "patrimonio"
            let section5 = Section()
            section5.name = "Historial"
            section5.imageName = "history"
            let section6 = Section()
            section6.name = "Contactos"
            section6.imageName = "contacts"
            let section7 = Section()
            section7.name = "Configuración"
            section7.imageName = "configuration"
            try realm.write {
                realm.add(section1)
                realm.add(section2)
                realm.add(section3)
                realm.add(section4)
                realm.add(section5)
                realm.add(section6)
                realm.add(section7)
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
    
        // It's the last element
        if indexPath.row == (sections?.count)! - 1 {
            cell.frame.size.width = collectionView.frame.size.width
        }
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
        } else {
            performSegue(withIdentifier: "checkListSegue", sender: cell)
        }
    }

}

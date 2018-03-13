//
//  CollectionViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/1/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    let realm = try! Realm()
    
    var sections: Results<Section>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                
        loadSections()
        
        self.collectionView?.register(UINib(nibName: "CustomSection", bundle: nil), forCellWithReuseIdentifier: "customSection")
        
        let width = (self.collectionView?.frame.size.width)! / 2
        let height = ((self.collectionView?.frame.size.height)! - 100) / 4
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.collectionViewLayout = layout
        
        self.title = "Inicio"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Data Manipulation Methods

    func loadSections() {
        
        sections = realm.objects(Section.self)
        
//        if sections?.count == 0 {
//            createDefaultSections()
//        }
        
        collectionView?.reloadData()
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

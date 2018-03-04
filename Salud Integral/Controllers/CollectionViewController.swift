//
//  CollectionViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/1/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    let sections = ["Alimentación", "Ejercicio", "Medicamentos", "Patrimonio", "Historial", "Contactos", "Configuración"]
    let sectionImages = [#imageLiteral(resourceName: "apple"), #imageLiteral(resourceName: "exercise"), #imageLiteral(resourceName: "medicine"), #imageLiteral(resourceName: "patrimonio"), #imageLiteral(resourceName: "history"), #imageLiteral(resourceName: "contacts"), #imageLiteral(resourceName: "configuration")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "checkListSegue" {
            let cell = sender as! CustomCollectionViewCell
            let checkListVC = segue.destination as! ViewControllerCheckList
            checkListVC.checklistTitle = cell.title.text!
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customSection", for: indexPath) as! CustomCollectionViewCell
        cell.title.text = sections[indexPath.row]
        cell.titleImage.image = sectionImages[indexPath.row]
        cell.layer.borderWidth = 1
    
        // It's the last element
        if indexPath.row == sections.count - 1 {
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

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

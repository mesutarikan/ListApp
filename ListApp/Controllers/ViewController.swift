//
//  ViewController.swift
//  ListApp
//
//  Created by mesut  on 4.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource =  self
        tableView.delegate = self
        getData()
    }
    
    @IBAction func clickedTrashBarButtonItem (_sender : UIBarButtonItem){
        let alert = UIAlertController(title: "Uyarı", message: "Tüm listeyi silmek istiyormusunuz.", preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "Vazgeç", style: UIAlertAction.Style.cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "Evet", style: UIAlertAction.Style.default) { _ in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            for datum in self.data {
                context.delete(datum)
            }
            try? context.save()
            self.getData()
            //self.data.removeAll()
            //self.tableView.reloadData()
        }
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func clickedAddBarButtonItem (_sender : UIBarButtonItem){
        let alert = UIAlertController(title: "Ekle", message: "Listeye Eleman Ekleme", preferredStyle: UIAlertController.Style.alert
        )
        let cancelButton = UIAlertAction(title: "Vazgeç", style: UIAlertAction.Style.cancel, handler: nil)
        let defaultButton = UIAlertAction(title: "Ekle", style: .default) { _ in
            let text = (alert.textFields?.first?.text)!
            if text != "" {
                //self.data.append((alert.textFields?.first?.text)!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: context)
                let listItem = NSManagedObject(entity: entity!, insertInto: context)
                listItem.setValue(text, forKey: "title")
                try? context.save()
                
                self.getData()
                
            }else{
                let alert = UIAlertController(title: "Uyarı", message: "Listeye boş değer girilmez!", preferredStyle: UIAlertController.Style.alert)
                let cancelButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(cancelButton)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        alert.addTextField()
        alert.addAction(defaultButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! context.fetch(fetchRequest)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellColor = [UIColor]()
        cellColor = [UIColor(red: 0.95, green: 0.77, blue: 0.68, alpha: 1.00),UIColor(red: 0.93, green: 0.87, blue: 0.82, alpha: 1.00),UIColor(red: 0.81, green: 0.82, blue: 0.76, alpha: 1.00),UIColor(red: 0.57, green: 0.69, blue: 0.71, alpha: 1.00),UIColor(red: 0.21, green: 0.27, blue: 0.36, alpha: 1.00),UIColor(red: 0.75, green: 0.82, blue: 0.87, alpha: 1.00)]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        cell.backgroundColor = cellColor[indexPath.row % cellColor.count]
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as! String
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { _, _, _ in
            //self.data.remove(at: indexPath.row)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.data[indexPath.row])
            try? context.save()
            self.getData()
        }
        deleteAction.backgroundColor = .systemRed
        // düzenAction.backgroundColor = .systemOrange
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { _, _, _ in
            
            let alert = UIAlertController(title: "Düzenle", message: "\(self.data[indexPath.row]) liste elemanını düzenle", preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: "Vazgeç", style: UIAlertAction.Style.cancel, handler: nil)
            let editButton = UIAlertAction(title: "Düzenle", style: UIAlertAction.Style.default) { _ in
                let text = (alert.textFields?.first?.text)!
                if text != "" {
                    //self.data[indexPath.row] = text
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    if context.hasChanges{
                        try? context.save()
                    }
                    self.tableView.reloadData()
                    
                }else{
                    let alert = UIAlertController(title: "Uyarı", message: "Liste elemanı boş girilemez!", preferredStyle: UIAlertController.Style.alert)
                    let cancelButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(cancelButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            alert.addTextField()
            alert.addAction(editButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = .systemOrange
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return config
    }
    
}


    
    




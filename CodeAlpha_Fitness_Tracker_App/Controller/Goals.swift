//
//  Goals.swift
//  CodeAlpha_Fitness_Tracker_App
//
//  Created by Marwan Mekhamer on 02/05/2025.
//

import UIKit
import ChameleonFramework

class Goals: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noGoalsyet: UILabel!
    
    var arrData = [Entity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getAllItem()
        updateUI()
    }
    
    func updateUI() {
        if arrData.isEmpty{
            self.tableView.isHidden = true
            self.noGoalsyet.isHidden = false
        }else {
            self.tableView.isHidden = false
            self.noGoalsyet.isHidden = true
        }

    }
    
    @IBAction func addGoals(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Goals!", message: "You can add goals!", preferredStyle: .alert)
        alert.addTextField { textfiels in
            textfiels.placeholder = "What is your next goal?"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let textgoal = alert.textFields?.first?.text, !textgoal.isEmpty {
//                self.arrData.append(textgoal)
                self.createItems(textgoal)
                self.tableView.isHidden = false
                self.noGoalsyet.isHidden = true
                self.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
    
    @IBAction func EditPressed(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
        
    }
    
    
    
}

  // Marwan: - Table View func

extension Goals: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Title = arrData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Title.title
        cell.detailTextLabel?.text = "\(Title.date!)"
        let bgColor = UIColor.flatSkyBlue()
        cell.backgroundColor = bgColor
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: bgColor!, returnFlat: true)
        cell.accessoryType = Title.check ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let goal = arrData[indexPath.row]
        goal.check = !goal.check
        
        do{
            try context.save()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let goalDelete = arrData[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "") { _, _, code in
//            self.arrData.remove(at: indexPath.row)
            self.deleteItem(goalDelete)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            if self.arrData.isEmpty{
                self.tableView.isHidden = true
                self.noGoalsyet.isHidden = false
            }
            code(true)
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// Marwan: - Core Data func

extension Goals{
    
    func getAllItem() {
        do {
            arrData = try context.fetch(Entity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch {
            print("❌ Error to get All Items?!")
        }
    }
    
    func createItems(_ title: String) {
        let newitem = Entity(context: context)
        newitem.title = title
        newitem.date = Date()
        do {
            try context.save()
            getAllItem()
        }catch{
            print("❌ Can not Create new item or save item!")
        }
    }
    
    func deleteItem(_ itme: Entity) {
        context.delete(itme)
        do{
            try context.save()
            getAllItem()
        }catch{
            print("❌ Can not delete item!")
        }
    }
    
    func updateItem(_ item: Entity, newtitle: String) {
        item.title = newtitle
        do{
            try context.save()
            getAllItem()
        }catch{
            print("❌ Can not update and save item!")
        }
    }
}

//
//  Workout.swift
//  CodeAlpha_Fitness_Tracker_App
//
//  Created by Marwan Mekhamer on 02/05/2025.
//

import UIKit
import ChameleonFramework

class Workout: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noWotkoutYet: UILabel!
    
    
    var arrData = [WorkoutEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getAllItem()
        update()
    }
    
    func update() {
        if arrData.isEmpty{
            self.tableView.isHidden = true
            self.noWotkoutYet.isHidden = false
        }else {
            self.tableView.isHidden = false
            self.noWotkoutYet.isHidden = true
        }
    }
    
    
    @IBAction func EditPressed(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBAction func addWorkOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Workout", message: "", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = "WorkOut (e.g., Cardio)"
        }
        alert.addTextField { textfield in
            textfield.placeholder = "Duration (minutes)"
            textfield.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let type = alert.textFields?[0].text, !type.isEmpty,
               let durationStr = alert.textFields?[1].text, let duration = Int16(durationStr) {
                let workout = WorkoutEntity(context: self.context)
                workout.type = type
                workout.duration = duration
                workout.date = Date()
                self.tableView.isHidden = false
                self.noWotkoutYet.isHidden = true
                do {
                    try self.context.save()
                    self.getAllItem()
                } catch {
                    print("❌ Failed to save workout")
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    
}

extension Workout: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Total = arrData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        cell?.textLabel?.text = Total.type
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        cell?.detailTextLabel?.text = "duration: \(Total.duration) min"
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        let bgColor = UIColor.flatMaroon()
        cell?.backgroundColor = bgColor
        cell?.textLabel?.textColor = ContrastColorOf(backgroundColor: bgColor!, returnFlat: true)
        cell?.detailTextLabel?.textColor = ContrastColorOf(backgroundColor: bgColor!, returnFlat: true)
        cell?.accessoryType = Total.check ? .checkmark : .none
        return cell!
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
        let delete = UIContextualAction(style: .destructive, title: "") { _, _, done in
            let workoutToDelete = self.arrData[indexPath.row]
            self.context.delete(workoutToDelete)
            try? self.context.save()
            self.getAllItem()
            if self.arrData.isEmpty{
                self.tableView.isHidden = true
                self.noWotkoutYet.isHidden = false
            }
            done(true)
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension Workout{
    
    func getAllItem() {
        do {
            arrData = try context.fetch(WorkoutEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch {
            print("❌ Error to get All Items?!")
        }
    }
    
    func createItems(_ title: String, calo: Double) {
        let newitem = WorkoutEntity(context: context)
        newitem.type = title
        newitem.date = Date()
        newitem.calories = calo
        do {
            try context.save()
            getAllItem()
        }catch{
            print("❌ Can not Create new item or save item!")
        }
    }
    
    func deleteItem(_ itme: WorkoutEntity) {
        context.delete(itme)
        do{
            try context.save()
            getAllItem()
        }catch{
            print("❌ Can not delete item!")
        }
    }
    
    func updateItem(_ item: WorkoutEntity, newtitle: String) {
        item.type = newtitle
        do{
            try context.save()
            getAllItem()
        }catch{
            print("❌ Can not update and save item!")
        }
    }
}

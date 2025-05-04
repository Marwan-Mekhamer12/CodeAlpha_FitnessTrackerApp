//
//  ViewController.swift
//  CodeAlpha_Fitness_Tracker_App
//
//  Created by Marwan Mekhamer on 02/05/2025.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet weak var workout: UIButton!
    @IBOutlet weak var goal: UIButton!
    @IBOutlet weak var viewprogress: UIButton!
    @IBOutlet weak var workoutCount: UILabel!
    @IBOutlet weak var caloriesnum: UILabel!
    @IBOutlet weak var timeSpend: UILabel!
    
    var workout1 = [WorkoutEntity]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.flatSand()
        workout.layer.cornerRadius = 18
        goal.layer.cornerRadius = 18
        viewprogress.layer.cornerRadius = 18
        loadProgress()
        
    }
    
    func loadProgress() {
            do {
                workout1 = try context.fetch(WorkoutEntity.fetchRequest())

                let workout = "\(workout1.count)"
                let goal = "\(workout1.reduce(0) { $0 + Int($1.calories) })"
                let timeSpend = "\(workout1.reduce(0) { $0 + Int($1.duration) })"
                
                self.workoutCount.text = "Workouts: \(workout)"
                self.caloriesnum.text = "Calories: \(goal)"
                self.timeSpend.text = "Time: \(timeSpend) min"
                

            } catch {
                print("❌ Failed to fetch progress")
            }
        }
    
}


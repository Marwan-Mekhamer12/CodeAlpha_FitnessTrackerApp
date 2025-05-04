//
//  ProgressVC.swift
//  CodeAlpha_Fitness_Tracker_App
//
//  Created by Marwan Mekhamer on 02/05/2025.
//

import UIKit

class ProgressVC: UIViewController {

    @IBOutlet weak var totalworkout: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var workout = [WorkoutEntity]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.flatWhite()
        loadProgress()
    }
    
    func loadProgress() {
            do {
                workout = try context.fetch(WorkoutEntity.fetchRequest())

                let totalworkout = "\(workout.count)"
                let calories = "\(workout.reduce(0) { $0 + Int($1.calories) })"
                let time = "\(workout.reduce(0) { $0 + Int($1.duration) })"
                
                self.totalworkout.text = "Workouts: \(totalworkout)"
                self.calories.text = "Calories: \(calories)"
                self.time.text = "Time: \(time) min"
                
                
                let progress = Float(totalworkout)! / 10.0 // Example goal of 10 workouts
                progressView.progress = progress

            } catch {
                print("❌ Failed to fetch progress")
            }
        }
    
}

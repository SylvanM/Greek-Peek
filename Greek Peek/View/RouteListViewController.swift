//
//  RouteListViewController.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 4/20/22.
//

import UIKit

class RouteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    let difficultyFilterIndex = 0
    let lengthFilterIndex = 1
    let ratingFilterIndex = 2
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var routes: [Route]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func filterControlUpdated(_ sender: Any) {
        tableView.reloadData()
    }
    
    // MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch filterControl.selectedSegmentIndex {
        case difficultyFilterIndex:
            return Route.Difficulty.allCases.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell") as! RouteTableViewCell
        cell.route = routes[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let routeVC = storyboard?.instantiateViewController(identifier: "RouteViewController") as? RouteViewController {
            routeVC.route = routes[indexPath.row]
            navigationController?.pushViewController(routeVC, animated: true)
        }
    }

}

//
//  RouteViewController.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 4/20/22.
//

import UIKit

class RouteViewController: UIViewController {
    
    var route: Route! {
        didSet {
            _ = self.view // Force view controller to load view hierarchy
            routeNameLabel.text = route.name
            difficultyLabel.text = route.difficulty.asString
            descriptionField.text = route.description ?? "Example Description Goes Here"
        }
    }
    
    @IBOutlet weak var routeImageCollectionView: UICollectionView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        routeImageCollectionView.delegate = self
        routeImageCollectionView.dataSource = self

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

}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    var fakeReviews: [Route.Review] {
        [
            Route.Review(author: "Sylvan", rating: 5, review: "Awesome slope!!"),
            Route.Review(author: "Dylan", rating: 3.5, review: "It's fun but was icy today"),
            Route.Review(author: "Austin", rating: 5, review: "route was straight bitchin'")
        ]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fakeReviews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = fakeReviews[indexPath.section]
        let reviewCell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! RouteReviewCell
        reviewCell.authorLabel.text = review.author
        reviewCell.ratingLabel.text = "\(review.rating)/5"
        reviewCell.reviewLabel.text = review.review
        return reviewCell
    }
    
    
}

extension RouteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    var fakeImages: [UIImage] {
        [
            UIImage(named: "image1.jpeg", in: Bundle.main, with: nil)!,
            UIImage(named: "image2.jpeg", in: Bundle.main, with: nil)!,
            UIImage(named: "image3.jpeg", in: Bundle.main, with: nil)!,
            UIImage(named: "image4.jpeg", in: Bundle.main, with: nil)!
        ]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fakeImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! RouteImageCell
        imageCell.image = fakeImages[indexPath.row]
        return imageCell
    }


}

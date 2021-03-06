//
//  MovieDetailViewController.swift
//  rottentomatoes
//
//  Created by Ben Hass on 2/3/15.
//  Copyright (c) 2015 benhass. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var detailPhoto: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let movieTitle = movie["title"] as? String
        let url = movie.valueForKeyPath("posters.thumbnail") as String
        let highResUrl: String = url.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        
        navigationItem.title = movieTitle
        titleLabel.text = movieTitle
        synopsisLabel.text = movie["synopsis"] as? String
        synopsisLabel.sizeToFit()
        detailPhoto.setImageWithURL(NSURL(string: highResUrl))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDrag() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

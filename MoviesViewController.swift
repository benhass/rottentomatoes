//
//  MoviesViewController.swift
//  rottentomatoes
//
//  Created by Ben Hass on 2/2/15.
//  Copyright (c) 2015 benhass. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    var requestCount: Int = 1
    var movies: [NSDictionary]! = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        networkErrorView.hidden = true
        tableView.hidden = true

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if var indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell

        var movie = movies[indexPath.row]
        var url = movie.valueForKeyPath("posters.thumbnail") as String
        cell.posterView.setImageWithURL(NSURL(string: url))
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as MovieDetailViewController
        let indexPath = self.tableView.indexPathForCell(sender as MovieCell) as NSIndexPath!
        vc.movie = movies[indexPath.row]
    }
    
    func loadData(limit: Int = 30) {
        let badUrl = "www.google.com:81"
        let apiKey = "37jbp9fs675fjt3p8urn52mv"
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=\(limit)&apikey=\(apiKey)"

        // fake a bad request on the third try
        if (requestCount % 3 == 0) {
            println("bad request")
            url = badUrl
        }
        requestCount += 1
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            if (data != nil) {
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    if let movieCollection = dictionary["movies"] as? [NSDictionary] {
                        self.movies = movieCollection
                        self.tableView.reloadData()
                        self.tableView.hidden = false
                    }
                }
            }

            if (error != nil) {
                self.networkErrorView.hidden = false
                self.tableView.hidden = true
            }
            
            self.refreshControl.endRefreshing()
        })
    }
    
    func onRefresh() {
        loadData()
    }

}

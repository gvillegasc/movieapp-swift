//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 1/10/21.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private var favoriteMovies: [Movie] = []
    private var movieSelected: Movie!
    private var helper = DBHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        favoriteMovies = helper.getFavoriteMovies()
        reloadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoritesToMovieDetail" {
            let controller = segue.destination as? MovieDetailViewController
            controller?.movieSelected = movieSelected
        }
    }
    
    private func setupUI() {
        favoritesTableView.tableFooterView = UIView()
        favoritesTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteTableViewCell")
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.favoritesTableView.reloadData()
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        if favoriteMovies[indexPath.item].posterPath != nil {
            cell.movieImage.imageFromMovieDB(urlString: favoriteMovies[indexPath.item].posterPath!, placeHolderImage: UIImage(named: "not_image")!)
        } else {
            cell.movieImage.image = UIImage(named: "not_image")!
        }
        cell.titleMovieLabel.text = favoriteMovies[indexPath.item].title
        cell.releaseDateMovieLabel.text = favoriteMovies[indexPath.item].releaseDate.convertReleaseDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieSelected = favoriteMovies[indexPath.item]
        self.performSegue(withIdentifier: "FavoritesToMovieDetail", sender: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.favoritesTableView.cellForRow(at: IndexPath(row: indexPath.item, section: 0))?.setSelected(false, animated: true)
        }
    }
}

//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 1/10/21.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var withoutFavoritesView: UIView!
    
    // MARK: - Variables
    private var favoriteMovies: [Movie] = []
    private var movieSelected: Movie!
    private var viewModel = FavoritesViewModel()
    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getFavoriteMovies()
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
    
    private func getFavoriteMovies() {
        return viewModel.getFavoriteMovies()
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { favoriteMovies in
                    if favoriteMovies.isEmpty {
                        self.favoritesTableView.isHidden = true
                        self.withoutFavoritesView.isHidden = false
                    } else {
                        self.favoriteMovies = favoriteMovies
                        self.favoritesTableView.isHidden = false
                        self.withoutFavoritesView.isHidden = true
                        self.reloadTableView()
                    }
                },
                onError: { error in
                    print(error)
                }
            ).disposed(by: disposeBag)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.favoritesTableView.reloadData()
        }
    }
}


// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - UITableViewDataSource
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

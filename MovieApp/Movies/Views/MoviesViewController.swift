//
//  MoviesController.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 17/09/21.
//

import UIKit
import RxSwift

class MoviesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var popularMoviesCarousel: MovieCarousel!
    @IBOutlet weak var upcomingMoviesCarousel: MovieCarousel!
    @IBOutlet weak var topRatedMoviesCarousel: MovieCarousel!
    
    // MARK: - Variables
    private var viewModel = MoviesViewModel()
    private var disposeBag = DisposeBag()
    private var popularMovies = [Movie]()
    private var movieSelected: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSectionMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailViewController" {
            let controller = segue.destination as? MovieDetailViewController
            controller?.movieSelected = movieSelected
        }
    }
    
    private func setupUI() {
        popularMoviesCarousel.configureView(titleCarousel: "Popular Movies")
        popularMoviesCarousel.delegate = self
        upcomingMoviesCarousel.configureView(titleCarousel: "Upcoming Movies")
        upcomingMoviesCarousel.delegate = self
        topRatedMoviesCarousel.configureView(titleCarousel: "Top Rated Movies")
        topRatedMoviesCarousel.delegate = self
    }
    
    private func getSectionMovies() {
        viewModel.getPopularMovies()
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    self.popularMoviesCarousel.reloadCollectionView(movies: movies.listOfMovies)
                },
                onError: { error in
                    print(error)
                }
            ).disposed(by: disposeBag)
        viewModel.getUpcomingMovies()
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    self.upcomingMoviesCarousel.reloadCollectionView(movies: movies.listOfMovies)
                },
                onError: { error in
                    print(error)
                }
            ).disposed(by: disposeBag)
        viewModel.getTopReloadMovies()
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    self.topRatedMoviesCarousel.reloadCollectionView(movies: movies.listOfMovies)
                },
                onError: { error in
                    print(error)
                }
            ).disposed(by: disposeBag)
    }
}


extension MoviesViewController: MovieCarouselProtocol {
    
    func showMovieDetail(movieSelected: Movie) {
        self.movieSelected = movieSelected
        self.performSegue(withIdentifier: "MovieDetailViewController", sender: self)
    }
}

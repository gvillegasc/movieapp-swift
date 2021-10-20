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
    private var movieSelected: Movie!
    private var popularMoviesPage = 1
    private var upcomingMoviesPage = 1
    private var topRatedMoviesPage = 1
    
    // MARK: - Lifecycle Events
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
        if segue.identifier == "MoviesToMovieDetail" {
            let controller = segue.destination as? MovieDetailViewController
            controller?.movieSelected = movieSelected
        }
    }
    
    private func setupUI() {
        popularMoviesCarousel.configureView(titleCarousel: "Popular Movies", movieSection: Constants.MovieSection.popular)
        popularMoviesCarousel.delegate = self
        upcomingMoviesCarousel.configureView(titleCarousel: "Upcoming Movies", movieSection: Constants.MovieSection.upcoming)
        upcomingMoviesCarousel.delegate = self
        topRatedMoviesCarousel.configureView(titleCarousel: "Top Rated Movies", movieSection: Constants.MovieSection.topRated)
        topRatedMoviesCarousel.delegate = self
    }
    
    private func getSectionMovies() {
        getPopularMovies()
        getUpcomingMovies()
        getTopReloadMovies()
    }
    
    private func getPopularMovies() {
        return viewModel.getPopularMovies(page: popularMoviesPage)
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
    }
    
    private func getUpcomingMovies() {
        return viewModel.getUpcomingMovies(page: upcomingMoviesPage)
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
    }
    
    private func getTopReloadMovies() {
       return viewModel.getTopReloadMovies(page: topRatedMoviesPage)
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
        self.performSegue(withIdentifier: "MoviesToMovieDetail", sender: self)
    }

    func loadMoreMovies(movieSection: Constants.MovieSection) {
        if movieSection == Constants.MovieSection.popular {
            popularMoviesPage += 1
            getPopularMovies()
        } else if movieSection == Constants.MovieSection.upcoming {
            upcomingMoviesPage += 1
            getUpcomingMovies()
        } else {
            topRatedMoviesPage += 1
            getTopReloadMovies()
        }
    }
    
}

//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import Foundation
import RxSwift

class MoviesViewModel {
    
    private var movieService = MovieService()
    
    func getPopularMovies(page: Int) -> Observable<Movies> {
        return movieService.getPopularMovies(page: page)
    }
    
    func getUpcomingMovies(page: Int) -> Observable<Movies> {
        return movieService.getUpcomingMovies(page: page)
    }
    
    func getTopReloadMovies(page: Int) -> Observable<Movies> {
        return movieService.getTopRatedMovies(page: page)
    }
}

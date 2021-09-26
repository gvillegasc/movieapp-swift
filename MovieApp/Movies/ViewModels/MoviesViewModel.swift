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
    
    func getPopularMovies() -> Observable<Movies> {
        return movieService.getPopularMovies()
    }
    
    func getUpcomingMovies() -> Observable<Movies> {
        return movieService.getUpcomingMovies()
    }
    
    func getTopReloadMovies() -> Observable<Movies> {
        return movieService.getTopRatedMovies()
    }
}

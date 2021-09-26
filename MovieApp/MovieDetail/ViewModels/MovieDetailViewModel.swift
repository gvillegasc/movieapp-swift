//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 21/09/21.
//

import Foundation
import RxSwift

class MovieDetailViewModel {
    
    private var movieService = MovieService()
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        return movieService.getMovieDetail(movieId: movieId)
    }
}

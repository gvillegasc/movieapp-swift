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
    
    func searchMovie(movieId: Int) -> Observable<Bool> {
        return LocalDB.shared.searchMovie(movieId: movieId)
    }
    
    func insertMovie(movie: Movie) -> Observable<Bool> {
        return LocalDB.shared.insertMovie(movie: movie)
    }
    
    func deleteMovie(movieId: Int) -> Observable<Bool> {
        return LocalDB.shared.deleteMovie(id: movieId)
    }
}

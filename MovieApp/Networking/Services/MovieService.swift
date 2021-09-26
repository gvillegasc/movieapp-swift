//
//  MovieService.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import Foundation
import RxSwift

class MovieService: BaseAPI {
    
    private struct EndPoints {
        static let popularMovies = "/movie/popular"
        static let upcomingMovies = "/movie/upcoming"
        static let topRatedMovies = "/movie/top_rated"
    }
    
    func getPopularMovies(page: Int) -> Observable<Movies> {
        let url = URL(string: self.baseURL + EndPoints.popularMovies + self.apiKey + "&page=\(page)")
        return URLSession.shared.requestObserver(url: url, expecting: Movies.self)
    }
    
    func getUpcomingMovies(page: Int) -> Observable<Movies> {
        let url = URL(string: self.baseURL + EndPoints.upcomingMovies + self.apiKey + "&page=\(page)")
        return URLSession.shared.requestObserver(url: url, expecting: Movies.self)
    }
    
    func getTopRatedMovies(page: Int) -> Observable<Movies> {
        let url = URL(string: self.baseURL + EndPoints.topRatedMovies + self.apiKey + "&page=\(page)")
        return URLSession.shared.requestObserver(url: url, expecting: Movies.self)
    }
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        let url = URL(string: self.baseURL + "/movie/\(movieId)/credits"  + self.apiKey)
        return URLSession.shared.requestObserver(url: url, expecting: MovieDetail.self)
    }
}

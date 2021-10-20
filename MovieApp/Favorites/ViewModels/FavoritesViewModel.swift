//
//  FavoritesViewModel.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 3/10/21.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    
    private var helper = DBHelper()
    
    func getFavoriteMovies() -> Observable<[Movie]> {

        return Observable.create { observer in
            let movies = self.helper.getFavoriteMovies()
//                return movies
            observer.onNext(movies)
            return Disposables.create {}
        }
    }
}

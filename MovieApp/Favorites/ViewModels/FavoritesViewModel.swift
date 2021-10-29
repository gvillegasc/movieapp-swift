//
//  FavoritesViewModel.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 3/10/21.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    
    func getFavoriteMovies() -> Observable<[Movie]> {
        return LocalDB.shared.loadMovies()
    }
}

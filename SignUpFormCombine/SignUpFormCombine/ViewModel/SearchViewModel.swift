//
//  SearchViewModel.swift
//  SignUpFormCombine
//
//  Created by Jakub Gawecki on 26/05/2021.
//

import SwiftUI
import Combine

enum ServiceError: Error {
    case url(URLError?)
    case decode
    case unknown(Error)
}

class SearchViewModel: ObservableObject {
   
   @Published var username = ""
   @Published var presentingFollowersGrid = false
   @Published var followers: [Follower]? {
      didSet {
         presentingFollowersGrid.toggle()
      }
   }
   @Published var fetchingError: Error?
   @Published var searchButtonTapped = false {
      didSet {
         fetchFollowers2(with: "jmgawecki", for: 1)
      }
   }
   
   private var subscriptions = Set<AnyCancellable>()
   
   // MARK: - NetworkPublisher
   
   private func fetchFollowersPublisher(with username: String, for page: Int) {
      let baseUrlString = "https://api.github.com/users/"
      let endPointString = baseUrlString + "\(username)/followers?per_page=100&page=\(page)"
      print("Fetching fired off")
      print("url string is: \(endPointString)")
      guard let url = URL(string: endPointString) else {    // 1.
         print("creating url failed")
         return
      }
      
      
      let decoder = JSONDecoder()                           // 2.
      decoder.keyDecodingStrategy = .convertFromSnakeCase   // 3.
      
      URLSession.shared.dataTaskPublisher(for: url)         // 4.
         .tryMap { data, response in                        // 5.
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { // 10.
               print("Error here")                          // x
               throw URLError(.badServerResponse)           // x
            }
            return data                                     // 11.
         }
         .decode(type: [Follower].self, decoder: decoder)   // 6.
         .receive(on: DispatchQueue.main)                   // 7.
         .sink(receiveCompletion: { _ in }) { [weak self] followers in  // 8.
            guard let self = self else { return }           // x
            print("Operation successful")                   // x
            self.followers = followers                      // x
         }
         .store(in: &subscriptions)                       // 9.
   }
   
   private func fetchFollowersAppleWay(with username: String, for page: Int) {
      let baseUrlString = "https://api.github.com/users/"
      let endPointString = baseUrlString + "\(username)/followers?per_page=100&page=\(page)"
      
      guard let url = URL(string: endPointString) else { return }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      
      var fetchFollowersCancellable = URLSession.shared
         .dataTaskPublisher(for: url)
         .tryMap { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
               throw URLError(.badServerResponse)
            }
            return element.data
         }
         .decode(type: [Follower].self, decoder: decoder)
         .sink { error in
            
         } receiveValue: { followers in
            self.followers = followers
         }
   }
   
   private func fetchFollowersAppleWayMichal(with username: String, for page: Int) {
      let baseUrlString = "https://api.github.com/users/"
      let endPointString = baseUrlString + "\(username)/followers?per_page=100&page=\(page)"

      guard let url = URL(string: endPointString) else { return }

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase




      var fetchFollowersCancellable = URLSession.shared
         .dataTaskPublisher(for: url)
         .map { $0.data }
      //         .decode(type: [Follower].self, decoder: decoder)
      //         .mapError { error -> ServiceError in
      //            switch error {
      //               case is DecodingError: return ServiceError.decode
      //               case is URLError: return ServiceError.url(error as? URLError)
      //               default: return ServiceError.unknown(error)
      //            }
      //         }
   }
   
   private func fetchFollowers(with username: String, for page: Int) {
      let baseUrlString = "https://api.github.com/users/"
      let endPointString = baseUrlString + "\(username)/followers?per_page=100&page=\(page)"
      guard let url = URL(string: endPointString) else {    // 1.
         print("creating url failed")
         return
      }
      
      let decoder = JSONDecoder()                           // 2.
      decoder.keyDecodingStrategy = .convertFromSnakeCase   // 3.
      
      URLSession.shared.dataTaskPublisher(for: url)
         .sink { completion in
            if case .failure(let error) = completion {
               print(error.localizedDescription)
            }
         } receiveValue: { (data, response) in
            print("received data: \(data), response \(response)")
         }
         .store(in: &subscriptions)
      

   }
   
   private func fetchFollowers2(with username: String, for page: Int) {
      let baseUrlString    = "https://api.github.com/users/"
      let endPointString   = baseUrlString + "\(username)/followers?per_page=100&page=\(page)"
      guard let url = URL(string: endPointString) else {
         print("creating url failed")
         return
      }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      
      URLSession.shared.dataTaskPublisher(for: url)
         .map(\.data)
         .decode(type: [Follower].self, decoder: decoder)
         .receive(on: DispatchQueue.main)
         .sink { completion in
            if case .failure(let error) = completion {
               print(error.localizedDescription)
            }
         } receiveValue: { followers in
            self.followers = followers
         }
         .store(in: &subscriptions)
   }

}




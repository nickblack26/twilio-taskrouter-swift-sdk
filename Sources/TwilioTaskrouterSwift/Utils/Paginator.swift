//
//  File.swift
//  TwilioTaskrouterSwift
//
//  Created by Nick Black on 11/8/24.
//

import Foundation

struct Paginator<T: Codable> {
    private var nextToken: Bool
    private var source: (_ nextToken: Bool) -> Paginator<T>

    var hasNextPage: Bool
    var items: [T]
    
    init(
        items: [T],
        source: @escaping (_ nextToken: Bool) -> Paginator<T>,
        nextToken: Bool
    ) {
        self.nextToken = nextToken
        self.source = source
        self.items = items
        self.hasNextPage = nextToken
    }
    
    /**
    * Fetch the next page of elements.
    * @return {Promise<Paginator>} - Rejected if the {@link Paginator} has no next page to fetch.
    */
    func nextPage() async throws -> Paginator<T> {
        guard self.hasNextPage else { throw URLError(.cannotParseResponse) }
        return self.source(self.nextToken);
   }
}

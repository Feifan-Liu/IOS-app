//
//  API.swift
//  FeifanLiu-Lab4
//
//  Created by labuser on 10/15/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import Foundation
struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
struct VideoAPI:Decodable{
    let id: Int!
    let results:[Video]
}
struct Video:Decodable {
    let key: String?
    let site: String?
}
struct Movie: Codable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
    
    enum CodingKeys: String, CodingKey{
        case id; case poster_path; case title; case release_date; case vote_average; case overview;
    }
    init(id: Int, poster_path: String, title: String, release_date: String, vote_average: Double, overview: String, vote_count:Int){
        self.id=id; self.poster_path=poster_path; self.title=title; self.release_date=release_date; self.vote_average=vote_average; self.overview=overview; self.vote_count=vote_count
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id,forKey:.id)
        try container.encode(poster_path,forKey:.poster_path)
        try container.encode(title, forKey: .title)
        try container.encode(release_date,forKey: .release_date)
        try container.encode(vote_average,forKey:.vote_average)
        try container.encode(overview, forKey: .overview)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self,forKey:.id)
        poster_path = try container.decode(String?.self,forKey:.poster_path) ?? nil
        title = try container.decode(String.self, forKey: .title)
        release_date = try container.decode(String.self,forKey:.release_date)
        vote_average = try container.decode(Double.self,forKey:.vote_average)
        overview = try container.decode(String.self, forKey: .overview)
        vote_count = 0
    }
}

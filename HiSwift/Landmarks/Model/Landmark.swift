//
//  Landmark.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import Foundation
import SwiftUI
import CoreLocation


/*
 Hashable 是 Swift 标准库中的一个协议，常用于需要唯一标识或快速查找的类型，
 比如在集合（Set）和字典（Dictionary）中。实现 Hashable 协议的类型可以生成哈希值，
 这样系统可以高效地判断对象是否相等或在数据结构中进行查找。
 
 Codable 是 Swift 标准库中的一个协议组合，结合了 Encodable 和 Decodable 两个协议，
 支持将数据结构编码为外部表示（如 JSON）和从外部表示解码。它简化了数据的序列化和反序列化，
 使得 Swift 类型与外部数据格式（如 JSON、Property List 等）之间的转换更加方便。
 
 Identifiable 是 Swift 标准库中的协议，通常用于需要唯一标识的对象或数据模型。
 实现 Identifiable 协议的类型需要有一个 id 属性，用来唯一标识该类型的实例。
 这在 SwiftUI 中尤其有用，因为它允许 SwiftUI 区分和跟踪视图集合中的不同元素。
 */

struct Landmark : Hashable, Codable, Identifiable{
    
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool
    var isFeatured: Bool
    
    var category: Category
    enum Category: String, CaseIterable, Codable{
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }
    
    private var imageName: String
    var image: Image{
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }
    struct Coordinates: Hashable, Codable{
        var latitude: Double
        var longitude: Double
    }
}


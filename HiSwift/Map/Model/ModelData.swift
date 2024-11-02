//
//  ModelData.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import Foundation

/*
 @Observable是Swift中一个属性包装器的概念，
 用于标记一个对象可以被观察并在属性改变时自动通知订阅者。
 ObservableObject 协议用来定义可观察的数据模型。
 @Published属性包装器用于标记对象中的属性，当这些属性发生更改时，
 它会自动通知所有订阅了这个对象的视图，使它们重新渲染。
 */
@Observable
class ModelData{
    var landmarks: [Landmark] = load("landmarkData.json")
}

func load<T: Decodable>(_ fileName: String) -> T {
    
    let data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil)
    else{
        fatalError("Couldn't find \(fileName) in main bundle.")
    }
    
    do{
        data = try Data(contentsOf: file)
    }catch{
        fatalError("Couldn't load \(fileName) in main bundle.")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)

    } catch{
        fatalError("Couldn't parse \(fileName) in main bundle.")
    }
    
    
}

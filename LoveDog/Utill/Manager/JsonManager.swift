//
//  JsonManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/23/24.
//

import Foundation
import RxSwift

final class JsonManager {
    private init() { }
    
    static func configureBundleData<T: Decodable> (fileName: String, type: T.Type) -> Observable<T> {
        let result = Observable<T>.create { observer in
            
            guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                observer.onError(JsonParseError.invalidLocation)
                return Disposables.create()
            }
            
            do {
                let data = try Data(contentsOf: fileLocation)
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedData)
                }catch{
                    observer.onError(JsonParseError.failedDecodeData)
                }
                
            }catch {
                observer.onError(JsonParseError.failedConvertData)
            }
            
            return Disposables.create()
        }
        return result
    }
}

extension JsonManager {
    enum JsonParseError: Error, LocalizedError {
        case invalidLocation
        case failedConvertData
        case failedDecodeData
        
        var errorDescription: String? {
            switch self {
            case .invalidLocation:
                return "파일을 찾을 수 없습니다."
            case .failedConvertData:
                return "데이터를 변환하지 못했습니다."
            case .failedDecodeData:
                return "데이터 디코딩에 실패하였습니다."
            }
        }
    }
}

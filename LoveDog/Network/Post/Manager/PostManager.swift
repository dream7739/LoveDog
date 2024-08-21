//
//  PostManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
import Alamofire
import RxSwift

final class PostManager {
    
    static let shared = PostManager()
    private init() { }
    
    //게시글 조회
    func fetchPostList(request: FetchPostRequest) -> Single<Result<FetchPostResponse, FetchPostError>> {
        let result = Single<Result<FetchPostResponse, FetchPostError>>.create { observer in
            do {
                let fetchPostListRequest = try PostRouter.fetchPostList(param: request).asURLRequest()
                AF.request(fetchPostListRequest, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: FetchPostResponse.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(FetchPostError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "FETCH POST FAILED")
                observer(.success(.failure(FetchPostError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    //특정 게시글 조회
    func fetchPost(id: String) -> Single<Result<Post, FetchPostError>> {
        let result = Single<Result<Post, FetchPostError>>.create { observer in
            do {
                let fetchPostRequest = try PostRouter.fetchPost(id: id).asURLRequest()
                AF.request(fetchPostRequest, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: Post.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(FetchPostError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "FETCH POST FAILED")
                observer(.success(.failure(FetchPostError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    //게시글 이미지 조회
    func fetchPostImage(path: String) -> Single<Result<UIImage, CommonError>> {
        let result = Single<Result<UIImage, CommonError>>.create { observer in
            do {
                let fetchPostImageResquest = try PostRouter.fetchPostImage(path: path).asURLRequest()
                AF.download(fetchPostImageResquest, interceptor: AuthInterceptor.shared)
                    .responseData { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            if let image = UIImage(data: value) {
                                observer(.success(.success(image)))
                            }else {
                                observer(.failure(CommonError.init(statusCode: status)))
                            }
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(CommonError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "FETCH POST IMAGE REQUEST FAILED")
                observer(.success(.failure(CommonError.unknown)))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    //게시글 이미지 업로드
    func uploadPostImage(images: [String: Data]) -> Single<UploadPostImageResponse> {
        let result = Single<UploadPostImageResponse>.create { observer in
            do {
                let uploadPostImageRequest = try PostRouter.uploadPostImage.asURLRequest()
                
                AF.upload(multipartFormData: { multipart in
                    images.forEach { fileName, image in
                        multipart.append(image, withName: "files", fileName: fileName, mimeType: "image/png")
                    }
                }, with: uploadPostImageRequest, interceptor: AuthInterceptor.shared)
                .responseDecodable(of: UploadPostImageResponse.self) { response in
                    let status = response.response?.statusCode ?? 0
                    print("STATUS CODE ==== \(status)")
                    switch response.result {
                    case .success(let value):
                        print("UPLOAD FILES ===", value.files)
                        observer(.success((value)))
                    case .failure(let error):
                        print(error)
                        observer(.failure(UploadPostImageError.common(.unknown)))
                    }
                }
                
            }catch {
                print(#function, "UPLOAD POST IMAGE REQUEST FAILED")
                observer(.failure(UploadPostImageError.common(.unknown)))
            }
            return Disposables.create()
        }
        return result
    }
    
    //게시글 업로드
    func uploadPost(request: UploadPostRequest) -> Single<Result<Post, UploadPostError>> {
        let result = Single<Result<Post, UploadPostError>>.create { observer in
            do {
                let uploadPostRequest = try PostRouter.uploadPost(param: request).asURLRequest()
                AF.request(uploadPostRequest, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: Post.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(UploadPostError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "UPLOAD POST FAILED")
                observer(.success(.failure(UploadPostError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    
}

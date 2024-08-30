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
    func fetchPostList(request: FetchPostRequest)
    -> Single<Result<FetchPostResponse, APIError>> {
        do {
            let fetchPostListRequest = try PostRouter.fetchPostList(param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: fetchPostListRequest,
                response: FetchPostResponse.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "FETCH POST LIST FAILED")
            return Single<Result<FetchPostResponse, APIError>>.never()
        }
    }
    
    //특정 게시글 조회
    func fetchPost(id: String)
    -> Single<Result<Post, APIError>> {
        do {
            let fetchPostRequest = try PostRouter.fetchPost(id: id).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: fetchPostRequest,
                response: Post.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "FETCH POST FAILED")
            return Single<Result<Post, APIError>>.never()
        }
    }
    
    //게시글 이미지 조회
    func fetchPostImage(path: String)
    -> Single<Result<UIImage, APIError>> {
        do {
            let fetchPostImageResquest = try PostRouter.fetchPostImage(path: path).asURLRequest()
            
            return APIManager.shared.downloadRequest(
                request: fetchPostImageResquest,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "FETCH POST IMAGE FAILED")
            return Single<Result<UIImage, APIError>>.never()
        }
    }
    
    //유저별 작성 포스트 조회
    func fetchUserPost(id: String, request: FetchPostRequest)
    -> Single<Result<FetchPostResponse, APIError>> {
        do {
            let fetchUserPostRequest = try PostRouter.fetchUserPost(id: id, param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: fetchUserPostRequest,
                response: FetchPostResponse.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "FETCH USER POST FAILED")
            return Single<Result<FetchPostResponse, APIError>>.never()
        }
    }
    
    //좋아요한 포스트 조회
    func fetchLikePost(request: FetchPostRequest)
    -> Single<Result<FetchPostResponse, APIError>> {
        do {
            let fetchLikePostRequest = try PostRouter.fetchLikePost(param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: fetchLikePostRequest,
                response: FetchPostResponse.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "FETCH LIKE POST FAILED")
            return Single<Result<FetchPostResponse, APIError>>.never()
        }
    }
    
    //게시글 이미지 업로드
    func uploadPostImage(images: [String: Data])
    -> Single<UploadPostImageResponse> {
        do {
            let uploadPostImageRequest = try PostRouter.uploadPostImage.asURLRequest()
            
            let multipart = MultipartFormData()
            images.forEach { fileName, image in
                multipart.append(image, withName: "files", fileName: fileName, mimeType: "image/png")
            }
            
            return APIManager.shared.uploadRequest(
                request: uploadPostImageRequest,
                multipart: multipart,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "UPLOAD POST FAILED")
            return Single<UploadPostImageResponse>.never()
        }
    }
    
    //게시글 업로드
    func uploadPost(request: UploadPostRequest)
    -> Single<Result<Post, APIError>> {
        do {
            let uploadPostRequest = try PostRouter.uploadPost(param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: uploadPostRequest,
                response: Post.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "UPLOAD POST FAILED")
            return Single<Result<Post, APIError>>.never()
        }
    }
    
    //댓글 작성
    func uploadComments(id: String, request: UploadCommentsRequest)
    -> Single<Result<Comment, APIError>> {
        do {
            let uploadCommentsRequest = try PostRouter.uploadComments(id: id, param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: uploadCommentsRequest,
                response: Comment.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "UPLOAD COMMENT FAILED")
            return Single<Result<Comment, APIError>>.never()
        }
        
    }
    
    //좋아요
    func uploadLike(id: String, request: Like)
    -> Single<Result<Like, APIError>> {
        do {
            let uploadLikeRequest = try PostRouter.like(id: id, param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: uploadLikeRequest,
                response: Like.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "UPLOAD LIKE FAILED")
            return Single<Result<Like, APIError>>.never()
        }
    }
    
    //팔로우
    func uploadFollow(id: String)
    -> Single<Result<FollowResponse, APIError>> {
        do {
            let uploadFollowRequest = try PostRouter.follow(id: id).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: uploadFollowRequest,
                response: FollowResponse.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "UPLOAD LIKE FAILED")
            return Single<Result<FollowResponse, APIError>>.never()
        }
    }
}

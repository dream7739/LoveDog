# 사랑할개
보호중인 유기견을 소개하고, 유기견 입양스토리를 공유하는 유기견 커뮤니티 앱

|유기견 소개|유기견 소개 상세|스토리|스토리 상세|프로필|
|--------|------------|-----|--------|----|
|<img width = "200" src = "https://github.com/user-attachments/assets/5cf87c48-5d0b-4eae-b146-56432000ba68">|<img width = "200" src = "https://github.com/user-attachments/assets/7446c4e8-4f58-4326-bdd7-e0f6425b1bdd">|<img width = "200" src = "https://github.com/user-attachments/assets/7068106c-0dca-46fa-a0ea-d61ccfe1f4e1">|<img width = "200" src = "https://github.com/user-attachments/assets/23dd7294-3a6c-4159-826b-b00e9e5be978">|<img width = "200" src = "https://github.com/user-attachments/assets/878c68da-53df-4f60-aef9-31c6a50193fd">|

## 프로젝트 환경
- 인원: 1명
- 기간: 2024.08.14 - 2024.09.01
- 버전: iOS 16+

## 기술 스택
- UIKit, SnapKit, KeyboardLayoutGuide, MapKit, RxSwift, RxDatasource, MVVM+Input/Output, Alamofire+Router, PortOne

## 핵심 기능
- 공공API를 사용한 보호중인 유기견 소개
- 유기견 커뮤니티 및 응원(결제)
- 유저 팔로잉 및 팔로우
- 작성 및 좋아요한 글 확인
  
## 주요 기술
- enum을 사용한 Router 패턴을 구현하여 네트워크 요청 추상화 및 엔드포인트별 관리 효율성 향상
- 메모리 캐시와 디스크 캐시를 구현하여 이미지 캐싱 및 ETag를 통한 이미지 유효성 검증
- RxSwift의 Single과 ResultType을 조합하여 네트워크 통신 구현. 네트워크 요청 실패 시 구독이 끊기지 않도록 실패 케이스 대응
- 스토리 조회 시 커서 기반 페이지네이션 적용 및 게시글 Prefetch 적용하여 응답성 향상
- 스토리 사진 등록 시 Multipart-Form 데이터 형식으로 서버 업로드 기능 구현
- PortOne을 통한 결제(응원하기)기능 구현 및 영수증 검증 API 통신을 통해 유효성 검증
- keyboardLayoutGuide를 통한 키보드 대응 및 라이브러리 의존성 제거
- Alamofire RequestInterceptor를 통한 JWT 토큰 갱신 및 사용자 인증 기능 구현
- enum을 사용한 네트워크 상태코드 처리 및 다양한 네트워크 오류 상황에 대한 대응
- RxDatasource와 UICollectionViewCompositionalLayout을 사용하여 섹션별 다른 내용의 컬렉션뷰 구성
  
## 트러블 슈팅
### 1. 이미지 메모리 최적화
  > 많은 이미지가 화면에 보여지면서 메모리가 급증하는 현상 발생
- 다운샘플링을 사용하여 메모리 최적화
- imageView의 크기만큼 인자를 넘겨주어 썸네일 이미지 생성
- 이미지가 블러처리되는 이슈가 발생하여 기기별 픽셀값을 적용
```swift
extension UIImageView {
    func setImage(data: Data, size: CGSize) {
        
        let options: [NSString: Any] = [
                  kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) * UIScreen.main.scale,
                  kCGImageSourceCreateThumbnailFromImageAlways: true,
                  kCGImageSourceShouldCacheImmediately: true
              ]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
        let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return }
        let resizedImage = UIImage(cgImage: cgImage)
        self.image = resizedImage
    }
}
```

### 2. 메모리 캐시와 디스크 캐시 용량
> 이미지 캐시를 커스텀 사용하였을 때 메모리 캐시와 디스크 캐시가 무한정 증가되는 현상 발생
- 메모리 캐시(NSCache)의 경우 totalCostLimit로 코스트 제한
- 디스크 캐시(FileManager)의 경우 디스크 공간이 부족한 경우, 유효기간(1일)이 지난 파일 삭제 및 그 이후에도 용량이 부족할 시 무작위 삭제

> ImageCacheManager
```swift
final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache: NSCache<NSString, Cachable>
    private let maxDiskLimit = 1024 * 1024 * 50
    
    private init() {
        cache = NSCache<NSString, Cachable>()
        cache.totalCostLimit = 1024 * 1024 * 50
    }

   func cachingImage(url: URL, cachable: Cachable) {
        let key = url.path as NSString
        cache.setObject(cachable, forKey: key, cost: cachable.imageData.count)
    }

    private func deleteDiskImage(_ size: Int) {
    //중략
       if maxDiskLimit < countCurrentDiskSize() + size {
             for file in try manager.contentsOfDirectory(atPath: ".") {
                 if(maxDiskLimit > countCurrentDiskSize() + size) { break }
                      try manager.removeItem(atPath: file)
                      UserDefaultsManager.etag.removeValue(forKey: file)
              }
          }
    }
```
  
## 회고
- 디스크 캐시의 파일 삭제 방법에 대한 아쉬움이 존재. 지정된 용량을 넘었을 때 용량을 확보해야할 경우 무작위로 삭제하는 방식보다 상황에 맞는 더 나은 방식이 존재할 것이라 생각됨
- keyboardLayoutGuide를 사용하여 별도 라이브러리없이 키보드 대응할 수 있는 방법에 대해 학습할 수 있었음
- 네트워크 통신 오류 발생 시 여러 에러메시지가 존재하는데, 메시지에 대한 부분은 처리하지 않아서 클라이언트에서 처리하는 방법에 대해 고민해야 할 지점이라고 생각됨

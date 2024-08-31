//
//  IntroduceDetailViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import UIKit
import MapKit
import SnapKit
import RxSwift
import RxCocoa

final class IntroduceDetailViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let statusLabel = PaddingLabel()
    private let noticeNoLabel = UILabel()
    private let noticeDateLabel = UILabel()
    private let seperatorLabel = UILabel()
    private let baseInfoLabel = UILabel()
    private let kindLabel = UILabel()
    private let kindInfoLabel = UILabel()
    private let ageLabel = UILabel()
    private let ageInfoLabel = UILabel()
    private let weightLabel = UILabel()
    private let weightInfoLabel = UILabel()
    private let sexLabel = UILabel()
    private let sexInfoLabel = PaddingLabel()
    private let seperatorLabel2 = UILabel()
    private let additionalLabel = UILabel()
    private let findPlaceLabel = UILabel()
    private let findPlaceInfoLabel = UILabel()
    private let findDateLabel = UILabel()
    private let findDateInfoLabel = UILabel()
    private let neuterYnLabel = UILabel()
    private let neuterYnInfoLabel = UILabel()
    private let specialLabel = UILabel()
    private let specialInfoLabel = PaddingLabel()
    private let seperatorLabel3 = UILabel()
    private let careLabel = UILabel()
    private let orgInfoLabel = UILabel()
    private let orgNmLabel = UILabel()
    private let orgPhoneLabel = UILabel()
    private let careInfoLabel = UILabel()
    private let careNmLabel = UILabel()
    private let carePhoneLabel = UILabel()
    private let careAddrLabel = UILabel()
    private let careAddrInfoLabel = UILabel()
    
    private let mapView = MKMapView()
    
    let viewModel = IntroduceDetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [ imageView,
          statusLabel,
          noticeNoLabel,
          noticeDateLabel,
          seperatorLabel,
          baseInfoLabel,
          kindLabel,
          kindInfoLabel,
          ageLabel,
          ageInfoLabel,
          weightLabel,
          weightInfoLabel,
          sexLabel,
          sexInfoLabel,
          seperatorLabel2,
          additionalLabel,
          findPlaceLabel,
          findPlaceInfoLabel,
          findDateLabel,
          findDateInfoLabel,
          neuterYnLabel,
          neuterYnInfoLabel,
          specialLabel,
          specialInfoLabel,
          seperatorLabel3,
          careLabel,
          orgInfoLabel,
          orgNmLabel,
          orgPhoneLabel,
          careInfoLabel,
          careNmLabel,
          carePhoneLabel,
          careAddrLabel,
          careAddrInfoLabel,
          mapView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureNav() {
        super.configureNav()
        let close = UIBarButtonItem(image: Design.Image.close, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = close
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.verticalEdges.equalTo(scrollView)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        noticeNoLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(6)
            make.leading.equalTo(statusLabel)
        }
        
        noticeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(noticeNoLabel.snp.bottom).offset(6)
            make.leading.equalTo(noticeNoLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        seperatorLabel.snp.makeConstraints { make in
            make.top.equalTo(noticeDateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        baseInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        kindLabel.snp.makeConstraints { make in
            make.top.equalTo(baseInfoLabel.snp.bottom).offset(8)
            make.leading.equalTo(baseInfoLabel)
            make.width.equalTo(50)
        }
        
        kindInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(kindLabel.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.centerY.equalTo(kindLabel)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.bottom).offset(4)
            make.leading.equalTo(statusLabel)
            make.width.equalTo(50)
        }
        
        ageInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(ageLabel.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.centerY.equalTo(ageLabel)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(4)
            make.leading.equalTo(statusLabel)
            make.width.equalTo(50)
        }
        
        weightInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(weightLabel.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.centerY.equalTo(weightLabel)
        }
        
        sexLabel.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(8)
            make.leading.equalTo(statusLabel)
            make.width.equalTo(50)
        }
        
        sexInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(sexLabel.snp.trailing).offset(4)
            make.centerY.equalTo(sexLabel)
        }
        
        seperatorLabel2.snp.makeConstraints { make in
            make.top.equalTo(sexInfoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        additionalLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorLabel2.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        findPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(additionalLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.width.equalTo(70)
        }
        
        findPlaceInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(findPlaceLabel.snp.trailing).offset(4)
            make.centerY.equalTo(findPlaceLabel)
        }
        
        findDateLabel.snp.makeConstraints { make in
            make.top.equalTo(findPlaceLabel.snp.bottom).offset(4)
            make.leading.equalTo(findPlaceLabel)
            make.width.equalTo(70)
        }
        
        findDateInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(findDateLabel.snp.trailing).offset(4)
            make.centerY.equalTo(findDateLabel)
        }
        
        neuterYnLabel.snp.makeConstraints { make in
            make.top.equalTo(findDateLabel.snp.bottom).offset(4)
            make.leading.equalTo(findPlaceLabel)
            make.width.equalTo(70)
        }
        
        neuterYnInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(neuterYnLabel.snp.trailing).offset(4)
            make.centerY.equalTo(neuterYnLabel)
        }
        
        specialLabel.snp.makeConstraints { make in
            make.top.equalTo(neuterYnLabel.snp.bottom).offset(4)
            make.leading.equalTo(findPlaceLabel)
            make.width.equalTo(70)
        }
        
        specialInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(specialLabel.snp.trailing).offset(4)
            make.width.equalTo(50).priority(.low)
            make.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(-15)
            make.top.equalTo(specialLabel)
        }
        
        seperatorLabel3.snp.makeConstraints { make in
            make.top.equalTo(specialInfoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        careLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorLabel3.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        orgInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(careLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.width.equalTo(70)
        }
        
        orgNmLabel.snp.makeConstraints { make in
            make.top.equalTo(orgInfoLabel.snp.top)
            make.leading.equalTo(orgInfoLabel.snp.trailing).offset(4)
        }
        
        orgPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(orgNmLabel.snp.bottom).offset(4)
            make.leading.equalTo(orgNmLabel)
        }
        
        careInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(orgPhoneLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.width.equalTo(70)
        }
        
        careNmLabel.snp.makeConstraints { make in
            make.top.equalTo(careInfoLabel.snp.top)
            make.leading.equalTo(careInfoLabel.snp.trailing).offset(4)
        }
        
        carePhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(careNmLabel.snp.bottom).offset(4)
            make.leading.equalTo(careNmLabel)
        }
        
        careAddrLabel.snp.makeConstraints { make in
            make.top.equalTo(carePhoneLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.width.equalTo(70)
        }
        
        careAddrInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(careAddrLabel)
            make.leading.equalTo(careAddrLabel.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(careAddrInfoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(230)
            make.bottom.equalTo(contentView).offset(-15)
        }
        
    }
    
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        statusLabel.makeLightGrayRound()
        statusLabel.font = Design.Font.quarternary
        
        noticeNoLabel.font = Design.Font.primary_bold
        
        noticeDateLabel.font = Design.Font.quarternary
        noticeDateLabel.textColor = .dark_gray
        
        seperatorLabel.backgroundColor = .light_gray
        
        baseInfoLabel.font = Design.Font.secondary_bold
        baseInfoLabel.text = "기본사항"
        
        kindLabel.text = "견종"
        kindLabel.font = Design.Font.tertiary
        
        kindInfoLabel.font = Design.Font.tertiary
        
        ageLabel.text = "나이"
        ageLabel.font = Design.Font.tertiary
        
        ageInfoLabel.font = Design.Font.tertiary
        
        weightLabel.text = "무게"
        weightLabel.font = Design.Font.tertiary
        
        weightInfoLabel.font = Design.Font.tertiary
        
        sexLabel.text = "성별"
        sexLabel.font = Design.Font.tertiary
        
        sexInfoLabel.font = Design.Font.tertiary
        sexInfoLabel.makeBasicRound()
        
        seperatorLabel2.backgroundColor = .light_gray
        
        additionalLabel.font = Design.Font.secondary_bold
        additionalLabel.text = "상세사항"
        
        findPlaceLabel.text = "발견장소"
        findPlaceLabel.font = Design.Font.tertiary
        findPlaceLabel.numberOfLines = 2
        
        findPlaceInfoLabel.font = Design.Font.tertiary
        
        findDateLabel.text = "발견날짜"
        findDateLabel.font = Design.Font.tertiary
        
        findDateInfoLabel.font = Design.Font.tertiary
        
        neuterYnLabel.text = "중성화여부"
        neuterYnLabel.font = Design.Font.tertiary
        
        neuterYnInfoLabel.font = Design.Font.tertiary
        
        specialLabel.text = "특이사항"
        specialLabel.font = Design.Font.tertiary
        
        specialInfoLabel.font = Design.Font.tertiary
        specialInfoLabel.numberOfLines = 0
        specialInfoLabel.makeBasicRound()
        specialInfoLabel.backgroundColor = .light_gray
        specialInfoLabel.lineBreakMode = .byWordWrapping
        
        seperatorLabel3.backgroundColor = .light_gray
        
        careLabel.text = "보호사항"
        careLabel.font = Design.Font.secondary_bold
        
        careInfoLabel.text = "보호기관"
        careInfoLabel.font = Design.Font.tertiary
        
        careNmLabel.font = Design.Font.tertiary
        
        carePhoneLabel.font = Design.Font.tertiary
        
        orgInfoLabel.text = "관할기관"
        orgInfoLabel.font = Design.Font.tertiary
        
        orgNmLabel.font = Design.Font.tertiary
        
        orgPhoneLabel.font = Design.Font.tertiary
        
        careAddrLabel.text = "보호장소"
        careAddrLabel.font = Design.Font.tertiary
        
        careAddrInfoLabel.font = Design.Font.tertiary
        careAddrInfoLabel.lineBreakMode = .byWordWrapping
        careAddrInfoLabel.numberOfLines = 0
        
    }
    
}

extension IntroduceDetailViewController {
    private func bind() {
        let input = IntroduceDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.fetchAbandonItem
            .bind(with: self) { owner, value in
                //이미지
                ImageCacheManager.shared.loadImage(urlString: value.popfile)
                    .subscribe(with: self) { owner, value in
                        owner.imageView.image = UIImage(data: value)
                    } onError: { owner, error in
                        print("LOAD IMAGE ERROR \(error)")
                    }
                    .disposed(by: owner.disposeBag)
                
                //상태
                owner.statusLabel.text = value.processState
                
                //공고번호
                owner.noticeNoLabel.text = value.noticeNo
                
                //공고기간
                owner.noticeDateLabel.text = value.dateDescription
                
                //견종
                owner.kindInfoLabel.text = value.kindCd
                
                //나이
                owner.ageInfoLabel.text = value.ageDescription
                
                //무게
                owner.weightInfoLabel.text = value.weightDescription
                
                //성별
                let sexCd = SexCode(rawValue: value.sexCd) ?? .unknown
                owner.sexInfoLabel.text = sexCd.name
                owner.sexInfoLabel.backgroundColor = sexCd.color
                
                //발견장소
                owner.findPlaceInfoLabel.text = value.happenPlace
                
                //발견날짜
                owner.findDateInfoLabel.text = value.findDateDescription
                
                //중성화여부
                let neuterYn = Neuter(rawValue: value.neuterYn) ?? .unknown
                owner.neuterYnInfoLabel.text = neuterYn.description
                
                //특이사항
                owner.specialInfoLabel.text = value.specialMark
                
                //관할기관 이름
                owner.orgNmLabel.text = value.orgNm
                
                //관할기관 번호
                owner.orgPhoneLabel.text = value.officetel
                
                //보호소 이름
                owner.careNmLabel.text = value.careNm
                
                //보호소 번호
                owner.carePhoneLabel.text = value.careTel
                
                //보호소 위치
                owner.careAddrInfoLabel.text = value.careAddr
                owner.getCoordinateFromRoadAddress(from: value.careAddr)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension IntroduceDetailViewController {
    func getCoordinateFromRoadAddress(from address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { [weak self] places, error in
            if let _ = error {
                self?.mapView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                    return
                }
            }
            
            guard let place = places?.last, let coordinate = place.location?.coordinate else {  return  }
            self?.mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self?.mapView.addAnnotation(annotation)
        }
    }
}

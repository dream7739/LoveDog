//
//  FetchAbandonResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/22/24.
//

import Foundation

//기본 20개 페이지네이션
struct FetchAbandonResponse: Decodable {
    let response: FetchAbandonResult
}

struct FetchAbandonResult: Decodable {
    let header: FetchAbandonHeader
    let body: FetchAbandonBody? //바디는 있을수도, 없을 수도 있음
}

//에러가 발생하면 errorMsg
struct FetchAbandonHeader: Decodable {
    let reqNo: Int?
    let resultCode: String
    let resultMsg: String
    let errorMsg: String?
}

//실질적인 데이터
struct FetchAbandonBody: Decodable {
    var items: FetchAbandonItemList
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct FetchAbandonItemList: Decodable {
    var item: [FetchAbandonItem]
}

struct FetchAbandonItem: Decodable {
    let desertionNo: String //유기번호
    let filename: String //썸네일 이미지
    let happenDt: String //접수일
    let happenPlace: String //발견장소
    let kindCd: String //품종
    let colorCd: String //색상
    let age: String //나이
    let weight: String //체중
    let noticeNo: String
    let noticeSdt: String
    let noticeEdt: String
    let popfile: String //이미지
    let processState: String //상태 EX) 보호중
    let sexCd: String //M F Q(미상)
    let neuterYn: String //중성화 여부 Y N U(미상)
    let specialMark: String //특징
    let careNm: String //보호소 이름
    let careTel: String //보호소 전화번호
    let careAddr: String //보호소 주소
    let orgNm: String //관할기관
    let chargeNm: String? //담당자
    let officetel: String //담당자 연락처
    let noticeComment: String? //특이사항
    
    var infoDescription: String {
        return "\(ageDescription) \(weightDescription)"
    }
    
    var dateDescription: String {
        let startDate = BaseDateFormatterManager.basicDateFormatter.date(from: noticeSdt) ?? Date()
        let endDate = BaseDateFormatterManager.basicDateFormatter.date(from: noticeEdt) ?? Date()
        
        let startDateString = BaseDateFormatterManager.shortDateFormatter.string(from: startDate)
        let endDateString = BaseDateFormatterManager.shortDateFormatter.string(from: endDate)
        
        return "공고기간 " + startDateString + " - " + endDateString
    }
    
    var ageDescription: String {
        return age.htmlEscaped.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var weightDescription: String {
        return weight.htmlEscaped.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var findDateDescription: String {
        let findDate = BaseDateFormatterManager.basicDateFormatter.date(from: happenDt) ?? Date()
        let findDateString = BaseDateFormatterManager.longDateFormatter.string(from: findDate)
        return findDateString
    }
    
}



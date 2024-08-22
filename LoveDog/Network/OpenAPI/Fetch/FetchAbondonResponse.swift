//
//  FetchAbondonResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/22/24.
//

import Foundation

//기본 20개 페이지네이션
struct FetchAbondonResponse: Decodable {
    let response: FetchAbondonResult
}

struct FetchAbondonResult: Decodable {
    let header: FetchAbondonHeader
    let body: FetchAbondonBody? //바디는 있을수도, 없을 수도 있음
}

//에러가 발생하면 errorMsg
struct FetchAbondonHeader: Decodable {
    let reqNo: Int?
    let resultCode: String
    let resultMsg: String
    let errorMsg: String?
}

//실질적인 데이터
struct FetchAbondonBody: Decodable {
    let items: FetchAbondonItemList
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct FetchAbondonItemList: Decodable {
    let item: [FetchAbondonItem]
}

struct FetchAbondonItem: Decodable {
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
    let chargeNm: String //담당자
    let officetel: String //담당자 연락처
    let noticeComment: String? //특이사항
}

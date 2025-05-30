# 🧊 HeatWaveShelter

서울시의 폭염 대피소를 편리하게 조회하고 위치를 지도에서 확인할 수 있는 iOS 앱입니다.  
**MapKit**, **WebKit**, **XMLParser**, **UIKit** 등을 활용하여 사용자에게 실시간 정보를 제공합니다.

---

## 🧭 주요 기능

| 기능 구분 | 설명 |
|----------|------|
| 🏠 쉼터 목록 | 서울시 폭염 대피소 목록을 테이블 뷰로 출력 |
| 🗺️ 지도 확인 | 셀 클릭 시 해당 대피소 주소를 기반으로 지도에 핀 표시 |
| 🔍 검색 탭 | 웹뷰를 통해 날씨 검색 (ex. '오늘 서울 날씨') |
| 📡 주소 기반 검색 | '서울특별시'를 제외한 주소로 지오코딩 후 MapKit에 반영 |
| 💡 직관적인 UI | 사용자 경험을 고려한 커스텀 셀 뷰 구성 및 오토레이아웃 적용 |

---

## 📱 사용 기술

- **UIKit**: ViewController, TableView, Custom Cell 구성
- **MapKit**: 지도를 통한 대피소 위치 확인
- **CoreLocation**: 주소 기반 좌표 변환 (Geocoding)
- **WebKit**: WKWebView를 이용한 날씨 검색 탭 구현
- **XMLParser**: 서울 열린데이터 광장 API(XML) 파싱
- **AutoLayout**: 다양한 기기 대응을 위한 UI 설계

---

## 🗃️ 데이터 출처

- **서울 열린데이터 광장**
  - URL: [https://data.seoul.go.kr](https://data.seoul.go.kr)
  - API: `getCoolingcentreData.do`
  - 응답 형식: XML

---

## 📸 스크린샷

| 쉼터 목록 | 위치 확인 (MapKit) | 검색 탭 (날씨) |
|-----------|-------------------|----------------|
| ![shelter list](https://github.com/user-attachments/assets/b306957e-f0d0-45a1-b977-b9581be1079b) | ![map](https://github.com/user-attachments/assets/02a29228-07b7-46d4-aa70-965b685089d4) | ![weather](https://github.com/user-attachments/assets/86f6c6dc-9599-4a13-ac5e-8fa080059f5f) |

---

## ✨ 앞으로 개선할 점

- 🔁 사용자 위치 기반 근처 대피소 필터링
- 🧭 KakaoMap 도입 (지도 상세도 개선)
- 💬 다국어 지원 (한국어/영어)
- 📦 JSON 캐싱 및 오프라인 대응

---

## 🙋‍♀️ 개발자

| 이름 | 역할 | 링크 |
|------|------|------|
| 이희민 | iOS 개발 (기획·UI·API 연동) | [GitHub](https://github.com/yihimin) |

---

## ⚠️ 주의사항

- 해당 앱은 실시간 정보 제공을 목적으로 한 학습용 프로젝트입니다.
- 데이터의 정확성은 서울시 공개 API 기준으로 제공됩니다.

---

## 📦 실행 방법

1. 프로젝트 clone:  
   ```bash
   git clone https://github.com/yihimin/HeatWaveShelter.git

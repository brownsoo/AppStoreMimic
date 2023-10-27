# iOS Clean Architecture Workout 2
 
## 애플 앱스토어 검색 부분을 구현해봅니다.

참고: https://github.com/kudoleh/iOS-Clean-Architecture-MVVM

#### 구현 기능:
- 검색바
- 최근 검색어 리스트
- 검색어 제안
- 상세 화면

#### TODO: 

- [x] Domain, Repository, Presentation, View Controller 
- [ ] UseCase 추가
- [ ] UI Test 추가

## Architecture

* 클린 아키텍트 이론에 기반해 도메인, 데이터, 프리젠테이션, 인프라로 구분.
* MVVM 뷰 레이어 구성 
* UIKit 기반 뷰 구성, SwiftUI 미리보기 작성
* 뷰 상태를 하나의 struct로 구성 (`SearchViewState`)
* 네트워크 인프라 계층을 별도 프로젝트로 구성 
* minimum target : iOS 13.0

## Preview

https://github.com/brownsoo/AppStoreMimic/assets/5244407/007b19c0-b628-4394-b47a-93a5487f51d2

https://github.com/brownsoo/AppStoreMimic/assets/5244407/733c8353-4832-438f-b5ac-14672cd82607


##  Commit Convention

```plain
[FEAT] : 새로운 기능을 추가
[FIX] : 버그 수정
[STYLE] : 코드 포맷 변경, 세미 콜론 누락, 코드 수정이 없는 경우
[RF] : 코드 리팩토링
[COMMENT] : 필요한 주석 추가 및 변경
[DOCS] : 문서 수정
[TEST] : 테스트 코드, 리펙토링 테스트 코드 추가, Production Code(실제로 사용하는 코드) 변경 없음
[CHORE] : 빌드 업무 수정, 패키지 매니저 수정, 패키지 관리자 구성 등 업데이트, Production Code 변경 없음
```

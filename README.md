# everyHome

아파트 주민 간 공동구매, 공동배달을 통한 비용 절감 및 층간소음 문제를 해결하고자 만든 하이퍼로컬 커뮤니티 앱

![디자인](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/6ca34f17-4002-4944-8760-2ba8a5b04ca7)


### 팀원

고려대학교 컴퓨터학과 20학번 김윤서

DGIST 컴퓨터공학전공 19학번 공영재


### 개발환경

- Framework: flutter
- backend server: node.js
- database: mysql
- server deployment: AWS EC2
  

### 어플리케이션 소개

먼저 회원가입과 kakao login을 통해 로그인할 수 있습니다.

![KakaoTalk_20240111_220620604_04](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/c34ee94e-50a2-4be8-97ad-39d9ee3d0c76)

회원가입 시 방호수와 이메일, 비밀번호를 사용자로부터 입력받아 유저 인증 및 앱의 기능에 활용합니다.

![KakaoTalk_20240111_220620604_09](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/9a4f4582-735d-4525-aa5d-a465e073c7aa)

메인화면

사용자가 게시판을 위로 드래그하면, sheet position을 추적해 글쓰기 actionbutton animation이 동작하며 modal에서 글을 작성할 수 있습니다. 작성자가 유저 본인인 경우 삭제또한 가능합니다.

![KakaoTalk_20240111_220620604_07](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/73c5ac15-2b0c-4c96-bcd6-21912dcbd8cc)

사용자는 공동구매에서 대량구매를 통한 원가 절감, 공동배달을 통한 배달료 절감이 가능합니다. 공동구매는 참여인원을 설정하여, 인원이 모두 모집되면 푸시알림과 함께 신청 버튼이 비활성화됩니다.

![KakaoTalk_20240111_220620604](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/827f3ff2-8581-4e28-a85e-92718141886d)

공동배달은 좀 더 좁은 범위로, 참여인원 뿐만아니라 마감 시간을 설정해서 마감시간이 끝나기 전, 혹은 참여 인원이 모두 모이기 전까지 배달을 같이 시킬 주민들을 모집할 수 있습니다.

![KakaoTalk_20240111_220620604_01](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/247a3e80-2784-4863-acb7-8ec8ffc45537)


회원가입(카카오로 로그인) 시 아파트 호수를 받는데, 똑똑 탭에서 이를 활용해 층간소음 문제를 해결하고자 했습니다. 버튼을 누르면 애니메이션과 함께 위층에게 푸시 알림을 보낼 수 있습니다.

![KakaoTalk_20240111_220620604_03](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/1bbf15a5-1277-4cb9-b9a4-47b30c941aa0)

로그아웃 및 회원탈퇴 또한 가능합니다.

![KakaoTalk_20240111_220620604_08](https://github.com/Yeongjae-Kong/madcamp_week2/assets/67358433/556b2a9e-fa0d-4e8e-8c2a-bb675c4b7c48)


//
//  Software+sample.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/18.
//

import Foundation

extension Software {
    static func sample(id: String = "com.kakaobank.channel", title: String = "카카오뱅크") -> Software {
        Software(id: id,
                 icon: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/14/40/df/1440df75-ca71-cd30-f17f-6a2682065597/AppIcon_real-1x_U007emarketing-0-7-0-85-220.png/512x512bb.jpg"),
                 bigIcon: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/14/40/df/1440df75-ca71-cd30-f17f-6a2682065597/AppIcon_real-1x_U007emarketing-0-7-0-85-220.png/100x100bb.jpg"),
                 title: title,
                 subtitle: "프로바이더",
                 description: "일상에서 더 쉽게, 더 자주 만나는\n제1금융권 은행, 카카오뱅크\n\n■ 새롭게 디자인된 은행\n• 365일 언제나 지점 방문 없이 모든 은행 업무를 모바일에서\n• 7분만에 끝나는 쉬운 계좌개설\n\n■ 쉬운 사용성\n• 공동인증서, 보안카드 없는 계좌이체\n• 계좌번호를 몰라도 카톡 친구에게 간편 송금 (상대방이 카카오뱅크 고객이 아니어도 송금 가능)\n\n■ 내 취향대로 선택\n• 카카오프렌즈 캐릭터 디자인부터 고급스러운 블랙 컬러까지, 세련된 디자인의 체크카드\n• 내 마음대로 설정하는 계좌 이름과 색상\n\n■ 눈에 보이는 혜택\n• 복잡한 가입 조건이나 우대 조건 없이, 누구에게나 경쟁력있는 금리와 혜택 제공\n• 늘어나는 이자를 실시간으로 확인할 수 있는 정기예금\n• 만 19세 이상 대한민국 국민의 90%가 신청 가능한 비상금대출(소액 마이너스대출)\n\n■ 카카오프렌즈와 함께하는 26주적금\n• 천원부터 차곡차곡 26주동안 매주 쌓는 적금\n• 카카오프렌즈 응원과 함께하면 어느덧 만기 달성이 눈앞에!\n\n■ 알아서 차곡차곡 모아주는 저금통\n• 원하는 모으기 규칙 선택으로 부담없이 저축하기\n• 평소에는 귀여운 아이템으로, 엿보기 기능으로 잔액 확인\n\n■ 함께쓰고 같이보는 모임통장\n• 손쉽게 카카오톡 친구들을 멤버로 초대 \n• 잔액과 입출금 현황을 멤버들과 함께 보기 \n• 위트있는 메시지카드로 회비 요청\n\n■ 소중한 ‘내 신용정보’ 관리\n• 제1금융권에서 안전하게 무료로 내 신용정보 확인\n• 신용 변동내역 발생 시 알림 서비스 및 신용정보 관리 꿀팁 제공\n\n■ 파격적인 수수료로 해외송금\n• 365일 언제 어디서든 이용가능한 해외송금 (보내기 및 받기)\n• 해외계좌 및 웨스턴유니온(WU)을 통해 전세계 200여 개국으로 해외송금 가능\n• 거래외국환은행 지정, 연장 업무도 지점방문없이 모바일에서 신청 가능 \n\n■ 카카오뱅크에서 만나는 제휴서비스\n• 증권사 주식계좌도 간편하게 개설 가능\n• 프렌즈 캐릭터가 함께하는 제휴 신용카드 신청 가능\n\n■ 이체수수료 및 입출금 수수료 면제\n• 타행 이체 및 자동이체 수수료 면제\n• 국내 모든 ATM(은행, 제휴 VAN사 기기) 입금/출금/이체 수수료 면제\n\n* ATM/CD기 입금/출금/이체 수수료는 향후 정책에 따라 변경될 수 있습니다. 정책이 변경되는 경우 시행 1개월 전에 카카오뱅크 앱 및 홈페이지를 통해 미리 알려드립니다.\n\n■ 고객센터 운영 시간 안내\n• 예/적금, 대출, 카드 문의 : 1599-3333 (09:00 ~ 22:00 365일)\n• 전월세 보증금 대출, 외환 문의 : 1599-3333 (09:00 ~ 18:00 평일)\n• 사고 신고 : 1599-8888 (24시간 365일)\n\n■ 챗봇 운영 시간 안내\n• 카카오톡 플러스친구 \"카카오뱅크 고객센터\" (24시간 365일)\n\n■ 카카오뱅크 앱 이용을 위한 권한 및 목적 안내\n• 카메라(선택) : 신분증 촬영 및 서류 제출, 영상통화, 프로필 사진 등록\n• 사진(선택) : 이체⁄송금⁄출금 확인증, 카드매출전표 저장\n• 위치(선택) : 부정가입방지 및 부정거래탐지\n\n * 선택 접근권한은 동의하지 않아도 서비스를 이용하실 수 있습니다.",
                 screenshots: [
                    URL(string: "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/32/75/33/32753347-f4c1-9ae3-5684-4f813966b014/b6fb0ae9-d369-449e-9f7e-06eef64aa228_ios_5.5_01.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/cb/3c/17/cb3c17bb-7179-1ce0-0d4e-92fd24c1b06e/2b26e36d-625a-4af3-a50b-766705b310ed_ios_5.5_02.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/58/ce/2f/58ce2fef-1f13-90c8-e51f-a363ae70405f/deb9a7d2-e6c4-4d92-9262-8d1d19f52b90_ios_5.5_03.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/4a/a5/e5/4aa5e5d6-2209-2fee-cfc7-4c36b137a9f5/1d352f72-5f46-46d0-8b81-b7c8d6a04423_ios_5.5_04.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/8d/28/4e/8d284ecd-ef85-c9f3-7bfd-9a4bc3182009/243bf285-4cce-4e49-bd15-a5d47d469052_ios_5.5_05.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/cb/d7/d6/cbd7d628-5333-a2b3-996c-3889e66ee830/56349702-7c87-4297-a53c-b47eb9ab1690_ios_5.5_06.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/74/6b/4c/746b4c12-ef16-25b0-cf5f-5fe4e4ffea0f/6b12a869-5c69-405e-b626-46bef2dae1e5_ios_5.5_07.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/d3/33/58/d33358b3-4fb8-74e8-8c7e-10f027fec0f3/c308dc22-5794-46c3-85c4-2f209ba89088_ios_5.5_08.png/392x696bb.png"),
                    URL(string:"https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/d4/89/57/d48957f0-0ced-a9b4-c41f-d1b41a0407e3/16822cfa-b67a-406b-8603-b19ea4ecd09d_ios_5.5_09.png/392x696bb.png")
                 ].compactMap({ $0 }),
                 rating: 3.356289999999999995594635038287,
                 ratingCount: 11172,
                 contentAdvisoryRating: "4+",
                 genre: "금융",
                 sellerName: "카카오뱅크",
                 releaseNote: "● 전월세보증금 대출 갈아타기 출시 (9/13 오픈)\n- 기존 대출 해지 없이 새로운 전월세보증금 대출을 조회하고 갈아탈 수 있어요.\n- 살고 있는 집의 보증금이 오르거나 이사를 가는 경우에도 신청이 가능해요.\n\n● 사용성 개선\n- 더욱 편리한 서비스 제공을 위해 기능 개선 및 불편점 해소 작업도 함께 진행했어요."
        )
    }
}

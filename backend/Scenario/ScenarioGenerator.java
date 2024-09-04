package 솔라마_예시;

import java.util.*;

public class ScenarioGenerator {

    private static final Random random = new Random();

    private static final String[] Person = {"노가빈", "이종문", "조준희", "김현래", "이지희", "김유정", "안정길", "김태민", "김민섭", "원석규", "정석진", "한윤지", "이미림", "허성준", "이수린", "박범수", "조강민", "김주원", "이시우", "한재경", "김동빈", "이민선", "유준선", "이승희"};
    private static final String[] Person_Role = {"주인공", "여주인공", "경쟁자", "배신자", "조력자", "멘토", "악당", "히어로", "반란군", "유머러스한 조연", "여신", "영웅", "희생자", "잠입자", "정보 제공자", "중재자", "복수자", "악녀", "지혜자", "전략가", "혁명가", "연인", "탐정", "조연", "이방인"};
    private static final String[] Person_Info = {"착한", "똑똑한", "코드를 잘하는", "창의적인", "성실한", "호기심이 많은", "활발한", "리더십이 있는", "인내심이 강한", "유머가 있는", "협동적인", "냉철한", "사교적인", "논리적인", "신중한", "겸손한", "성격이 급한", "책임감이 강한", "진지한", "소심한", "다정한", "대담한", "정직한", "편안한", "정열적인"};
    private static final String[] Object = {"책", "컴퓨터", "가방", "전화기", "식탁", "의자", "커튼", "시계", "컵", "테이블", "모니터", "볼펜", "노트", "냉장고", "스탠드", "테레비전", "침대", "소파", "옷장", "책장", "카메라", "스피커", "리모컨"};
    private static final String[] Object_Act = {"갈등이 생기는 원인이 된다", "문제가 해결되는데 결정적인 역할을 한다", "주인공의 목표를 달성하는 데 사용된다", "중요한 단서를 제공한다", "주인공의 성장에 기여한다", "스토리의 전개를 이끈다", "갈등을 해결하는 열쇠가 된다", "주인공의 상징적인 존재가 된다", "스토리의 클라이맥스를 형성한다", "감정적인 터닝 포인트를 만든다", "주인공의 결정을 촉발시킨다", "기타 인물들과의 관계를 변화시킨다", "스토리의 배경을 형성한다", "주인공의 도전에 중요한 역할을 한다", "주인공의 과거를 드러낸다", "스토리의 시작과 끝을 연결한다", "상황의 긴장감을 높인다", "주인공의 행동을 유도한다", "문제를 복잡하게 만든다", "주인공의 목표를 방해한다", "주인공의 승리를 확립한다", "스토리의 분위기를 조성한다", "주인공의 희망을 상징한다", "스토리의 전환점을 만든다"};
    private static final String[] Place = {"사막", "자취방", "편의점", "도서관", "카페", "바닷가", "산", "공원", "학교", "병원", "호텔", "극장", "마트", "놀이공원", "사무실", "이발소", "교회", "헬스장", "미술관", "박물관", "택시 정류장", "지하철 역", "피트니스 센터", "레스토랑", "클럽", "스키장", "해변", "전시장"};
    private static final String[] Situation = {"사고가 나서 사람이 죽는다", "주인공이 비밀을 발견한다", "갈등이 극에 달해 결투가 벌어진다", "주인공이 중요한 결정을 내린다", "적의 계획이 드러난다", "주인공이 사랑에 빠진다", "대재앙이 발생한다", "주인공이 예기치 않은 도움을 받는다", "비밀이 밝혀진다", "주인공이 배신당한다", "위험한 여행을 떠난다", "주인공이 팀을 형성한다", "중요한 정보를 얻는다", "적의 함정에 빠진다", "주인공이 큰 성공을 거둔다", "위기에 처한 인물을 구한다", "주인공이 과거를 회상한다", "적과의 대화에서 중요한 정보가 나온다", "주인공이 희생을 감수한다", "사람들이 반란을 일으킨다", "주인공이 중요한 목표를 달성한다", "위험한 상황에서 탈출한다", "주인공이 적의 음모를 저지한다", "상황이 급변한다", "주인공이 새로운 동맹을 만난다"};
    private static final String[] End = {"주인공이 세상을 구합니다", "주인공이 악당을 물리칩니다", "모든 갈등이 해결됩니다", "주인공이 사랑을 얻습니다", "주인공이 예상치 못한 희생을 치릅니다", "적의 계획이 실패합니다", "주인공이 새로운 시작을 맞이합니다", "주인공이 자신을 찾습니다", "주인공이 중요한 교훈을 배웁니다", "모든 인물이 행복하게 살아갑니다", "주인공이 복수를 완수합니다", "갈등의 원인이 밝혀집니다", "주인공이 꿈을 이룹니다", "주인공이 권력을 얻습니다", "모든 인물이 화해합니다", "주인공이 자신의 과거를 정리합니다", "적이 교훈을 얻고 개과천선합니다", "주인공이 독립적인 존재가 됩니다", "주인공이 친구들과 함께 새 삶을 시작합니다", "주인공이 숨겨진 진실을 밝혀냅니다", "주인공이 큰 상을 받습니다", "모든 문제들이 해결됩니다", "주인공이 역사에 길이 남는 업적을 이룹니다", "주인공이 내면의 평화를 찾습니다", "주인공이 고독한 삶을 살아가게 됩니다", "미래가 불확실하게 열려 있습니다", "주인공이 비극적인 결말을 맞이합니다"};

    public static void main(String[] args) {
        // 선택된 요소들을 저장하는 리스트
        List<String> usedPersons = new ArrayList<>();
        List<String> usedObjects = new ArrayList<>();
        List<String> usedSituations = new ArrayList<>();
        
        // 랜덤하게 선택된 요소들
        String person = getRandomUniqueElement(Person, usedPersons);
        String personInfo = getRandomElement(Person_Info);
        String place = getRandomElement(Place);
        String end = getRandomElement(End);
        
        // 역할 문구 생성
        StringBuilder roleText = new StringBuilder();
        int roleCount = random.nextInt(5);
        for (int i = 0; i < roleCount; i++) {
            String role = getRandomElement(Person_Role);
            String rolePerson = getRandomUniqueElement(Person, usedPersons);
            String roleInfo = getRandomElement(Person_Info);
            roleText.append(role).append(" 역할로 ").append(rolePerson).append("이(가) 나오며, ").append(roleInfo).append(" 사람이야. ");
        }
        
        // 오브젝트 문구 생성
        StringBuilder objectActText = new StringBuilder();
        int objectCount = random.nextInt(5);
        for (int i = 0; i < objectCount; i++) {
            String object = getRandomUniqueElement(Object, usedObjects);
            String objectAct = getRandomElement(Object_Act);
            objectActText.append(object).append("이(가) ").append(objectAct).append(". ");
        }
        
        // 상황 문구 생성
        StringBuilder situationText = new StringBuilder();
        int situationCount = random.nextInt(5);
        for (int i = 0; i < situationCount; i++) {
            String situation = getRandomUniqueElement(Situation, usedSituations);
            situationText.append(situation).append("는 상황이 발생해. ");
        }

        // 결과 출력
        System.out.println("이야기를 만들어줘. ");
        System.out.println("주인공은 " + person + "이고, " + personInfo + " 사람이야. ");
        System.out.println(roleText.toString());
        System.out.println(objectActText.toString());
        System.out.println(place + "를 배경으로 해줘. ");
        System.out.println(situationText.toString());
        System.out.println(end + "는 결말로 마무리 해줘. ");
        System.out.println("이야기를 만들어줘. ");
    }

    private static String getRandomElement(String[] array) {
        int index = random.nextInt(array.length);
        return array[index];
    }

    private static String getRandomUniqueElement(String[] array, List<String> usedList) {
        List<String> availableList = new ArrayList<>(Arrays.asList(array));
        availableList.removeAll(usedList);
        if (availableList.isEmpty()) {
            throw new IllegalStateException("No unique elements available.");
        }
        String element = getRandomElement(availableList.toArray(new String[0]));
        usedList.add(element);
        return element;
    }
}

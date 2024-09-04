package �ֶ�_����;

import java.util.*;

public class ScenarioGenerator {

    private static final Random random = new Random();

    private static final String[] Person = {"�밡��", "������", "������", "������", "������", "������", "������", "���¹�", "��μ�", "������", "������", "������", "�̸̹�", "�㼺��", "�̼���", "�ڹ���", "������", "���ֿ�", "�̽ÿ�", "�����", "�赿��", "�̹μ�", "���ؼ�", "�̽���"};
    private static final String[] Person_Role = {"���ΰ�", "�����ΰ�", "������", "�����", "������", "����", "�Ǵ�", "�����", "�ݶ���", "���ӷ����� ����", "����", "����", "�����", "������", "���� ������", "������", "������", "�ǳ�", "������", "������", "����", "����", "Ž��", "����", "�̹���"};
    private static final String[] Person_Info = {"����", "�ȶ���", "�ڵ带 ���ϴ�", "â������", "������", "ȣ����� ����", "Ȱ����", "�������� �ִ�", "�γ����� ����", "���Ӱ� �ִ�", "��������", "��ö��", "�米����", "������", "������", "�����", "������ ����", "å�Ӱ��� ����", "������", "�ҽ���", "������", "�����", "������", "�����", "��������"};
    private static final String[] Object = {"å", "��ǻ��", "����", "��ȭ��", "��Ź", "����", "Ŀư", "�ð�", "��", "���̺�", "�����", "����", "��Ʈ", "�����", "���ĵ�", "�׷�����", "ħ��", "����", "����", "å��", "ī�޶�", "����Ŀ", "������"};
    private static final String[] Object_Act = {"������ ����� ������ �ȴ�", "������ �ذ�Ǵµ� �������� ������ �Ѵ�", "���ΰ��� ��ǥ�� �޼��ϴ� �� ���ȴ�", "�߿��� �ܼ��� �����Ѵ�", "���ΰ��� ���忡 �⿩�Ѵ�", "���丮�� ������ �̲���", "������ �ذ��ϴ� ���谡 �ȴ�", "���ΰ��� ��¡���� ���簡 �ȴ�", "���丮�� Ŭ���̸ƽ��� �����Ѵ�", "�������� �ʹ� ����Ʈ�� �����", "���ΰ��� ������ �˹߽�Ų��", "��Ÿ �ι������ ���踦 ��ȭ��Ų��", "���丮�� ����� �����Ѵ�", "���ΰ��� ������ �߿��� ������ �Ѵ�", "���ΰ��� ���Ÿ� �巯����", "���丮�� ���۰� ���� �����Ѵ�", "��Ȳ�� ���尨�� ���δ�", "���ΰ��� �ൿ�� �����Ѵ�", "������ �����ϰ� �����", "���ΰ��� ��ǥ�� �����Ѵ�", "���ΰ��� �¸��� Ȯ���Ѵ�", "���丮�� �����⸦ �����Ѵ�", "���ΰ��� ����� ��¡�Ѵ�", "���丮�� ��ȯ���� �����"};
    private static final String[] Place = {"�縷", "�����", "������", "������", "ī��", "�ٴ尡", "��", "����", "�б�", "����", "ȣ��", "����", "��Ʈ", "���̰���", "�繫��", "�̹߼�", "��ȸ", "�ｺ��", "�̼���", "�ڹ���", "�ý� ������", "����ö ��", "��Ʈ�Ͻ� ����", "�������", "Ŭ��", "��Ű��", "�غ�", "������"};
    private static final String[] Situation = {"��� ���� ����� �״´�", "���ΰ��� ����� �߰��Ѵ�", "������ �ؿ� ���� ������ ��������", "���ΰ��� �߿��� ������ ������", "���� ��ȹ�� �巯����", "���ΰ��� ����� ������", "������� �߻��Ѵ�", "���ΰ��� ����ġ ���� ������ �޴´�", "����� ��������", "���ΰ��� ��Ŵ��Ѵ�", "������ ������ ������", "���ΰ��� ���� �����Ѵ�", "�߿��� ������ ��´�", "���� ������ ������", "���ΰ��� ū ������ �ŵд�", "���⿡ ó�� �ι��� ���Ѵ�", "���ΰ��� ���Ÿ� ȸ���Ѵ�", "������ ��ȭ���� �߿��� ������ ���´�", "���ΰ��� ����� �����Ѵ�", "������� �ݶ��� ����Ų��", "���ΰ��� �߿��� ��ǥ�� �޼��Ѵ�", "������ ��Ȳ���� Ż���Ѵ�", "���ΰ��� ���� ���� �����Ѵ�", "��Ȳ�� �޺��Ѵ�", "���ΰ��� ���ο� ������ ������"};
    private static final String[] End = {"���ΰ��� ������ ���մϴ�", "���ΰ��� �Ǵ��� ����Ĩ�ϴ�", "��� ������ �ذ�˴ϴ�", "���ΰ��� ����� ����ϴ�", "���ΰ��� ����ġ ���� ����� ġ���ϴ�", "���� ��ȹ�� �����մϴ�", "���ΰ��� ���ο� ������ �����մϴ�", "���ΰ��� �ڽ��� ã���ϴ�", "���ΰ��� �߿��� ������ ���ϴ�", "��� �ι��� �ູ�ϰ� ��ư��ϴ�", "���ΰ��� ������ �ϼ��մϴ�", "������ ������ �������ϴ�", "���ΰ��� ���� �̷�ϴ�", "���ΰ��� �Ƿ��� ����ϴ�", "��� �ι��� ȭ���մϴ�", "���ΰ��� �ڽ��� ���Ÿ� �����մϴ�", "���� ������ ��� ����õ���մϴ�", "���ΰ��� �������� ���簡 �˴ϴ�", "���ΰ��� ģ����� �Բ� �� ���� �����մϴ�", "���ΰ��� ������ ������ �������ϴ�", "���ΰ��� ū ���� �޽��ϴ�", "��� �������� �ذ�˴ϴ�", "���ΰ��� ���翡 ���� ���� ������ �̷�ϴ�", "���ΰ��� ������ ��ȭ�� ã���ϴ�", "���ΰ��� ���� ���� ��ư��� �˴ϴ�", "�̷��� ��Ȯ���ϰ� ���� �ֽ��ϴ�", "���ΰ��� ������� �ḻ�� �����մϴ�"};

    public static void main(String[] args) {
        // ���õ� ��ҵ��� �����ϴ� ����Ʈ
        List<String> usedPersons = new ArrayList<>();
        List<String> usedObjects = new ArrayList<>();
        List<String> usedSituations = new ArrayList<>();
        
        // �����ϰ� ���õ� ��ҵ�
        String person = getRandomUniqueElement(Person, usedPersons);
        String personInfo = getRandomElement(Person_Info);
        String place = getRandomElement(Place);
        String end = getRandomElement(End);
        
        // ���� ���� ����
        StringBuilder roleText = new StringBuilder();
        int roleCount = random.nextInt(5);
        for (int i = 0; i < roleCount; i++) {
            String role = getRandomElement(Person_Role);
            String rolePerson = getRandomUniqueElement(Person, usedPersons);
            String roleInfo = getRandomElement(Person_Info);
            roleText.append(role).append(" ���ҷ� ").append(rolePerson).append("��(��) ������, ").append(roleInfo).append(" ����̾�. ");
        }
        
        // ������Ʈ ���� ����
        StringBuilder objectActText = new StringBuilder();
        int objectCount = random.nextInt(5);
        for (int i = 0; i < objectCount; i++) {
            String object = getRandomUniqueElement(Object, usedObjects);
            String objectAct = getRandomElement(Object_Act);
            objectActText.append(object).append("��(��) ").append(objectAct).append(". ");
        }
        
        // ��Ȳ ���� ����
        StringBuilder situationText = new StringBuilder();
        int situationCount = random.nextInt(5);
        for (int i = 0; i < situationCount; i++) {
            String situation = getRandomUniqueElement(Situation, usedSituations);
            situationText.append(situation).append("�� ��Ȳ�� �߻���. ");
        }

        // ��� ���
        System.out.println("�̾߱⸦ �������. ");
        System.out.println("���ΰ��� " + person + "�̰�, " + personInfo + " ����̾�. ");
        System.out.println(roleText.toString());
        System.out.println(objectActText.toString());
        System.out.println(place + "�� ������� ����. ");
        System.out.println(situationText.toString());
        System.out.println(end + "�� �ḻ�� ������ ����. ");
        System.out.println("�̾߱⸦ �������. ");
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

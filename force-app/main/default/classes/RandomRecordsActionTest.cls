@IsTest
public class RandomRecordsActionTest {
    private static String getFakeId(Schema.SObjectType sot, Integer i) {
      String result = String.valueOf(i);
      return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    private static List<RandomRecordsAction.RandomRecordsAction_ActionInput> generateActionInputs(Decimal percentage, Integer size) {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> inputs = new List<RandomRecordsAction.RandomRecordsAction_ActionInput>();
        RandomRecordsAction.RandomRecordsAction_ActionInput input = new RandomRecordsAction.RandomRecordsAction_ActionInput();
        input.percentage = percentage;
        input.records = new List<SObject>();
        for (Integer i=0; i<size; i++) {
            input.records.add(new Account(Id=getFakeId(Schema.Account.SObjectType, i)));
        }
        inputs.add(input);
        return inputs;
    }

    static RandomRecordsAction.RandomRecordsAction_ActionOutput executeAndGetOutput(List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs) {
        List<RandomRecordsAction.RandomRecordsAction_ActionOutput> actionOutputs = RandomRecordsAction.execute(actionInputs);
        RandomRecordsAction.RandomRecordsAction_ActionOutput actionOutput = actionOutputs[0];
        return actionOutput;
    }

    @IsTest
    static void testGenerator() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(0.1, 100);
        System.assertEquals(0.1, actionInputs[0].percentage);
        System.assertEquals(100, actionInputs[0].records.size());
    }

    @IsTest
    static void testInvalidRandom1() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(1.5, 0);
        actionInputs[0].random = 0;
        try {
            RandomRecordsAction.execute(actionInputs);
            System.assert(false, 'Expected exception');
        } catch (Exception e) {
            System.assert(true, 'Expected exception');
        }
    }

    @IsTest
    static void testInvalidRandom2() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(1.5, 0);
        actionInputs[0].random = 1;
        try {
            RandomRecordsAction.execute(actionInputs);
            System.assert(false, 'Expected exception');
        } catch (Exception e) {
            System.assert(true, 'Expected exception');
        }
    }

    @IsTest
    static void testInvalidRandom3() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(1.5, 0);
        actionInputs[0].random = null;
        try {
            RandomRecordsAction.execute(actionInputs);
            System.assert(false, 'Expected exception');
        } catch (Exception e) {
            System.assert(true, 'Expected exception');
        }
    }

    @IsTest
    static void testInvalidPercentage1() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(1.5, 0);
        try {
            RandomRecordsAction.execute(actionInputs);
            System.assert(false, 'Expected exception');
        } catch (Exception e) {
            System.assert(true, 'Expected exception');
        }
    }

    @IsTest
    static void testInvalidPercentage2() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(-1.5, 0);
        try {
            RandomRecordsAction.execute(actionInputs);
            System.assert(false, 'Expected exception');
        } catch (Exception e) {
            System.assert(true, 'Expected exception');
        }
    }

    @IsTest
    static void testNoRecords() {
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(generateActionInputs(0.5, 0));
        System.assertEquals(0, output.records.size());
    }

    @IsTest
    static void testOneRecords() {
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(generateActionInputs(0.5, 1));
        System.assertEquals(1, output.records.size());
    }

    @IsTest
    static void testSmallPercentage1() {
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(generateActionInputs(0.01, 5));
        System.assertEquals(0, output.records.size());
    }

    @IsTest
    static void testSmallPercentage2() {
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(generateActionInputs(0.001, 50));
        System.assertEquals(0, output.records.size());
    }

    @IsTest
    static void testPick10Accounts() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(0.1, 100);
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(actionInputs);
        System.assertEquals(10, output.records.size());
    }

    @IsTest
    static void testPick700Accounts() {
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(generateActionInputs(0.7, 1000));
        System.assertEquals(700, output.records.size());
    }

    @IsTest
    static void testPick700AccountsWithCustomRandom() {
        List<RandomRecordsAction.RandomRecordsAction_ActionInput> actionInputs = generateActionInputs(0.7, 1000);
        actionInputs[0].random = 0.8;
        RandomRecordsAction.RandomRecordsAction_ActionOutput output = executeAndGetOutput(actionInputs);
        System.assertEquals(700, output.records.size());
    }
}

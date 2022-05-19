List<Account> accounts = [SELECT Id, Name FROM Account];
List<RandomRecordsAction.RandomRecordsAction_ActionInput> inputs = new List<RandomRecordsAction.RandomRecordsAction_ActionInput>();
RandomRecordsAction.RandomRecordsAction_ActionInput input = new RandomRecordsAction.RandomRecordsAction_ActionInput();
input.input.percentage = 0.1;
input.input.records = accounts;
input.input.random = 0.7;
inputs.add(input);

List<RandomRecordsAction.RandomRecordsAction_ActionOutput> outputs = RandomRecordsAction.execute(inputs);
RandomRecordsAction.RandomRecordsAction_ActionOutput output = outputs[0];
for (SObject s : output.output.records) {
    System.debug(((Account)s).Name);
}
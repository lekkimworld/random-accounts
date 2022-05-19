public class RandomRecordsActionInput {
    @AuraEnabled
    public List<SObject> records;

    @AuraEnabled
    public Decimal percentage = 0.5;

    @AuraEnabled
    public Decimal random = 0.5;
}
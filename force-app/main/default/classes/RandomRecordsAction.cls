public class RandomRecordsAction {
    
    @InvocableMethod(label='Get random set of records')
    public static List<RandomRecordsAction_ActionOutput> execute(List<RandomRecordsAction_ActionInput> actionInputs) {
        final List<RandomRecordsAction_ActionOutput> results = new List<RandomRecordsAction_ActionOutput>();
        for (RandomRecordsAction_ActionInput actionInput : actionInputs) {
            // validate input
            if (actionInput.percentage > 1 || actionInput.percentage < 0) throw new RandomRecordsActionException();
            if (null == actionInput.random || actionInput.random < 0 || actionInput.random >= 1) throw new RandomRecordsActionException();

            // create result
            final RandomRecordsAction_ActionOutput result = new RandomRecordsAction_ActionOutput();
            if (actionInput.records.size() <= 1) {
                // 0 or 1 record so nothing really to select from - just return records
                result.records = actionInput.records;
            } else if ((Decimal)actionInput.records.size() * actionInput.percentage < 0.5) {
                // the percentage is so small we would never select any one record
                result.records = new List<SObject>();
            } else {
                // calc number of records to select
                final integer selectCount = (Integer)Math.ceil((Decimal)actionInput.records.size() * actionInput.percentage);
                if (selectCount < 1) {
                    // safety valve - shouldn't happen
                    throw new RandomRecordsActionException();
                }
                result.records = selectRecords(actionInput.records, selectCount, actionInput.random);
            }

            // add result
            results.add(result);
        }

        // return
        return results;
    }

    private static List<SObject> selectRecords(List<SObject> records, Integer selectCount, Decimal random) {
        final Map<Id, SObject> result = new Map<Id, SObject>();
        while (result.size() < selectCount) {
            for (SObject r : records) {
                if (result.size() >= selectCount) break;
                if (result.containsKey((r.Id))) continue;
                if (Math.random() > random) result.put(r.Id, r);
            }
        }
        return result.values();
    }
    

    public class RandomRecordsAction_ActionInput {
        @InvocableVariable(label='Records Input' required=true)
        public List<SObject> records;

        @InvocableVariable(label='Percentage' required=true)
        public Decimal percentage;

        @InvocableVariable(label='Random cutoff, Math.random() must be bigger than' required=false)
        public Decimal random = 0.5;
    }

    public class RandomRecordsAction_ActionOutput {
        @InvocableVariable(label='Records Output' required=true)
        public List<SObject> records;
    }

    public class RandomRecordsActionException extends Exception {}
}

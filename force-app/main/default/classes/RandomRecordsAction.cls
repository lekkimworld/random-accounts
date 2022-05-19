public class RandomRecordsAction {
    
    @InvocableMethod(label='Get random set of records')
    public static List<RandomRecordsAction_ActionOutput> execute(List<RandomRecordsAction_ActionInput> actionInputs) {
        final List<RandomRecordsAction_ActionOutput> results = new List<RandomRecordsAction_ActionOutput>();
        for (RandomRecordsAction_ActionInput actionInput : actionInputs) {
            // validate input
            if (actionInput.input.percentage > 1 || actionInput.input.percentage < 0) throw new RandomRecordsActionException();
            if (null == actionInput.input.random || actionInput.input.random < 0 || actionInput.input.random >= 1) throw new RandomRecordsActionException();

            // create result
            final RandomRecordsAction_ActionOutput result = new RandomRecordsAction_ActionOutput();
            if (actionInput.input.records.size() <= 1) {
                // 0 or 1 record so nothing really to select from - just return records
                result.output.records = actionInput.input.records;
            } else if ((Decimal)actionInput.input.records.size() * actionInput.input.percentage < 0.5) {
                // the percentage is so small we would never select any one record
                result.output.records = new List<SObject>();
            } else {
                // calc number of records to select
                final integer selectCount = (Integer)Math.ceil((Decimal)actionInput.input.records.size() * actionInput.input.percentage);
                if (selectCount < 1) {
                    // safety valve - shouldn't happen
                    throw new RandomRecordsActionException();
                }
                result.output.records = selectRecords(actionInput.input.records, selectCount, actionInput.input.random);
            }

            // add result
            results.add(result);
        }

        // return
        return results;
    }

    private static List<SObject> selectRecords(List<SObject> records, Integer selectCount, Decimal random) {
        final Map<Id, SObject> result = new Map<Id, SObject>();
        System.debug(selectCount);
        while (result.size() < selectCount) {
            for (SObject r : records) {
                if (result.size() >= selectCount) break;
                if (result.containsKey((r.Id))) continue;
                if (Math.random() > random) result.put(r.Id, r);
            }
        }
        System.debug(result.values().size());
        return result.values();
    }
    

    public class RandomRecordsAction_ActionInput {
        @InvocableVariable(label='Random Records Input' required=true)
        public RandomRecordsActionInput input = new RandomRecordsActionInput();
    }
    public class RandomRecordsAction_ActionOutput {
        @InvocableVariable(label='Random Records Output' required=true)
        public RandomRecordsActionOutput output = new RandomRecordsActionOutput();
    }

    public class RandomRecordsActionException extends Exception {}
}

trigger LocationVerify on Location_Address_Book__c (after insert, after update) {
 
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Location_Address_Book__c loc : Trigger.New) {
                if (loc.Name != null) {
                    LocationVerifyAPI.dofuture(loc.Id);
                }
            }
        }
    }
}
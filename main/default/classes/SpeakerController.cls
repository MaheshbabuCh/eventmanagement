public with sharing class SpeakerController {
    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> getSpeakers() {
        return [SELECT Id, Name, Email__c, Phone__c, Profile_URL__c, About_Me__c FROM Speaker__c];
    }
}

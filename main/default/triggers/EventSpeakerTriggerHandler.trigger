trigger EventSpeakerTriggerHandler on Event_Speaker__c (before insert, before update) {


      if(trigger.isBefore){
          if(Trigger.isInsert || Trigger.isUpdate){
              EventSpeakerTriggerHandler.validateDuplicateSpeaker(Trigger.new);
           }
       }
}
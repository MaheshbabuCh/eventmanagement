trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {
    
  if(trigger.isAfter){
      if(trigger.isInsert){
          EventAttendeeTriggerHandler.sendConfirmationEmails(Trigger.new);
      }
  }
}
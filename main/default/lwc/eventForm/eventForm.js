import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'; // Import NavigationMixin
import EVENT_OBJECT from '@salesforce/schema/Event__c';
import NAME_FIELD from '@salesforce/schema/Event__c.Name';
import ORGANIZER_FIELD from '@salesforce/schema/Event__c.Event_Organizer__c';
import START_DATE_FIELD from '@salesforce/schema/Event__c.Start_Date__c';
import END_DATE_FIELD from '@salesforce/schema/Event__c.End_Date__c';
import MAX_ATTENDEES_FIELD from '@salesforce/schema/Event__c.Max_Seats__c';
import EVENT_DETAIL_FIELD from '@salesforce/schema/Event__c.Event_Detail__c';

export default class EventForm extends NavigationMixin(LightningElement) { // Use NavigationMixin
    @track eventName = '';
    @track organizer = '';
    @track startDate = '';
    @track endDate = '';
    @track maxAttendees = 0;
    @track eventDetail = '';

    // Handling input changes and updating tracked variables
    handleInputChange(event) {
    const field = event.target.dataset.id;
    if (field === 'Name') {
        this.eventName = event.target.value;
    } else if (field === 'Event_Organizer__c') {
        this.organizer = event.target.value;
    } else if (field === 'Start_Date__c') {
        this.startDate = event.target.value;
    } else if (field === 'End_Date__c') {
        this.endDate = event.target.value;
    } else if (field === 'Max_Seats__c') {
        this.maxAttendees = event.target.value;
    } else if (field === 'Event_Detail__c') {
        this.eventDetail = event.target.value;
    }
}


    // Method to create the Event record
    createEventRecord() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.eventName;
        fields[ORGANIZER_FIELD.fieldApiName] = this.organizer;
        fields[START_DATE_FIELD.fieldApiName] = this.startDate;
        fields[END_DATE_FIELD.fieldApiName] = this.endDate;
        fields[MAX_ATTENDEES_FIELD.fieldApiName] = this.maxAttendees;
        fields[EVENT_DETAIL_FIELD.fieldApiName] = this.eventDetail;

        const recordInput = { apiName: EVENT_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then((eventRecord) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Event created successfully',
                        variant: 'success',
                    })
                );
                // Redirect to the event record page after creation
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: eventRecord.id,
                        objectApiName: 'Event__c',
                        actionName: 'view',
                    },
                });
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }
}

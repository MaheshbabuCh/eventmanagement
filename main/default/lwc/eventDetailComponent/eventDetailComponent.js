// Part 1 without new button
// import { LightningElement, api } from 'lwc';

// export default class EventDetailComponent extends LightningElement {
//     @api recordId; // Event Id passed from parent component or record page
// }


import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class EventDetail extends NavigationMixin(LightningElement) {
    @api recordId; // The ID of the current Event record

    handleNewSpeaker() {
        // Prepare default values for the new Speaker record
        const defaultValues = encodeDefaultFieldValues({
            Event__c: this.recordId // Set the Event ID
        });

        // Navigate to the new Speaker record creation page
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Speaker__c', // Change to your Speaker object API name
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    handleNewAttendee() {
        // Prepare default values for the new Attendee record
        const defaultValues = encodeDefaultFieldValues({
            Event__c: this.recordId // Set the Event ID
        });

        // Navigate to the new Attendee record creation page
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Attendees__c', // Change to your Attendee object API name
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}

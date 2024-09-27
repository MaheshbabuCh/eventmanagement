// <!-- Version 1 with out search component  -->

// import { LightningElement, track, wire } from 'lwc';
// import { NavigationMixin } from 'lightning/navigation';
// import getLiveEvents from '@salesforce/apex/EventController.getLiveEvents';

// const columns = [
//     { label: 'Event Name', fieldName: 'eventLink', type: 'url', 
//       typeAttributes: { 
//           label: { fieldName: 'Name' }, 
//           target: '_self' 
//       } 
//     },
//     { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
//     { label: 'End Date', fieldName: 'End_Date__c', type: 'date' },
//     { label: 'Location', fieldName: 'Location_Address_Book__c', type: 'text' },
//     { label: 'Remaining Seats', fieldName: 'Remaining_Seats__c', type: 'number' }
// ];

// export default class EventList extends NavigationMixin(LightningElement) {
//     @track events = [];
//     @track sortedBy;
//     @track sortedDirection;
//     @track columns = columns;

//     @wire(getLiveEvents)
//     wiredEvents({ error, data }) {
//         if (data) {
//             // Modify event data for links to event detail pages
//             this.events = data.map(event => {
//                 return {
//                     ...event,
//                     eventLink: '/lightning/r/Event__c/' + event.Id + '/view'
//                 };
//             });
//         } else if (error) {
//             console.error('Error fetching events:', error);
//         }
//     }

//     handleRowAction(event) {
//         const row = event.detail.row;
//         this[NavigationMixin.Navigate]({
//             type: 'standard__recordPage',
//             attributes: {
//                 recordId: row.Id,
//                 objectApiName: 'Event__c',
//                 actionName: 'view'
//             }
//         });
//     }

//     // Sorting function for the datatable
//     updateColumnSorting(event) {
//         const { fieldName: sortedBy, sortDirection: sortedDirection } = event.detail;
//         const cloneData = [...this.events];
//         cloneData.sort(this.sortBy(sortedBy, sortedDirection === 'asc' ? 1 : -1));
//         this.events = cloneData;
//         this.sortedBy = sortedBy;
//         this.sortedDirection = sortedDirection;
//     }

//     sortBy(field, reverse, primer) {
//         const key = primer ? 
//             function(x) {return primer(x[field])} : 
//             function(x) {return x[field]};

//         return function(a, b) {
//             a = key(a);
//             b = key(b);
//             return reverse * ((a > b) - (b > a));
//         };
//     }
// }

// <!-- Version 2 with search component with padding issues -->

// import { LightningElement, track, wire } from 'lwc';
// import { NavigationMixin } from 'lightning/navigation';
// import getLiveEvents from '@salesforce/apex/EventController.getLiveEvents';

// const columns = [
//     { label: 'Event Name', fieldName: 'eventLink', type: 'url', 
//       typeAttributes: { 
//           label: { fieldName: 'Name' }, 
//           target: '_self' 
//       } 
//     },
//     { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
//     { label: 'End Date', fieldName: 'End_Date__c', type: 'date' },
//     { label: 'Location', fieldName: 'Location_Address_Book__c', type: 'text' },
//     { label: 'Remaining Seats', fieldName: 'Remaining_Seats__c', type: 'number' }
// ];

// export default class EventList extends NavigationMixin(LightningElement) {
//     @track events = [];
//     @track filteredEvents = [];
//     @track searchName = '';
//     @track searchStartDate = '';
//     @track searchLocation = '';
//     @track sortedBy;
//     @track sortedDirection;
//     @track columns = columns;

//     @wire(getLiveEvents)
//     wiredEvents({ error, data }) {
//         if (data) {
//             this.events = data.map(event => {
//                 return {
//                     ...event,
//                     eventLink: '/lightning/r/Event__c/' + event.Id + '/view'
//                 };
//             });
//             this.filteredEvents = [...this.events];
//         } else if (error) {
//             console.error('Error fetching events:', error);
//         }
//     }

//     handleSearchNameChange(event) {
//     // Safeguard against null or undefined event values
//     this.searchName = event.target.value ? event.target.value.toLowerCase() : '';
//     this.filterEvents();
// }

// handleSearchStartDateChange(event) {
//     // Safeguard against null or undefined event values
//     this.searchStartDate = event.target.value ? event.target.value : '';
//     this.filterEvents();
// }

// handleSearchLocationChange(event) {
//     // Safeguard against null or undefined event values
//     this.searchLocation = event.target.value ? event.target.value.toLowerCase() : '';
//     this.filterEvents();
// }


//     filterEvents() {
//     if (this.events.length === 0) {
//         return;
//     }

//     this.filteredEvents = this.events.filter(event => {
//         const nameMatch = this.searchName ? event.Name.toLowerCase().includes(this.searchName) : true;
//         const startDateMatch = this.searchStartDate ? event.Start_Date__c === this.searchStartDate : true;
//         const locationMatch = this.searchLocation ? event.Location_Address_Book__c.toLowerCase().includes(this.searchLocation) : true;

//         return nameMatch && startDateMatch && locationMatch;
//     });
// }


//       handleRowAction(event) {
//         const row = event.detail.row;
//         this[NavigationMixin.Navigate]({
//             type: 'standard__recordPage',
//             attributes: {
//                 recordId: row.Id,
//                 objectApiName: 'Event__c',
//                 actionName: 'view'
//             }
//         });
//     }

//     // Sorting function for the datatable
//     updateColumnSorting(event) {
//         const { fieldName: sortedBy, sortDirection: sortedDirection } = event.detail;
//         const cloneData = [...this.events];
//         cloneData.sort(this.sortBy(sortedBy, sortedDirection === 'asc' ? 1 : -1));
//         this.events = cloneData;
//         this.sortedBy = sortedBy;
//         this.sortedDirection = sortedDirection;
//     }

//     sortBy(field, reverse, primer) {
//         const key = primer ? 
//             function(x) {return primer(x[field])} : 
//             function(x) {return x[field]};

//         return function(a, b) {
//             a = key(a);
//             b = key(b);
//             return reverse * ((a > b) - (b > a));
//         };
//     }
// }

// Version 3 with location field updated 


import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getLiveEvents from '@salesforce/apex/EventController.getLiveEvents';

const columns = [
    { label: 'Event Name', fieldName: 'Name', type: 'text' },
    { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
    { label: 'End Date', fieldName: 'End_Date__c', type: 'date' },
    { label: 'Location', fieldName: 'Location_Name', type: 'text' },  // Use Location_Name instead of nested object
    { label: 'Remaining Seats', fieldName: 'Remaining_Seats__c', type: 'number' }
];



export default class EventList extends NavigationMixin(LightningElement) {
    @track events = [];
    @track filteredEvents = [];
    @track searchName = '';
    @track searchStartDate = '';
    @track searchLocation = '';
    @track sortedBy;
    @track sortedDirection;
    @track columns = columns;

    @wire(getLiveEvents)
    wiredEvents({ error, data }) {
        if (data) {
            this.events = data.map(event => {
                return {
                    ...event,
                    Location_Name: event.Location_Address_Book__r ? event.Location_Address_Book__r.Name : '',  // Safely handle nested object
                    eventLink: '/lightning/r/Event__c/' + event.Id + '/view'
                };
            });
            this.filteredEvents = [...this.events];
        } else if (error) {
            console.error('Error fetching events:', error);
        }
    }


    handleSearchNameChange(event) {
    // Safeguard against null or undefined event values
    this.searchName = event.target.value ? event.target.value.toLowerCase() : '';
    this.filterEvents();
}

handleSearchStartDateChange(event) {
    // Safeguard against null or undefined event values
    this.searchStartDate = event.target.value ? event.target.value : '';
    this.filterEvents();
}

handleSearchLocationChange(event) {
    // Safeguard against null or undefined event values
    this.searchLocation = event.target.value ? event.target.value.toLowerCase() : '';
    this.filterEvents();
}


    filterEvents() {
    if (this.events.length === 0) {
        return;
    }

    this.filteredEvents = this.events.filter(event => {
        const nameMatch = this.searchName ? event.Name.toLowerCase().includes(this.searchName) : true;
        const startDateMatch = this.searchStartDate ? event.Start_Date__c === this.searchStartDate : true;
        const locationMatch = this.searchLocation ? event.Location_Name.toLowerCase().includes(this.searchLocation) : true;  // Updated to use Location_Name

        return nameMatch && startDateMatch && locationMatch;
    });
}



      handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Event__c',
                actionName: 'view'
            }
        });
    }

    // Sorting function for the datatable
    updateColumnSorting(event) {
        const { fieldName: sortedBy, sortDirection: sortedDirection } = event.detail;
        const cloneData = [...this.events];
        cloneData.sort(this.sortBy(sortedBy, sortedDirection === 'asc' ? 1 : -1));
        this.events = cloneData;
        this.sortedBy = sortedBy;
        this.sortedDirection = sortedDirection;
    }

    sortBy(field, reverse, primer) {
        const key = primer ? 
            function(x) {return primer(x[field])} : 
            function(x) {return x[field]};

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }
}

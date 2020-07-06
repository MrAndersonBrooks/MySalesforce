import { LightningElement, wire, api, track } from 'lwc';
import { publish,MessageContext } from 'lightning/messageService';
import BoatMC from "@salesforce/messageChannel/BoatMessageChannel__c";
import getBoats from "@salesforce/apex/BoatDataService.getBoats";
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text', editable: true  },
    { label: 'Length', fieldName: 'Length__c', type: 'number', editable: true  },
    { label: 'Price', fieldName: 'Price__c', type: 'currency', editable: true  },
    { label: 'Description', fieldName: 'Description__c', type: 'text', editable: true }
];

export default class BoatSearchResults extends LightningElement {
    selectedBoatId;
    columns = columns;
    @api boatTypeId = '';
    boats;
    isLoading = false;

    @track error = undefined

    @wire(MessageContext)
    messageContext;

    @wire (getBoats, { boatTypeId: '$boatTypeId' })
    wiredBoats({data, error}) {
        if ( data ) {
            this.boats = data;            
            this.isLoading = false
        }
        if ( error ) {
            this.error = error;
            this.boats = undefined;
        }
     }
    
    // public function that updates the existing boatTypeId property
    // uses notifyLoading
    @api
    searchBoats(boatTypeId) {
        this.boatTypeId = boatTypeId;
        this.notifyLoading(true); 
     }
    
    // this public function must refresh the boats asynchronously
    // uses notifyLoading
    @api async refresh(){
        this.isLoading = true;
        this.notifyLoading(this.isLoading);
        refreshApex(this.boats);
        this.isLoading = false;
        this.notifyLoading(this.isLoading);
    }
    
    // this function must update selectedBoatId and call sendMessageService
    updateSelectedTile(event) {
        this.selectedBoatId = event.detail.boatId;
        this.sendMessageService(this.selectedBoatId); 
    }

    // Publishes the selected boat Id on the BoatMC.
    sendMessageService(boatId) { 
        const message = {
            detail: { recordId: boatId }
        };
        publish(this.messageContext, BoatMC, message);
    }
    
    // This method must save the changes in the Boat Editor
    // Show a toast message with the title
    // clear lightning-datatable draft values
    handleSave(event) {
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        
        const promises = recordInputs.map(recordInput =>
            //update boat record
            updateRecord(recordInput)
        );
        Promise.all(promises)
            .then(() => {
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Ship It!',
                        variant: 'success'
                    })
                );
                this.draftValues = [];                                
                this.refresh();
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error,
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                
            });
    }
    
    notifyLoading(isLoading) { 
        if(isLoading) {
            this.dispatchEvent(new CustomEvent('loading', {
                detail: isLoading
                })
            );
        }
        else {
            this.dispatchEvent(new CustomEvent('doneloading', {
                detail: isLoading
                })
            );
        }
    }
}

  
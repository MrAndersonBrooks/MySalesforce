import { LightningElement, api, wire} from 'lwc';
import { APPLICATION_SCOPE, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import labelAddReview from '@salesforce/label/c.Add_Review';
import labelDetails from '@salesforce/label/c.Details';
import labelFullDetails from '@salesforce/label/c.Full_Details';
import labelReviews from '@salesforce/label/c.Reviews';
import labelPleaseSelectABoat from '@salesforce/label/c.Please_select_a_boat';
import { refreshApex } from '@salesforce/apex';

import BOAT_TYPE_FIELD from '@salesforce/schema/Boat__c.BoatType__c';
import BOAT_ID_FIELD from '@salesforce/schema/Boat__c.Id';
import BOAT_DESCRIPTION_FIELD from '@salesforce/schema/Boat__c.Description__c';
import BOAT_NAME_FIELD from '@salesforce/schema/Boat__c.Name';
import BOAT_LENGTH_FIELD from '@salesforce/schema/Boat__c.Length__c';
import BOAT_PRICE_FIELD from '@salesforce/schema/Boat__c.Price__c';
const BOAT_FIELDS = [BOAT_ID_FIELD, BOAT_NAME_FIELD];

export default class BoatDetailTabs extends NavigationMixin(LightningElement) {
  @wire(MessageContext)
    messageContext;
  @api boatId;
  @wire(getRecord,{ recordId: '$boatId', fields: BOAT_FIELDS })
  wiredRecord;
  label = {
    labelDetails,
    labelReviews,
    labelAddReview,
    labelFullDetails,
    labelPleaseSelectABoat,
  };
 
  // Decide when to show or hide the icon
  // returns 'utility:anchor' or null
  get detailsTabIconName() {
      if ( this.wiredRecord ) {
        return 'utility:anchor';
      } else {
          return null;
      }
   }
  
  // Utilize getFieldValue to extract the boat name from the record wire
  get boatName() {
      return getFieldValue( this.wiredRecord.data, BOAT_NAME_FIELD );  
  }
  
  // Private
  subscription = null;
  
  // Subscribe to the message channel
  subscribeMC() {
    this.subscription = subscribe(
        this.messageContext, 
        BOATMC, 
        (message) => {
          this.boatId = message.detail['recordId'];
        }, 
        { scope: APPLICATION_SCOPE });
  }
  
  // Calls subscribeMC()
  connectedCallback() {
    this.wiredRecord = null;    
      if ( this.subscription || this.boatId ) {
        return;
      }
      if ( !this.subscription ) {
        this.subscribeMC();
      }
  }
  
  disconnectedCallback() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }
  
  // Navigates to record page
  navigateToRecordViewPage() {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.boatId,
            objectApiName: 'Boat__c',
            actionName: 'view',
        },
    });
  }
  
  // Navigates back to the review list, and refreshes reviews component
  handleReviewCreated() {
    this.template.querySelector("lightning-tabset").focus('Reviews');
    this.template.querySelector("c-boat-reviews").refresh();
  }
}
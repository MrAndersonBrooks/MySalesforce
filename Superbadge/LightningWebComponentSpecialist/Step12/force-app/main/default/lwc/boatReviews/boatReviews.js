import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllReviews from '@salesforce/apex/BoatDataService.getAllReviews';
import { refreshApex } from '@salesforce/apex';

// imports
export default class BoatReviews extends NavigationMixin(LightningElement) {
    // Private
    boatId;
    error = undefined;
    boatReviews;
    isLoading = true;
    
    // Getter and Setter to allow for logic to run on recordId change
    @api
    get recordId() {
        return this.boatId;
    }
    set recordId(value) {
        console.log('boatReview');
        //sets boatId attribute
        //sets boatId assignment
        //get reviews associated with boatId
        this.boatId = value;      
        this.setAttribute('boatId', this.boatId);
        this.boatReviews = this.getReviews();
    }
    
    // Getter to determine if there are reviews to display
    get reviewsToShow() {
        if (this.boatReviews != null || this.boatReviews != undefined) {
            return true;
        } else {
            return false;
        }
     }
    
    // Public method to force a refresh of the reviews invoking getReviews
    @api refresh() { 
        refreshApex(this.boatReviews);
        return this.getReviews(this.boatId);
    }
    
    // Imperative Apex call to get reviews for given boat
    // returns immediately if boatId is empty or null
    // sets isLoading to true during the process and false when it’s completed
    // Gets all the boatReviews from the result, checking for errors.
    getReviews() {
        this.isLoading = true;
        if (!this.boatId) {
            this.boatReviews = null;
            this.isLoading = false;
            return;
        }
        getAllReviews({ boatId: this.boatId })
        .then (results => {
            this.boatReviews = results;
        })
        .catch (error => {
            this.error = error;
        }) 
        this.isLoading = false;
     }
    
    // Helper method to use NavigationMixin to navigate to a given record on click
    navigateToRecord(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.recordId,
                objectApiName: 'User',
                actionName: 'view',
            },
        });
    }
  }
  
import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// imports
const TOAST_TITLE = 'Review Created!';
const TOAST_SUCCESS_VARIANT = 'success';
export default class BoatAddReviewForm extends LightningElement {
    // Private
    boatId;
    rating;
    
    // Public Getter and Setter to allow for logic to run on recordId change
    @api
    get recordId() {
      return this.boatId;
    }
    
    set recordId(value) {
      //sets boatId attribute
      //sets boatId assignment
      this.boatId = value;      
      this.setAttribute('boatId', this.boatId);
    }
    
    // Gets user rating input from stars component
    handleRatingChanged(event) { 
      this.rating = event.detail.rating;
    }
    
    // Custom submission handler to properly set Rating
    // This function must prevent the anchor element from navigating to a URL.
    // form to be submitted: lightning-record-edit-form
    handleSubmit(event) {       
      event.preventDefault();
      const fields = event.detail.fields;
      fields.Boat__c = this.boatId;
      if(this.rating){
          fields.Rating__c = this.rating;
      }
      else{
          fields.Rating__c = 0;
      }      
      this.template.querySelector('lightning-record-edit-form').submit(fields);
  }
    
    // Shows a toast message once form is submitted successfully
    // Dispatches event when a review is created
    handleSuccess(event) {
      // TODO: dispatch the custom event and show the success message      
      this.dispatchEvent(new ShowToastEvent({
        title: TOAST_TITLE,
        message: event.detail.value,
        variant: TOAST_SUCCESS_VARIANT
      }));
      this.dispatchEvent(new CustomEvent('createreview'));
      this.handleReset();
    }
  
    // Clears form data upon submission
    // TODO: it must reset each lightning-input-field
    handleReset() { 
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

  }
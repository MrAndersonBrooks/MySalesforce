import { LightningElement, wire, track } from 'lwc';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';

 // imports
 export default class BoatSearch extends LightningElement {
    isLoading = false;
    selectedBoatId;
   　@track boatTypeId = '';
    
    // Handles loading event
    handleLoading() { }
    
    // Handles done loading event
    handleDoneLoading() { }
    
    // Handles search boat event
    // This custom event comes from the form
    searchBoats(event) { 
      this.boatTypeId = event.detail.boatTypeId;
    }
    
    createNewBoat() { }
  }
  
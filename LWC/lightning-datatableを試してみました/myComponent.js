import { LightningElement, wire } from 'lwc';
import serachRecord from '@salesforce/apex/myComponentController.serachTestRecord';
    
export default class MyComponent extends LightningElement {
    tests;
    searchWord;
    hasChanged;

    handleSearch(evt){
        this.searchWord = evt.detail;
        serachRecord({serachWord: this.searchWord})
        .then (result => {            
            this.tests = result;                        
            this.hasChanged = (this.tests.length > 0);
        })         
    }
}
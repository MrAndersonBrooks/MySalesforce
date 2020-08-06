import { LightningElement, api, wire, track } from 'lwc';
import serachRecord from '@salesforce/apex/myComponentController.serachTestRecord';
import serachName from '@salesforce/apex/myComponentController.getTestName';
import searchRecordId from '@salesforce/apex/myComponentController.serachTestRecordFromId';
import { publish, MessageContext } from 'lightning/messageService';
import TESTMS from '@salesforce/messageChannel/testMessageChannel__c';

const listviewcolumns = [
    {fieldName:'Name',label: "Name",sortable:true,editable: true},
    {fieldName:"Text__c",label: "Text__c",sortable:true,editable: true},
    {fieldName:"CheckBox__c",label: "CheckBox__c",sortable:true,editable: true, type:'boolean'},
    {fieldName:"Datetime__c",label: "Datetime__c",sortable:true,editable: true, type:'date'},
    {fieldName:"PickList__c",label: "PickList__c",sortable :true,editable: true},
];
    
export default class MyComponent extends LightningElement {
    @api records;
    @track tests;
    searchWord;
    @track hasChanged;
    @track selectOptions;
    @track error = undefined;
    value;
    columns = listviewcolumns;

    @wire(MessageContext)
    messageContext

    handleSearch(evt){
        this.searchWord = evt.detail;
        serachRecord({serachWord: this.searchWord})
        .then (result => {            
            this.tests = result;                        
            this.hasChanged = (this.tests.length > 0);
        })         
    }

    @wire (serachName)
    options ({ data, error }) {
        if ( data ) {
            this.selectOptions = data.map(rec => {
                return {
                    label: rec.Name,
                    value: rec.Id
                };
            });
        }
        if ( error ) {
            this.selectOptions = undefined;
            this.error = error;
        }
    } 

    handleSelectOptions( event ){
        this.value = event.target.value;
        const pub = { recordId: event.target.value }
        
        // searchRecordId( {recordId: this.value} )
        // .then (result => {
        //     this.tests = result;
        //     this.hasChanged = true;
            
        // })
        publish(this.messageContext,TESTMS,pub )
    }

}
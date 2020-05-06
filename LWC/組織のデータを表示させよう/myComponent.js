import { LightningElement, api , wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi'
const fields = [
    'Test1__c.Name','Test1__c.Text__c','Test1__c.Datetime__c','Test1__c.CheckBox__c','Test1__c.PickList__c'
];

export default class MyComponent extends LightningElement {
    @api recordId;
    name;
    text;
    checkbox;
    datetime;
    picklist;
    
    @wire(getRecord, { recordId: '$recordId', fields } )
     loadTest1 ({error, data}) {
        if (error) {
            // TODO: Error handling
        } else if (data) {
            this.name = data.fields.Name.value;
            this.text = data.fields.Text__c.value;
            this.checkbox = data.fields.CheckBox__c.value;
            this.datetime = data.fields.Datetime__c.value;
            this.picklist = data.fields.PickList__c.value;
        }
    }
}
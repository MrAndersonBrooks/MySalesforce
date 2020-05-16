import { LightningElement, api } from 'lwc';
const listviewcolumns = [
    {fieldName:'Name',label: "Name",sortable:true,editable: true},
    {fieldName:"Text__c",label: "Text__c",sortable:true,editable: true},
    {fieldName:"CheckBox__c",label: "CheckBox__c",sortable:true,editable: true, type:'boolean'},
    {fieldName:"Datetime__c",label: "Datetime__c",sortable:true,editable: true, type:'date'},
    {fieldName:"PickList__c",label: "PickList__c",sortable :true,editable: true},
];

export default class ListComponent extends LightningElement {
    @api tests;
    @api hasChanged;
    rowOffset = 0;
    columns = listviewcolumns;
}
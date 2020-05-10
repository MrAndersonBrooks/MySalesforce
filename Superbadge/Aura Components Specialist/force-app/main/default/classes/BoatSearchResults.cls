public with sharing class BoatSearchResults {
    
    @AuraEnabled
    public static List<BoatType__c> getBoatTypes() {
        system.debug([SELECT Id, Name FROM BoatType__c]);
        return [SELECT Id, Name FROM BoatType__c];
    }
    
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId){
        
        List<Boat__c> boats = new List<Boat__c>();
        if(boatTypeId == null || boatTypeId == ''){
            boats = [SELECT Id, Name, BoatType__c, Contact__r.Name, Picture__c, Geolocation__Latitude__s, Geolocation__Longitude__s FROM Boat__c];
        }
        else{
            boats = [SELECT Id, Name, BoatType__c, Contact__r.Name, Picture__c, Geolocation__Latitude__s, Geolocation__Longitude__s FROM Boat__c WHERE BoatType__c = :boatTypeId];
        }
        
        return boats;
    }
    
}
@RestResource(urlMapping='/case/*/close')
global with sharing class CaseCloseResource {
    @HttpPost 
    global static void closeCase(String closeReason){
        RestRequest req = RestContext.request;
        String[] uriParts = req.requestURI.split('/');
        Id caseId = uriParts[2];
        Set<Id> caseIds = new Set<Id>{caseId};
        
        CaseService.closeCases(caseIds, closeReason);
    }
}
public class BillingCalloutService {
    
    public static ServiceCredentials__c credential = ServiceCredentials__c.getInstance('BillingServiceCredential');
    
    public static void callBillingService(List<Project__c> newList,Map<Id,Project__c> oldMap){
         List<Project__c> syncProjectList = new List<Project__c>();
        
        for(Project__c project : newList){
            Project__c oldProject = oldMap.get(project.Id);
            if(project.Status__c == 'Billable' && project.Status__c != oldProject.Status__c){
                syncProjectList.add(project);
            }
        }
        callOut(JSON.serialize(syncProjectList));
        
    }
    @future(callout=true)
    public static void callOut(String jsonserialized){
        List<Project__c> projects = (List<Project__c>)JSON.deserialize(jsonserialized,List<Project__c>.class);
        List<Project__c> updateList = new List<Project__c>();
        
        for ( Project__c prj : projects ) {
            BillingServiceProxy.InvoicesPortSoap11 invoiceSoap  = new BillingServiceProxy.InvoicesPortSoap11();
            BillingServiceProxy.project proxyPrj = new BillingServiceProxy.project();
            proxyPrj.projectid = prj.ProjectRef__c;
            proxyPrj.billAmount = prj.Billable_Amount__c;
            proxyPrj.username = credential.Username__c;
            proxyPrj.password = credential.Password__c;
            String response = invoiceSoap.billProject(proxyPrj);
            
            if ( response == 'OK' ) {
                prj.Status__c = 'Billed';
                updateList.add(prj);
            }
        }
        update updateList;
    }
}
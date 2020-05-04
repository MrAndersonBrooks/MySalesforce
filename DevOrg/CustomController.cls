public class CustomController {
    
    public Test1__c conditions {get; set;}
    public List<Test1__c> resultsList{get; set;} 
    public Boolean doSearch{get; set;} 
    
    public CustomController() {
        this.conditions = new Test1__c();
        this.resultsList = new List<Test1__c>();
        this.doSearch = false;
    }
    
    public void search(){
        this.doSearch = true;
        String serchQuery = 'SELECT Text__c,CheckBox__c,Datetime__c,PickList__c FROM Test1__c ';
        
        List<String> param = new List<String>();
        param.add(' CheckBox__c = ' + this.conditions.CheckBox__c);
        if (this.conditions.Text__c != null) {
            param.add('Text__c LIKE \'%' + this.conditions.Text__c + '%\'');
        }
        if (!String.isBlank(this.conditions.PickList__c)) {
            param.add('PickList__c = \'' + this.conditions.PickList__c + '\'');
        }
        if (this.conditions.Datetime__c != null) {
            param.add('Datetime__c > ' + String.valueOf(this.conditions.Datetime__c).replace(' ','T') + '+0900');
        }
        if (!param.isEmpty()) {
            serchQuery += 'WHERE ' + String.join(param, ' AND ');
        }
        system.debug(serchQuery);
        this.resultsList = database.query(serchQuery);
    }
}
public with sharing class GlobalLookupSearch_Old {
    public List<SelectOption> lstObjects {get; set;}
    public String strSelectedObject {get; set;}
    public String searchString {get; set;}
    
    public List<Schema.FieldSetMember> lstFieldSetMembers {get; set;}
    public List<List<String>> lstResults {get; set;}
    
    private Map<String, GLookupConfig__c> mapAllConfigs;

    public void onLoad(){
        mapAllConfigs = GLookupConfig__c.getAll();
        
        lstObjects = new List<SelectOption>();
        for(String oName : mapAllConfigs.keySet()){
            SelectOption so = new SelectOption(oName, oName);
            lstObjects.add(so);
        }
        
        if(lstObjects.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No objects have been configured. Please contact your System Administrator.'));
        }
    }
    
    public void doSearch(){
        lstResults = new List<List<String>>();
        lstFieldSetMembers = null;
        
        if(searchString == null || searchString.trim().length() < 2){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a search string with at least 2 characters.'));
            return;
        }
        
        if(strSelectedObject == null || strSelectedObject.trim().length() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No object selected to search.'));
            return;
        }
        
        GLookupConfig__c config = mapAllConfigs.get(strSelectedObject);
        lstFieldSetMembers = Schema.getGlobalDescribe().get(config.Object_API_NAME__c).getDescribe().fieldSets.getMap().get(config.Field_Set_API_Name__c).getFields();
        
        String fieldList = 'Name,';
        List<String> colNames = new List<String>();
        colNames.add('Name');
        
        for(Schema.FieldSetMember f : lstFieldSetMembers){
            if(!f.fieldPath.equals('Name')){
                fieldList = fieldList + f.fieldPath + ',';
                colNames.add(f.fieldPath);
            }
        }
        if(fieldList.endsWith(',')){
            fieldList = fieldList.substring(0, fieldList.length() - 1);
        }
        
        String strQuery = 'FIND \'*' + searchString + '*\' IN ALL FIELDS RETURNING ' + config.Object_API_NAME__c + '(' + fieldList + ')';
        List<List<SObject>> searchList = search.query(strQuery);
        
        for(List<SObject> lstObj : searchList){
            for(SObject obj : lstObj){
                List<String> row = new List<String>();
                for(String c : colNames){
                    String val = (String)obj.get(c);
                    if(val == null) val = ' ';
                    
                    row.add(val);
                }
                lstResults.add(row);
            }
        }
    }

}
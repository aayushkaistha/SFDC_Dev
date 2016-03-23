public class JSON_Test {
    public String ctrlResult { get; set; }
    public String dbResult { get; set; }
    
    public List<Names__c> lstDBValues {get; set;}    
    private List<Names__c> lstLocalValues {get; set;}

    public JSON_Test(){
        lstLocalValues = new List<Names__c>();
        lstDBValues = [Select Id, Name From Names__c order by CreatedDate asc limit 10000];
        
        if(lstDBValues != null){
            lstLocalValues.addAll(lstDBValues);
        }
        
        ctrlResult = JSON.serialize(lstLocalValues);
        dbResult = JSON.serialize(lstDBValues);
    }

    public void saveAll() {
        upsert(lstLocalValues);
        
        lstDBValues = [Select Id, Name From Names__c order by CreatedDate asc limit 10000];
        
        ctrlResult = JSON.serialize(lstLocalValues);
        dbResult = JSON.serialize(lstDBValues);
    }


    public void ctrlAddName() {
        String returnVal = ApexPages.currentPage().getParameters().get('name');
        
        Names__c objNames = new Names__c(Name = returnVal);
        lstLocalValues.add(objNames);
        
        List<NamesWrapper> lstToDisplay = new List<NamesWrapper>();
        for(Names__c n : lstLocalValues){
        	NamesWrapper wrap = new NamesWrapper(n.Name);
        	lstToDisplay.add(wrap);
        }
        
        lstDBValues = [Select Id, Name From Names__c order by CreatedDate asc limit 10000];
        
        ctrlResult = JSON.serialize(lstToDisplay);
        dbResult = JSON.serialize(lstDBValues);
    }

	class NamesWrapper{
		public String name {get; set;}
		
		public NamesWrapper(String name){
			this.name = name;
		}
	}
}
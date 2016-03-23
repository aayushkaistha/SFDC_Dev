public class SOSLSearchController {
	public String searchString {get; set;}
	public List<ResultObject> results {get; set;}
	
	public void searchWebsite(){
		String searchStrEx = '*' + searchString + '*';
		List<List<SObject>> searchList = [FIND :searchStrEx IN ALL FIELDS RETURNING News_Item__c (Title__c, Content__c), Custom_Products__c (Product_Name__c, Product_Details__c)];
		List<News_Item__c> lstNI = (List<News_Item__c>)searchList[0];
		List<Custom_Products__c> lstCP = (List<Custom_Products__c>)searchList[1];
		
		results = new List<ResultObject>();
		for(News_Item__c ni : lstNI){
			ResultObject ro = new ResultObject();
			ro.title = ni.Title__c;
			ro.preview = ni.Content__c;
			
			results.add(ro);
		}
		
		for(Custom_Products__c cp : lstCP){
			ResultObject ro = new ResultObject();
			ro.title = cp.Product_Name__c;
			ro.preview = cp.Product_Details__c;
			
			results.add(ro);
		}
	}
	
	class ResultObject{
		public String title {get; set;}
		public String preview {get; set;}
	}
}
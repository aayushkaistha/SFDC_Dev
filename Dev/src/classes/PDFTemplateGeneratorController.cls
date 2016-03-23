public class PDFTemplateGeneratorController{
    public List<SelectOption> sObjectNames {get; set;}

    public PDFTemplateGeneratorController(){
        getAllSObjects();
    }

    public void getAllSObjects(){
        map<String, Schema.sObjectType> mapAllSObjects = Schema.getGlobalDescribe();
        List<Schema.sObjectType> sObjects = mapAllSObjects.values();
        
        sObjectNames = new List<SelectOption>();
        for(Schema.sObjectType soName : sObjects){
            Schema.DescribeSObjectResult soDesc = soName.getDescribe();
            
            SelectOption so = new SelectOption(soDesc.getName(), soDesc.getName());
            sObjectNames.add(so);
        }
        
        sObjectNames = sortOptionList(sObjectNames);
    }
    
    //  This is a simple quicksort algorithm to sort a SelectOption list (dropdown) by label alphabetically.    
    public static List<SelectOption> sortOptionList(List<SelectOption> ListToSort)  {
        
        if(ListToSort == null || ListToSort.size() <= 1) {
            return ListToSort;                  
        }
        
        List<SelectOption> Less = new List<SelectOption>();     
        List<SelectOption> Greater = new List<SelectOption>();  
            
        integer pivot = 0;              
        // save the pivot and remove it from the list       
        SelectOption pivotValue = ListToSort[pivot];        
        ListToSort.remove(pivot);               
        for(SelectOption x : ListToSort) {          
            if(x.getLabel().compareTo(pivotValue.getLabel()) <= 0) {
                Less.add(x);
            } else if(x.getLabel().compareTo(pivotValue.getLabel()) > 0) {
                Greater.add(x);
            }   
        }       
        List<SelectOption> returnList = new List<SelectOption> ();      
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue); 
        returnList.addAll(SortOptionList(Greater)); 
        
        return returnList; 
    }

}
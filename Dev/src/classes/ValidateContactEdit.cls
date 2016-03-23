public class ValidateContactEdit {
    String contactId;
    public String redirectURL {get; set;}
    
    public ValidateContactEdit(ApexPages.StandardController controller) {
        contactId = controller.getId();
    }
    
    public PageReference onPageLoad(){
        BaseURL__c bu = BaseURL__c.getInstance('url');
        String stdContactURL = bu.url__c;
        if(!stdContactURL.endsWith('/')){
            stdContactURL = stdContactURL + '/';
        }
        stdContactURL = stdContactURL + contactId;
        
        redirectURL = stdContactURL + '/e?nooverride=1&retURL=' + stdContactURL;
        PageReference returnPage = new PageReference(redirectURL);
        
        LockedOpCos__c lockSetting = LockedOpCos__c.getInstance(UserInfo.getUserId());
        
        Boolean isLocked = false;
        if(lockSetting != null){
            isLocked = lockSetting.Is_Locked__c;
            
            if(isLocked){
                returnPage = new PageReference('http://www.google.com/');
            }
        }
        
        returnPage.setRedirect(true);
        return returnPage;
        //return null;
    }

}
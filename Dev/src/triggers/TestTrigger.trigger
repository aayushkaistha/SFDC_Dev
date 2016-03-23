trigger TestTrigger on AccountRevenue__c (before insert, before update) {
    for(AccountRevenue__c ar : trigger.new){
        if(ar.comPiGLSearch__Update_Count__c == null){
            ar.comPiGLSearch__Update_Count__c = 0;
        }
    
        ar.comPiGLSearch__Update_Count__c = ar.comPiGLSearch__Update_Count__c + 1;
    }
}
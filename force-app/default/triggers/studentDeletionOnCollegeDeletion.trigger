trigger studentDeletionOnCollegeDeletion on RC_college__c (before delete) {
    
    	//List<RC_college__c> college_id=Trigger.old;
		
    	List<RC_Student__c> countList= [SELECT Name FROM RC_Student__C WHERE college_id__c IN : Trigger.oldMap.keySet()];
    
    	System.debug(countList);
}
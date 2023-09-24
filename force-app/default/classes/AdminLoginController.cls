public with sharing class AdminLoginController {
    public class EventStudentDetails{
        public String EventId;
        public String StudentId;
        public String ErrorMsg; 
        public EventStudentDetails(String EventId,String StudentId,String ErrorMsg){
            this.EventId = EventId;
            this.StudentId = StudentId;
            this.ErrorMsg = ErrorMsg;
        }
    }

    @RemoteAction
    public static String LoginAdmin(String EmailInput, String adminPassword) {

            List<RC_admin__c> adminRes = [SELECT Id, adminEmail__c FROM RC_admin__c WHERE adminEmail__c = :EmailInput AND adminPassword__c = :adminPassword];

            if(adminRes.size() == 0)
            {
                return null;
            }

           return adminRes[0].Id;
       }
    
}
public with sharing class AdminLoginController {
    public class LoginDetails{
        public String recordID;
        public Boolean isAdmin;
        public LoginDetails(String recordID,Boolean isAdmin){
            this.recordID = recordID;
            this.isAdmin = isAdmin;
        }
    }

    @RemoteAction
    public static LoginDetails LoginAdmin(String EmailInput, String adminPassword) {

            List<RC_panelist__c> panelistRes = [SELECT Id, panelistsEmail__c FROM RC_panelist__c WHERE panelistsEmail__c = :EmailInput AND panelistsPassword__c = :adminPassword];
            List<RC_admin__c> adminRes = [SELECT Id, adminEmail__c FROM RC_admin__c WHERE adminEmail__c = :EmailInput AND adminPassword__c = :adminPassword];

            if(adminRes.size() != 0)
            {
                LoginDetails lg = new LoginDetails(adminRes[0].Id,true);
                return lg;
            }

            if(panelistRes.size() != 0)
            {
                LoginDetails lg = new LoginDetails(panelistRes[0].Id,false);
                return lg;
            }

            if(adminRes.size() == 0 && panelistRes.size() == 0)
            {
                LoginDetails lg = new LoginDetails('',false);
                return lg;
            }

            return null;
       }
    
}
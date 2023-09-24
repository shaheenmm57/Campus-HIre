public with sharing class UpdateStudentTestCtrl {
    public UpdateStudentTestCtrl() {

    }

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
    public static EventStudentDetails UpdateWarnings(String studentEmail, String eventPassword)
    {
        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');

       List<RC_event__c> eventRes = [SELECT Id, event_id__c,isTestLive__c, event_date__c FROM RC_event__c WHERE event_id__c = :eventPassword];
       List<RC_student__c> studentRes = [SELECT Id, email__c FROM RC_student__c WHERE email__c = :studentEmail];
       if(studentRes.size() == 0 && eventRes.size() == 0)
       {
        EventStudentDetails obj = new EventStudentDetails('', '', 'Email is Not registered and Incorrect Event Password');
        return obj; 
       }
       if(studentRes.size() == 0){
        EventStudentDetails obj = new EventStudentDetails('', '', 'Email is Not registered');
        return obj; 
       }
       if(eventRes.size() == 0){
        EventStudentDetails obj = new EventStudentDetails('', '', 'Event Password is Incorrect');
        return obj; 
       }
       
       String testDate = DateTime.newInstance(
        eventRes[0].event_date__c.year(), eventRes[0].event_date__c.month(), eventRes[0].event_date__c.day()
                    ).format('yyyy-MM-dd');

       if(testDate != todaysDateStr){
        System.debug(testDate);
        System.debug(todaysDateStr);
        EventStudentDetails obj = new EventStudentDetails('', '', 'Test will be live on ' + testDate);
        return obj;
       }
    //    else if(eventRes[0].isTestLive__c == false)
    //    {
    //     EventStudentDetails obj = new EventStudentDetails('', '', 'Test is not live yet, Please Wait');
    //     return obj;
    //    }

        List<RC_student_test__c> validation = [select Id, Name, isLoggedIn__c, student_id__c, event_id__c,student_test_warning__c from RC_student_test__c where student_id__c = :studentRes[0].Id and event_id__c = :eventRes[0].Id];
        if(validation.size() == 0){
            

            EventStudentDetails obj = new EventStudentDetails('','','No Test for this student on this event');
            return obj;
        }else{ 
            validation[0].isLoggedIn__c = false;
            validation[0].student_test_warning__c = 6;
            update validation;
            EventStudentDetails obj = new EventStudentDetails(eventRes[0].Id, studentRes[0].Id,'');
            return obj;
        }
    }


    @RemoteAction
    public static EventStudentDetails UpdateAllTest(String AdminEmail, String AdminEventPassword)
    {  

        List<RC_admin__c> adminRes = [SELECT Id, adminEmail__c FROM RC_admin__c WHERE adminEmail__c = :AdminEmail];

        if(adminRes.size() == 0)
        {
            EventStudentDetails obj = new EventStudentDetails('','','Email is Not registered and Incorrect Event Password');
            return obj;
        }

        List<RC_student_test__c> validation = [SELECT Id, isLoggedIn__c, student_test_warning__c FROM RC_student_test__c where event_id__r.event_id__c = :AdminEventPassword];
        if(validation.size() == 0){  
            EventStudentDetails obj = new EventStudentDetails('','','No Test for this event');
            return obj;
        }else{ 
            for(Integer i = 0;i<validation.size();i++){
                validation[i].isLoggedIn__c = false;
                validation[i].student_test_warning__c = 6; 
            }  
            update validation;
            EventStudentDetails obj = new EventStudentDetails(AdminEmail, AdminEventPassword,'');
            return obj;
        }    
    }
    
}
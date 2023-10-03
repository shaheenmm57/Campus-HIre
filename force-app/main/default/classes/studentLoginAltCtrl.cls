public without sharing class studentLoginAltCtrl {
    public studentLoginAltCtrl() {

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
    public static EventStudentDetails LoginStudent(String EmailInput, String eventPassword) {
        

        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');

       List<RC_event__c> eventRes = [SELECT Id, event_id__c,isTestLive__c, event_date__c FROM RC_event__c WHERE event_id__c = :eventPassword];
       List<RC_student__c> studentRes = [SELECT Id, email__c FROM RC_student__c WHERE email__c = :EmailInput];
       System.debug('eventRes ' +eventRes);
       System.debug('studentRes '+studentRes);
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

        List<RC_student_test__c> validation = [select Id, Name, isLoggedIn__c, student_id__c, event_id__c from RC_student_test__c where student_id__c = :studentRes[0].Id and event_id__c = :eventRes[0].Id];
        if(validation.size() == 0){
            RC_student_test__c std = new RC_student_test__c();
            std.student_id__c = studentRes[0].Id;
            std.event_id__c =  eventRes[0].Id;
            std.isLoggedIn__c = true;
            insert std;

            //Add quetsions for a student
            Boolean result = DML.getInstance().createStudentTestQuestions(std.Id,eventRes[0].Id);
           
            if(result == false)
            {
                EventStudentDetails obj = new EventStudentDetails('', '','Something went Wrong, Please Try again');
                return obj;
            } 

            EventStudentDetails obj = new EventStudentDetails(eventRes[0].Id, studentRes[0].Id,'');

            return obj;
        }else{ 
            if(validation[0].isLoggedIn__c == false)
            {
                validation[0].isLoggedIn__c = true;
                update validation;
                EventStudentDetails obj = new EventStudentDetails(eventRes[0].Id, studentRes[0].Id,'');
                return obj;
            }
            else
            {
                EventStudentDetails obj = new EventStudentDetails(eventRes[0].Id, studentRes[0].Id,'User with this account already logged In, Contact Nearby Admin.');
                return obj;
            }
           
        }
    }
 
}
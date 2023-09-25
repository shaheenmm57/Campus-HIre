public without sharing class TestSubmitScreenCls { 


    public TestSubmitScreenCls() {

    } 
    
    
    //SELECT count(Id) FROM RC_student_question__c where isStudentAnswerdCorrect__c = true and student_test_id__c = 'a075j00000A2W68AAF'
   
 
  

    @RemoteAction
    public static List<RC_student_test__c> GetStudentSubmitStatus(Id studentId,Id eventId) {
          List<RC_student_test__c> studentTestIDRecord =  [SELECT Id, student_test_warning__c, student_test_current_time__c FROM RC_student_test__c where student_id__c = :studentId and event_id__c = :eventId];
          if(studentTestIDRecord.size() != 0){
            return studentTestIDRecord;
          }
          return null;

    }
 
}
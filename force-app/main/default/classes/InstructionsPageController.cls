public without sharing class InstructionsPageController 
{


   
   
   @RemoteAction
   public static Integer GetCurrentTimer(Id studentId , Id eventId ) {  
      Decimal currentTime = [SELECT Id, student_id__c, student_test_current_time__c, student_test_duration__c FROM RC_student_test__c  where student_id__c = :studentId and event_id__c = :eventId].student_test_current_time__c;
      return (Integer)currentTime;
   }

 

   @RemoteAction
   public static List<RC_student_question__c> GetQustionCount(Id studentId, Id eventId) {  
      List<RC_student_question__c> student_test_questions = [SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c,  question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c
      FROM RC_student_question__c
      WHERE student_test_id__c IN (SELECT Id FROM RC_student_test__c WHERE student_id__c = :studentId and event_id__c = :eventId) ORDER BY question_number__c];
      return student_test_questions;
   }

   @RemoteAction
   public static String GetTestStartTime( Id eventId){
      Time  eventTime = [SELECT Id, event_start_time__c FROM RC_event__c WHERE Id = :eventId].event_start_time__c;
      System.debug(eventTime);
           Integer hours = eventTime.hour();
              Integer minutes = eventTime.minute();
              Integer seconds = eventTime.second();


            //   return (hours+minutes+seconds);
            //   Format the time as HH:mm:ss
              String formattedHours = String.valueOf(hours).leftPad(2, '0');
              String formattedMinutes = String.valueOf(minutes).leftPad(2, '0');
              String formattedSeconds = String.valueOf(seconds).leftPad(2, '0');
              
              String formattedTime = formattedHours + ':' + formattedMinutes + ':' + formattedSeconds;
              
              System.debug(formattedTime);
              return formattedTime;
   }
}
public with sharing class CodePageController {
    public CodePageController() {

    }

    @RemoteAction
   public static  RC_student_test__c GetCurrentStudentSession(Id studentId,Id eventId ) {  
      RC_student_test__c codeWarnings = [SELECT Id, code_warnings__c FROM RC_student_test__c  WHERE student_id__c = :studentId and event_id__c = :eventId];
      return codeWarnings;
   }

    @RemoteAction
   public static void UpdateCodeWarnings(Integer codeWarnings, String EventID, String studentID) {  
      RC_student_test__c currentTimeDB = [SELECT Id, code_warnings__c FROM RC_student_test__c  WHERE student_id__c = :studentId and event_id__c = :eventId];
      currentTimeDB.code_warnings__c = codeWarnings;
      update currentTimeDB;
   }
}
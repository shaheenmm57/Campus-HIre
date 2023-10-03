public without sharing class QuestionsPageCtrl { 
 

   //  public static List<RC_student_question__c> questionObj{get;set;}
   //  public static String questionObjJson { get; set; } 
    public static Integer testCurrentTime {get;set;}  


    public QuestionsPageCtrl(){
      // List<RC_student_question__c> student_question_list = [SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c, question_correct_answer__c, question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c FROM RC_student_question__c];
      // questionObjJson = JSON.serialize(student_question_list);
         
      

   } 

   


   @RemoteAction
   public static List<RC_student_question__c> GetInitialData(Id studentId, Id eventId) {  
      List<RC_student_question__c> student_test_questions = [SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c,  question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c
      FROM RC_student_question__c
      WHERE student_test_id__c IN (SELECT Id FROM RC_student_test__c WHERE student_id__c = :studentId and event_id__c = :eventId)];
      // List<RC_student_question__c> student_question_list = [SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c, question_correct_answer__c, question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c FROM RC_student_question__c];
      return student_test_questions;
   }


   @RemoteAction
   public static Decimal GetCurrentTimer(Id studentId,Id eventId ) {  
      Decimal currentTime = [SELECT Id, student_id__c, student_test_current_time__c, student_test_duration__c FROM RC_student_test__c  where student_id__c = :studentId and event_id__c = :eventId].student_test_current_time__c;
      return currentTime;
   }

   @RemoteAction
   public static  RC_student_test__c GetCurrentStudentSession(Id studentId,Id eventId ) {  
      RC_student_test__c currentTime = [SELECT Id, student_test_isStarted__c, student_test_warning__c FROM RC_student_test__c  where student_id__c = :studentId and event_id__c = :eventId];
      return currentTime;
   }

   @RemoteAction
   public static void UpdateCurrentTimer(Integer currentTime, Id studentId, Id eventId, Boolean student_test_isStarted,Integer student_test_warning) {  
      RC_student_test__c currentTimeDB = [SELECT Id, student_id__c, student_test_current_time__c, student_test_duration__c,student_test_isStarted__c,student_test_warning__c FROM RC_student_test__c  where student_id__c = :studentId and event_id__c = :eventId];
      currentTimeDB.student_test_current_time__c = currentTime;
      currentTimeDB.student_test_isStarted__c = student_test_isStarted;
      currentTimeDB.student_test_warning__c = student_test_warning;
      update currentTimeDB;
   }



   
 


    @RemoteAction
    public static List<RC_student_question__c> updateCurrentQuestion(Integer updatedQuestionNumber,String studentAnswer, Id questionId,Boolean isQstAttempted,Id studentId, Id eventId) {  
      // SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c, question_correct_answer__c, question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c
      // FROM RC_student_question__c
      // WHERE student_test_id__c IN (SELECT Id FROM RC_student_test__c WHERE student_id__c = 'a055j00000U7D9WAAV')

        System.debug('k* ' + updatedQuestionNumber   +studentAnswer);
         // List<RC_student_question__c> student_question_list = [SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c, question_correct_answer__c, question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c FROM RC_student_question__c];
         List<RC_student_question__c> student_question_list = [SELECT Id, Name, student_test_id__c, is_attempted__c, currentQuestion__c, question_correct_answer__c, question_description__c, hasProgram__c, question_title__c, student_attempt__c, question_category__c, question_difficulty__c, option_1__c, option_2__c, option_3__c, option_4__c, question_number__c
         FROM RC_student_question__c
         WHERE student_test_id__c IN (SELECT Id FROM RC_student_test__c WHERE student_id__c = :studentId and event_id__c = :eventId)];
         for( Integer i = 0 ;i< student_question_list.size();i++){
                  if(updatedQuestionNumber == student_question_list[i].question_number__c){
                     student_question_list[i].currentQuestion__c = true; 
                  }else{
                     student_question_list[i].currentQuestion__c = false;
                  }
                  if( student_question_list[i].Id == questionId){
                     student_question_list[i].student_attempt__c = studentAnswer;
                     student_question_list[i].is_attempted__c = isQstAttempted;
                  }

         }
         try{
            update student_question_list;
            return student_question_list;
         }catch(Exception e){
            return null;
         } 
    }



   //  @RemoteAction
   //  public static String updateCurrentTimer() {  
       
   //  }

   @RemoteAction
   public static Integer GetQuestionCount(Id studentId,Id eventId) {
          Integer QuestionCount = 0;
           List<AggregateResult> results = [SELECT COUNT(Id) cnt
           FROM RC_student_question__c
           WHERE student_test_id__c IN (SELECT Id FROM RC_student_test__c WHERE student_id__c = :studentId and event_id__c = :eventId) and is_attempted__c = true];

           if (!results.isEmpty()) {
               AggregateResult aggregateResult = results[0];
               QuestionCount = Integer.valueOf(aggregateResult.get('cnt'));
           } else {
               QuestionCount = 0; 
           }
           return QuestionCount;
   }


   @RemoteAction
   public static List<RC_student_question__c> GetQuestionPreiew(Id studentId,Id eventId) {
           List<RC_student_question__c> res = [SELECT Id,question_number__c, question_title__c ,question_category__c,is_attempted__c FROM RC_student_question__c WHERE student_test_id__c IN (SELECT Id FROM RC_student_test__c WHERE student_id__c = :studentId and event_id__c = :eventId)];     
           return res;
   }




   public static Integer reulsOfAgre(List<AggregateResult> results){
      if (!results.isEmpty()) {
         AggregateResult aggregateResult = results[0];
         return (Integer.valueOf(aggregateResult.get('cnt')));
     } else {
         return 0; 
     }
   }


   @RemoteAction
   public static Boolean updateTestMarks(Id studentId,Id eventId) {
         RC_student_test__c studentTestIDRecord =  [SELECT Id, student_marks_scored__c, isLoggedIn__c  FROM RC_student_test__c where student_id__c = :studentId and event_id__c = :eventId];
         List<AggregateResult> results = [SELECT count(Id) cnt FROM RC_student_question__c where isStudentAnswerdCorrect__c = true and student_test_id__c = :studentTestIDRecord.Id];
         List<AggregateResult> Aptiresults = [SELECT count(Id) cnt FROM RC_student_question__c where isStudentAnswerdCorrect__c = true AND student_test_id__c = :studentTestIDRecord.Id AND question_category__c = 'Aptitude'];
         List<AggregateResult> Cprogramresults = [SELECT count(Id) cnt FROM RC_student_question__c where isStudentAnswerdCorrect__c = true and student_test_id__c = :studentTestIDRecord.Id AND question_category__c = 'c programming'];
         Integer marksScored, AptiMarks, CMarks;

         marksScored = reulsOfAgre(results);
         AptiMarks = reulsOfAgre(Aptiresults);
         CMarks = reulsOfAgre(Cprogramresults);
       
         studentTestIDRecord.student_marks_scored__c = marksScored;
         studentTestIDRecord.student_apti_marks__c = AptiMarks;
         studentTestIDRecord.student_cprogram_marks__c = CMarks;
         studentTestIDRecord.isLoggedIn__c = false; 
         Database.SaveResult sr = Database.update(studentTestIDRecord, false);

       if(sr.isSuccess()){
           //do nothing
       }
       else {
           return false;
       }

       return true;

   }
}
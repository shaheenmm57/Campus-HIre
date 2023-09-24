public with sharing class InsertQuestionSetsctrl {
   

    @RemoteAction 
    public static Boolean insertQuestion
    (
        String questionDescription,
        String questionDifficulty,
        String questionTitle,
        String questionCategory,
        String option1,
        String option2,
        String option3,
        String option4,
        String questionCorrectAnswer,
        Boolean hasProgram,
        Boolean isUpdate,
        String qID
    )
    {
        return DML.getInstance().insertQuestionIntoQuestionSet
        (
            questionDescription,
            questionDifficulty,
            questionTitle,
            questionCategory,
            option1,
            option2,
            option3,
            option4,
            questionCorrectAnswer,
            hasProgram,
            isUpdate,
            qID
        );

    }

    
    @RemoteAction
    public static RC_question_set__c getSingleQuestion(String qID){
        List<RC_question_set__c> q = [SELECT question_title__c, Id, hasProgram__c, question_correct_answer__c, question_description__c, option_1__c, option_2__c, option_3__c, option_4__c, question_category__c, question_difficulty__c FROM RC_question_set__c where Id = :qID];
        if(q.size() != 0){
            return q[0];
        }
        return null;
    }
}
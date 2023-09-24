public class GetQuestions 
{
    public static void GetRandomQuestionsForStudent()
    {
        Integer aptiSize = 15, cProgrammingSize = 15;
         List<RC_Event_Question_Test_Set__c> questionsForStudent = new List<RC_Event_Question_Test_Set__c>();
        List<RC_Event_Question_Test_Set__c> aptitudeQuestions = new List<RC_Event_Question_Test_Set__c>();
        List<RC_Event_Question_Test_Set__c> cQuestions = new List<RC_Event_Question_Test_Set__c>();
        
        List<RC_Event_Question_Test_Set__c> allQuestions = [SELECT Id, event_id__c, hasProgram__c, option_1__c, option_2__c, option_3__c, option_4__c, question_Category__c, question_Correct_Answer__c, question_Description__c, question_Title__c, question_difficulty__c FROM RC_Event_Question_Test_Set__c where event_id__c = 'a025j00000eUKL4AAO'];
        
         for(Integer i = 0; i < allQuestions.size(); i++)
        {
            if(allQuestions[i].question_Category__c == 'Aptitude')
            {
                aptitudeQuestions.add(allQuestions[i]);
            }
            else
            {
               cQuestions.add(allQuestions[i]);
            }
        }
        
        AssignRandomQuestionsStudents(aptiSize,aptitudeQuestions,questionsForStudent);
        AssignRandomQuestionsStudents(cProgrammingSize,cQuestions,questionsForStudent);
        
       
        
        System.debug('Number of questions Generated: ' + questionsForStudent.size());
        
    }
    
    
    public static void GetRandomQuestions()
    {
        Integer aptiSize = 5, cProgrammingSize = 5; 
        List<RC_question_set__c> questionsForStudent = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestionsEasy = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestionsMedium = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestionsHard = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestionsEasy = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestionsMedium = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestionsHard = new List<RC_question_set__c>();
        
        List<RC_question_set__c> allQuestions = [SELECT Id,question_category__c,question_difficulty__c FROM RC_question_set__c];
        
        for(Integer i = 0; i < allQuestions.size(); i++)
        {
            if(allQuestions[i].question_category__c == 'Aptitude')
            {
                if(allQuestions[i].question_difficulty__c == 'Easy')
                {
                    aptitudeQuestionsEasy.add(allQuestions[i]);
                }
                else if(allQuestions[i].question_difficulty__c == 'Medium')
                {
                    aptitudeQuestionsMedium.add(allQuestions[i]);
                }
                else if(allQuestions[i].question_difficulty__c == 'Hard')
                {
                    aptitudeQuestionsHard.add(allQuestions[i]);
                }
                
            }
            else
            {
               if(allQuestions[i].question_difficulty__c == 'Easy')
                {
                    cProgrammingQuestionsEasy.add(allQuestions[i]);
                }
                else if(allQuestions[i].question_difficulty__c == 'Medium')
                {
                    cProgrammingQuestionsMedium.add(allQuestions[i]);
                }
                else if(allQuestions[i].question_difficulty__c == 'Hard')
                {
                    cProgrammingQuestionsHard.add(allQuestions[i]);
                }
            }
        }
        
        //get apti set
         AssignRandomQuestions(aptiSize,aptitudeQuestionsEasy,questionsForStudent);
         AssignRandomQuestions(aptiSize,aptitudeQuestionsMedium,questionsForStudent);
         AssignRandomQuestions(aptiSize,aptitudeQuestionsHard,questionsForStudent);
        
        //get CQuestions set
         AssignRandomQuestions(cProgrammingSize,cProgrammingQuestionsEasy,questionsForStudent);
         AssignRandomQuestions(cProgrammingSize,cProgrammingQuestionsMedium,questionsForStudent);
         AssignRandomQuestions(cProgrammingSize,cProgrammingQuestionsHard,questionsForStudent);
        
        
        //iterate and display all questions
        for(Integer i =0 ; i < questionsForStudent.size(); i++)
        {
            System.debug(questionsForStudent[i]);
        }
    }
    
    public static List<Integer> PopulateQuestionIndex(Integer size)
    {
         List<Integer> questionIndex = new List<Integer>();
        for(Integer i = 0; i < size; i++)
        {
            questionIndex.add(i);
        }
        
        return questionIndex;
    }
    
    public static void AssignRandomQuestions(Integer noOfQuestionsToBeAssigned, List<RC_question_set__c> questionSet, List<RC_question_set__c> questionsForStudent)
    {
         List<Integer> questionIndex = PopulateQuestionIndex(questionSet.size());
         List<Integer> chosenQuestionIndex = new List<Integer>();
        
        //get random questions
        while(noOfQuestionsToBeAssigned > 0)
        {
            Integer index = Integer.valueof((Math.random() * questionIndex.size()));
            chosenQuestionIndex.add(questionIndex[index]);
            questionIndex.remove(index);
            noOfQuestionsToBeAssigned--;
        }
        
        //Add into list
         for(Integer i = 0 ; i < chosenQuestionIndex.size(); i++)
        {
            questionsForStudent.add(questionSet[chosenQuestionIndex[i]]);
        }
        
        //Debug
        System.debug(chosenQuestionIndex);
        System.debug(questionsForStudent.size());
    }
    
     public static void AssignRandomQuestionsStudents(Integer noOfQuestionsToBeAssigned, List<RC_Event_Question_Test_Set__c> questionSet, List<RC_Event_Question_Test_Set__c> questionsForStudent)
    {
         List<Integer> questionIndex = PopulateQuestionIndex(questionSet.size());
         List<Integer> chosenQuestionIndex = new List<Integer>();
        
        //get random questions
        while(noOfQuestionsToBeAssigned > 0)
        {
            Integer index = Integer.valueof((Math.random() * questionIndex.size()));
            chosenQuestionIndex.add(questionIndex[index]);
            questionIndex.remove(index);
            noOfQuestionsToBeAssigned--;
        }
        
        //Add into list
         for(Integer i = 0 ; i < chosenQuestionIndex.size(); i++)
        {
            questionsForStudent.add(questionSet[chosenQuestionIndex[i]]);
        }
        
        //Debug
        System.debug(chosenQuestionIndex);
        System.debug(questionsForStudent.size());
    }
    
   
}
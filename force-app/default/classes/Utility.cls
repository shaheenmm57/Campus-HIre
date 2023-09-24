public class Utility 
{
    //Singleton Pattern
    private static Utility uniqueInstance;
    
    public static Utility getInstance()
    {
        if(uniqueInstance == null)
        {
            uniqueInstance = new Utility();
        }

        return uniqueInstance;
    }

    public Time convertStringToTime(string timeInString) //HH:MM format
    {
        String[] timeInStringSplit = timeInString.split(':');
        Time timeData = Time.newInstance( Integer.valueOf(timeInStringSplit[0]) //hour
                                      ,Integer.valueOf(timeInStringSplit[1]) //min
                                      ,0                                //sec
                                      ,0);                              //ms

        return timeData;
    }

    //To populate an array with indexes in increasing order
    public List<Integer> PopulateQuestionIndex(Integer size)
    {
         List<Integer> questionIndex = new List<Integer>();
        for(Integer i = 0; i < size; i++)
        {
            questionIndex.add(i);
        }
        
        return questionIndex;
    }

    
    public void AssignRandomQuestionsStudents(Integer noOfQuestionsToBeAssigned, List<RC_Event_Question_Test_Set__c> questionSet, List<RC_Event_Question_Test_Set__c> questionsForStudent)
    {
        List<Integer> questionIndex = Utility.getInstance().PopulateQuestionIndex(questionSet.size());
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
    }

    public void AssignRandomQuestions(Integer noOfQuestionsToBeAssigned, List<RC_question_set__c> questionSet, List<RC_question_set__c> questionsForStudent)
    {
         List<Integer> questionIndex = Utility.getInstance().PopulateQuestionIndex(questionSet.size());
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
        
        
    }

}
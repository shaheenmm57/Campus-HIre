public class CreateEventController 
{
    @RemoteAction
    public static Boolean createEvent
    (
        String eventName, 
        String eventPassword,
        String eventDate, 
        String eventLocation, 
        String eventStartTime, 
        String eventDuration, 
        String colleges,
        String cutoff, 
        String panelists,
        Integer noOfQuestions
    )
    {
        Boolean flag = false;
        //Create a event Record
        String currentEventId = DML.getInstance().insertEventRecord(eventName,eventPassword,eventDate,eventLocation,eventStartTime,eventDuration,cutoff,noOfQuestions);

        if(currentEventId == 'failed') return false; //couldn't create an event

        flag = DML.getInstance().createEventQuestionTestSet(currentEventId,noOfQuestions); //creates a test for the event
        
        if(flag == false)  return false;
    
        //Setup Link between college and event via junction object
        String[] collegesForThisEvent = colleges.split(',');
        String[] panelistsForThisEvent = panelists.split(',');
        flag = DML.getInstance().linkCollegeAndEventViaJunctionRecord(currentEventId,collegesForThisEvent);
        if(flag == false)  return false;
        return DML.getInstance().linkPanelistsAndEventViaJunctionRecord(currentEventID,panelistsForThisEvent);
    }

    @RemoteAction
    public static Boolean checkIfPasswordTaken(String password)
    {
        return DML.getInstance().isPasswordTaken(password);
    }

    public Boolean createEventQuestionsTestSet(String currentEventID, Integer noOfQuestions)
    {
        Boolean result = DML.getInstance().createEventQuestionTestSet(currentEventID,noOfQuestions);
        return result;
    }

    @RemoteAction
    public static List<RC_college__c> getAllCollegeNames()
    {
        return DML.getInstance().getCollegeNames();
    }

    @RemoteAction
    public static List<RC_panelist__c> getAllPanelistNames()
    {
        return DML.getInstance().getPanelistNames();
    }

    public class QuestionSetData
    {
        Integer aptiEasy,aptiMeduim,aptiHard,CEasy,CMeduim,CHard;

        QuestionSetData(Integer aptiEasy, Integer aptiMeduim, Integer aptiHard, Integer CEasy, Integer CMeduim, Integer CHard)
        {
            this.aptiEasy = aptiEasy;
            this.aptiMeduim = aptiMeduim;
            this.aptiHard = aptiHard;
            this.CEasy = CEasy;
            this.CMeduim = CMeduim;
            this.CHard = CHard;
        }
    }

    @RemoteAction
    public static QuestionSetData getQuestionSetData()
    {
        Integer aptiEasy = 0,aptiMeduim = 0,aptiHard = 0,CEasy = 0,CMeduim = 0,CHard = 0;
        List<RC_question_set__c> questionSet = DML.getInstance().getQuestionSetData();
        
        
        for(Integer i = 0; i < questionSet.size(); i++)
        {
            if(questionSet[i].question_category__c == 'Aptitude')
            {
                if(questionSet[i].question_difficulty__c == 'Easy')
                {
                    aptiEasy++;
                }
                else if(questionSet[i].question_difficulty__c == 'Medium')
                {
                    aptiMeduim++;
                }
                else if(questionSet[i].question_difficulty__c == 'Hard')
                {
                   aptiHard++;
                }
                
            }
            else
            {
               if(questionSet[i].question_difficulty__c == 'Easy')
                {
                    CEasy++;
                }
                else if(questionSet[i].question_difficulty__c == 'Medium')
                {
                   CMeduim++;
                }
                else if(questionSet[i].question_difficulty__c == 'Hard')
                {
                   CHard++;
                }
            }
        }

        QuestionSetData qdata = new QuestionSetData(aptiEasy,aptiMeduim, aptiHard, CEasy, CMeduim, CHard);
        return qdata;
    }
}
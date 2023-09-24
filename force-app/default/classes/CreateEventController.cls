public class CreateEventController 
{
    @RemoteAction
    public static Boolean createEvent(String eventName, String eventPassword,String eventDate, String eventLocation, String eventStartTime, String eventDuration, String colleges,String cutoff)
    {
        Boolean flag = false;
        //Create a event Record
        String currentEventId = DML.getInstance().insertEventRecord(eventName,eventPassword,eventDate,eventLocation,eventStartTime,eventDuration,cutoff);

        if(currentEventId == 'failed') return false; //couldn't create an event

        flag = DML.getInstance().createEventQuestionTestSet(currentEventId); //creates a test for the event
        
        if(flag == false)  return false;
    
        //Setup Link between college and event via junction object
        String[] collegesForThisEvent = colleges.split(',');
        return DML.getInstance().linkCollegeAndEventViaJunctionRecord(currentEventId,collegesForThisEvent);
    }

    @RemoteAction
    public static Boolean checkIfPasswordTaken(String password)
    {
        return DML.getInstance().isPasswordTaken(password);
    }

    public Boolean createEventQuestionsTestSet(String currentEventID)
    {
        Boolean result = DML.getInstance().createEventQuestionTestSet(currentEventID);
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
}
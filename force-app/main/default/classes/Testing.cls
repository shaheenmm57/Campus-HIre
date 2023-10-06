public class Testing 
{
    public static void TestC()
    {
         List<RC_college__c> colleges = [SELECT Id FROM RC_college__C];
		system.debug(colleges);
        
        List<RC_student__c> students = [SELECT Id, college_id__C FROM RC_student__C];
        system.debug(students);
        
        Integer j = 0;
        for(Integer i = 0; i < students.size(); i++)
        {
            students[i].college_id__c = colleges[j].Id;
            
            if(math.mod(i, 40) == 0)
            {
                system.debug(j);
                
                if(j < colleges.size()-1) j++;
                
            }	
            
            system.debug(students[i].college_id__c);
        }
        
        update students;
    }
    
    public static void AddCorrectAnswertToQuestions()
    {
        List<RC_student_question__c> questionsFortheStudent = [Select Id FROM RC_student_question__c];
        String[] opts = new String[]{'option_1','option_2','option_3','option_4'};
        
        for(Integer i =0; i < questionsForTheStudent.size(); i++)
        {
            Integer IntrandomNumber = Integer.valueof((Math.random() * 4));
            questionsFortheStudent[i].question_correct_answer__c = opts[IntrandomNumber];
            System.debug(opts[IntrandomNumber]);
        }
        
        update questionsFortheStudent;
        
    }
    
    public static void GetRandomQuestions()
    {
        Integer aptiSize = 5, cProgrammingSize = 5; 
        List<RC_question_set__c> questionsForStudent = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestions = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestions = new List<RC_question_set__c>();
        
        List<RC_question_set__c> allQuestions = [SELECT Id,question_category__c FROM RC_question_set__c];
        
        for(Integer i = 0; i < allQuestions.size(); i++)
        {
            if(allQuestions[i].question_category__c == 'Aptitude')
            {
                aptitudeQuestions.add(allQuestions[i]);
            }
            else
            {
                cProgrammingQuestions.add(allQuestions[i]);
            }
        }
        
        List<Integer> questionSizeIndex = PopulateQuestionIndex(aptitudeQuestions.size());
        List<Integer> chosenQuestionIndex = new List<Integer>();
        
        
        
        
        //get apti set
        while(aptiSize > 0)
        {
            Integer index = Integer.valueof((Math.random() * questionSizeIndex.size()));
            chosenQuestionIndex.add(questionSizeIndex[index]);
            questionSizeIndex.remove(index);
            aptiSize--;
        }
        
        System.debug(chosenQuestionIndex);
        
        for(Integer i = 0 ; i < chosenQuestionIndex.size(); i++)
        {
            questionsForStudent.add(aptitudeQuestions[chosenQuestionIndex[i]]);
        }
        
        chosenQuestionIndex.clear();
        
        //get CQuestions set
        questionSizeIndex.clear();
        questionSizeIndex = PopulateQuestionIndex(cProgrammingQuestions.size());
        
        while(cProgrammingSize > 0)
        {
            Integer index = Integer.valueof((Math.random() * questionSizeIndex.size()));
            chosenQuestionIndex.add(questionSizeIndex[index]);
            questionSizeIndex.remove(index);
            cProgrammingSize--;
        }
        
        System.debug(chosenQuestionIndex);
        
        for(Integer i = 0 ; i < chosenQuestionIndex.size(); i++)
        {
            questionsForStudent.add(cProgrammingQuestions[chosenQuestionIndex[i]]);
        }
        
        
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
    
    public static void testFn(){
        Time  eventTime = [SELECT Id, event_start_time__c FROM RC_event__c WHERE Id = 'a025j00000d4iX0AAI'].event_start_time__c;
        System.debug(eventTime);
             Integer hours = eventTime.hour();
                Integer minutes = eventTime.minute();
                Integer seconds = eventTime.second();
                
                // Format the time as HH:mm:ss
                String formattedHours = String.valueOf(hours).leftPad(2, '0');
                String formattedMinutes = String.valueOf(minutes).leftPad(2, '0');
                String formattedSeconds = String.valueOf(seconds).leftPad(2, '0');
                
                String formattedTime = formattedHours + ':' + formattedMinutes + ':' + formattedSeconds;
                
                System.debug(formattedTime);
    }
    
    public static void GetEventsFromPassword(String password)
    {
        List<RC_event__c> events = [SELECT Id, event_id__c from RC_event__c where event_id__c = :password];
        
        System.debug('No of Events: ' + events.size());
    }
    
    public static void DeleteAllQuestionFromQuestionSet()
    {
        List<RC_question_set__c> question = [SELECT Id from RC_question_set__c];
        
        delete question;
    }
    
    public static void GetStudentTestIdFromEventAndStudent()
    {
        Id eventID = 'a025j00000eXLqaAAB';
        Id StudentId ='a055j00000WiqWZAAZ';
        RC_student_test__c studentTest;

        try{
        	 studentTest = [Select Id, isLoggedIn__c From RC_student_test__c where student_id__c = :StudentId and event_id__c = :eventID];
        	}
        catch(Exception ex){
            studentTest = null;
        }
        System.debug(studentTest);
    }
    
    public static void CheckDate()
    {
        DateTime todaysDate = System.today();
String todaysDateStr = todaysDate.format('yyyy-MM-dd');
System.debug(todaysDateStr);
    }
    
    public static void TestQuery()
    {
        String EmailInput = 'adi@mail.com';
        String eventPassword = 'sept12';
         System.debug('email and pass '+EmailInput+' '+eventPassword);
        
       List<RC_event__c> eventRes = [SELECT Id, event_id__c, event_date__c FROM RC_event__c where event_id__c = :eventPassword];
       List<RC_student__c> studentRes = [SELECT Id, email__c FROM RC_student__c where email__c = :EmailInput];
       System.debug('eventRes ' +eventRes);
       System.debug('studentRes '+studentRes);
    }
    
    public static void Jsontestt()
    {        
       	List<RC_question_set__c> questions = [SELECT Id, Name, hasProgram__c, question_correct_answer__c, question_description__c, question_title__c, option_1__c, option_2__c, option_3__c, option_4__c, question_category__c, question_difficulty__c FROM RC_question_set__c];
        
        Map<string,string> obj = new Map<string,string>();
        obj.put('Id', questions[0].Id);
            obj.put('Name', questions[0].Name);
            obj.put('hasProgram__c', String.valueOf(questions[0].hasProgram__c));
            obj.put('question_correct_answer__c', questions[0].question_correct_answer__c);
            obj.put('question_description__c', questions[0].question_description__c);
            obj.put('question_title__c', questions[0].question_title__c);
            obj.put('option_1__c', questions[0].option_1__c);
            obj.put('option_2__c', questions[0].option_2__c);
            obj.put('option_3__c', questions[0].option_3__c);
            obj.put('option_4__c', questions[0].option_4__c);
            obj.put('question_category__c', questions[0].question_category__c);
            obj.put('question_difficulty__c', questions[0].question_difficulty__c);
        
        RC_question_set__c q = (RC_question_set__c)JSON.deserialize((String)JSON.serialize(obj), RC_question_set__c.class);
        system.Debug(q.Id);
    }
    
    public static void JsonTest()
    {
        string query='SELECT Id, Name, hasProgram__c, question_correct_answer__c, question_description__c, question_title__c, option_1__c, option_2__c, option_3__c, option_4__c, question_category__c, question_difficulty__c FROM RC_question_set__c';
        string Outputget= JSON.serialize(database.query(query)); 
        system.debug(Outputget);
        List<RC_question_set__c> q = (List<RC_question_set__c>) JSON.deserialize(Outputget, List<RC_question_set__c>.class);
        system.Debug(q[0].Id);
        system.Debug(q[1].Id);
    }
}
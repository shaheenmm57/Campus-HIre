public class DML 
{
    //Singleton Pattern
    private static DML uniqueInstance;

    public static DML getInstance()
    {
        if(uniqueInstance == null)
        {
            uniqueInstance = new DML();
        }
        
        return uniqueInstance;
    }

    public Boolean isPasswordTaken(String password)
    {
        List<RC_event__c> events = [SELECT Id, event_id__c from RC_event__c where event_id__c = :password];

        if(events.size() == 0) return false;
        else return true;
    }

    

    public List<RC_college__c> getCollegeNames()
    {
       return ([SELECT Name FROM RC_college__c]);
    }

    public List<RC_panelist__c> getPanelistNames()
    {
        return ([SELECT Id, panelistsName__c FROM RC_panelist__c]);
    }

    
    public String insertEventRecord(String eventName, String eventPassword, String eventDate, String eventLocation, String eventStartTimeString, String eventDuration, String cutoff)
    {
        Time eventStartTime = Utility.getInstance().convertStringToTime(eventStartTimeString);

        RC_event__c newEvent = new RC_event__c();
        newEvent.Name = eventName;
        newEvent.event_id__c = eventPassword;
        newEvent.event_location__c = eventLocation;
        newEvent.event_duration__c = Integer.valueOf(eventDuration);
        newEvent.cutoff__c = Integer.valueOf(cutoff);
        newEvent.event_date__c = Date.valueOf(eventDate); 
        newEvent.event_start_time__c = eventStartTime;
        Database.SaveResult sr = Database.insert(newEvent, false);

        if(sr.isSuccess()){
            return Id.valueOf(sr.getId());
        }
        else {
            return 'failed';
        }
    }

    public String getEventID(String eventName)
    {
        return ([SELECT Id FROM RC_event__c WHERE Name = :eventName].Id);
    }

    public Boolean linkCollegeAndEventViaJunctionRecord(String eventId, String[] collegesLinkedToEvent)
    {
        List<RC_college_event_junction__c> collegeEventJunctions = new List<RC_college_event_junction__c>();
        
        for(Integer i = 0; i < collegesLinkedToEvent.size();i++)
        {
            RC_college_event_junction__c newCollegeJunctionEvent = new RC_college_event_junction__c();
            newCollegeJunctionEvent.Name = eventId + '_' + collegesLinkedToEvent[i];
            newCollegeJunctionEvent.event_id__c = eventId;
            newCollegeJunctionEvent.college_id__c = collegesLinkedToEvent[i];
            collegeEventJunctions.add(newCollegeJunctionEvent);
        }

        Database.SaveResult[] srList = Database.insert(collegeEventJunctions, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) 
            {
                //continue
            }
            else{
                return false;
            }            
        }

        return true;
    }

    public Boolean linkPanelistsAndEventViaJunctionRecord(String eventId, String[] panelistLinkedToThisEvent)
    {
        List<RC_panelists_event_junction__c> panelistsEventJunctions = new List<RC_panelists_event_junction__c>();

        for(Integer i = 0; i < panelistLinkedToThisEvent.size(); i++)
        {
            RC_panelists_event_junction__c newJunctionRecord = new RC_panelists_event_junction__c();
            newJunctionRecord.event__c = eventId;
            newJunctionRecord.panelists_id__c = panelistLinkedToThisEvent[i];
            panelistsEventJunctions.add(newJunctionRecord);
        }

        Database.SaveResult[] srList = Database.insert(panelistsEventJunctions, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) 
            {
                //continue
            }
            else{
                return false;
            }            
        }

        return true;
    }

    
    public Boolean insertCollegeRecord(CollegeRegistrationDTO formData)
    {
        RC_College__c newRecord = new RC_College__c(
            Name = formData.collegeName,
            tpo_name__c = formData.tpoName,
            college_tpo_email__c = formData.collegeTPOEmail,
            college_tpo_phone__c = formData.collegeTPOPhone,
            college_code__c = formData.collegeCode,
            affiliated_university__c = formData.AffiliatedUniversity,
            college_address__c = formData.collegeAddress,
            college_pincode__c = formData.zipCode
        );

        Database.SaveResult sr = Database.insert(newRecord, false);

        if(sr.isSuccess()){
            return true;
        }
        else {
            return false;
        }
    }

    public Boolean insertQuestionIntoQuestionSet
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
        RC_question_set__c newQuestion = new RC_question_set__c();

        newQuestion.question_description__c = questionDescription;
        newQuestion.question_difficulty__c = questionDifficulty;
        newQuestion.question_title__c = questionTitle;
        newQuestion.question_category__c = questionCategory;
        newQuestion.option_1__c = option1;
        newQuestion.option_2__c = option2;
        newQuestion.option_3__c = option3;
        newQuestion.option_4__c = option4;
        newQuestion.question_correct_answer__c = questionCorrectAnswer;
        newQuestion.hasProgram__c = hasProgram;

        Database.SaveResult sr;
        if(isUpdate)
        {
            newQuestion.Id = qID;
            sr = Database.update(newQuestion, false);   
        }
        else{
            sr = Database.insert(newQuestion, false);
        }

        if(sr.isSuccess()){
            return true;
        }
        else {
            return false;
        }
    }

    public Boolean createEventQuestionTestSet(String eventID, Integer noOfQuestions)
    {
        List<RC_question_set__c> questionForEvent = DML.getInstance().getRandomQuestionsForEvent(noOfQuestions);

        List<RC_Event_Question_Test_Set__c> eventQuestions = new List<RC_Event_Question_Test_Set__c>();

        for(Integer i = 0; i < questionForEvent.size(); i++)
        {
            RC_Event_Question_Test_Set__c newQuestion = new RC_Event_Question_Test_Set__c();
            newQuestion.option_1__c = questionForEvent[i].option_1__c;
            newQuestion.option_2__c = questionForEvent[i].option_2__c;
            newQuestion.option_3__c = questionForEvent[i].option_3__c;
            newQuestion.option_4__c = questionForEvent[i].option_4__c;
            newQuestion.question_correct_answer__c = questionForEvent[i].question_correct_answer__c;
            newQuestion.question_description__c = questionForEvent[i].question_description__c;
            newQuestion.question_title__c = questionForEvent[i].question_title__c;
            newQuestion.Name = questionForEvent[i].Name;
            newQuestion.hasProgram__c = questionForEvent[i].hasProgram__c;
            newQuestion.question_category__c = questionForEvent[i].question_category__c;
            newQuestion.question_difficulty__c = questionForEvent[i].question_difficulty__c;
            newQuestion.event_id__c = eventID;
            eventQuestions.add(newQuestion);
        }

        Database.SaveResult[] srList = Database.insert(eventQuestions, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) 
            {
                //continue
            }
            else{
                return false;
            }            
        }

        return true;

    }

    public Boolean createStudentTestQuestions(String studentTestID, String eventID)
    {
        List<RC_Event_Question_Test_Set__c> questionsForStudent = DML.getInstance().getRandomQuestionsForStudent(eventID);

        List<RC_student_question__c> studentQuestions = new List<RC_student_question__c>();

        for(Integer i = 0; i < questionsForStudent.size(); i++)
        {
            RC_student_question__c newQuestion = new RC_student_question__c();
            newQuestion.option_1__c = questionsForStudent[i].option_1__c;
            newQuestion.option_2__c = questionsForStudent[i].option_2__c;
            newQuestion.option_3__c = questionsForStudent[i].option_3__c;
            newQuestion.option_4__c = questionsForStudent[i].option_4__c;
            newQuestion.question_correct_answer__c = questionsForStudent[i].question_correct_answer__c;
            newQuestion.question_description__c = questionsForStudent[i].question_description__c;
            newQuestion.question_title__c = questionsForStudent[i].question_title__c;
            newQuestion.Name = questionsForStudent[i].Name;
            newQuestion.hasProgram__c = questionsForStudent[i].hasProgram__c;
            newQuestion.question_category__c = questionsForStudent[i].question_Category__c;
            newQuestion.question_difficulty__c = questionsForStudent[i].question_difficulty__c;
            newQuestion.student_test_id__c = studentTestID;
            newQuestion.currentQuestion__c = false;
            newQuestion.question_number__c = i+1;
            studentQuestions.add(newQuestion);
        }

        studentQuestions[0].currentQuestion__c = true;
        Database.SaveResult[] srList = Database.insert(studentQuestions, false);

        String errorMessage;
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) 
            {
                //continue
            }
            else{
               return false;
            }            
        }

        return true;
    }

    public List<RC_question_set__c> getRandomQuestionsForEvent(Integer noOfQuestions)
    {
        Integer aptiEzSize, aptiMedSize, aptiHardSize, cEzSize, cMedSize, cHardSize, aptiPool, cPool;
        aptiPool = noOfQuestions/2;
        cPool = noOfQuestions/2;

        if( (math.mod(aptiPool,3)) != 0)
        {
            Integer ezpool = aptiPool / 3;
            Integer HardPool = aptiPool - (2*ezpool);

            aptiEzSize = ezpool;
            aptiMedSize = ezpool;
            aptiHardSize = HardPool;
            cEzSize = ezpool;
            cMedSize = ezpool;
            cHardSize = HardPool;
        }
        else{
            Integer samePool = aptiPool/3;
            aptiEzSize = samePool;
            aptiMedSize = samePool;
            aptiHardSize = samePool;
            cEzSize = samePool;
            cMedSize = samePool;
            cHardSize = samePool;
        }

        
        List<RC_question_set__c> questionsForStudent = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestionsEasy = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestionsMedium = new List<RC_question_set__c>();
        List<RC_question_set__c> aptitudeQuestionsHard = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestionsEasy = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestionsMedium = new List<RC_question_set__c>();
        List<RC_question_set__c> cProgrammingQuestionsHard = new List<RC_question_set__c>();
        
        List<RC_question_set__c> allQuestions = [SELECT Id, Name, hasProgram__c, question_correct_answer__c, question_description__c, question_title__c, option_1__c, option_2__c, option_3__c, option_4__c, question_category__c, question_difficulty__c FROM RC_question_set__c];
        
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
        Utility.getInstance().AssignRandomQuestions(aptiEzSize,aptitudeQuestionsEasy,questionsForStudent);
        Utility.getInstance().AssignRandomQuestions(aptiMedSize,aptitudeQuestionsMedium,questionsForStudent);
        Utility.getInstance().AssignRandomQuestions(aptiHardSize,aptitudeQuestionsHard,questionsForStudent);
        
        //get CQuestions set
        Utility.getInstance().AssignRandomQuestions(cEzSize,cProgrammingQuestionsEasy,questionsForStudent);
        Utility.getInstance().AssignRandomQuestions(cMedSize,cProgrammingQuestionsMedium,questionsForStudent);
        Utility.getInstance().AssignRandomQuestions(cHardSize,cProgrammingQuestionsHard,questionsForStudent);
         
         return questionsForStudent;
    }

    public List<RC_Event_Question_Test_Set__c> getRandomQuestionsForStudent(String eventID)
    {
        Integer aptisize = 15, cprogsize = 15;
        List<RC_Event_Question_Test_Set__c> questionsForStudent = new List<RC_Event_Question_Test_Set__c>();
        List<RC_Event_Question_Test_Set__c> allQuestions = [SELECT Id,Name, event_id__c, hasProgram__c, option_1__c, option_2__c, option_3__c, option_4__c, question_Category__c, question_Correct_Answer__c, question_Description__c, question_Title__c, question_difficulty__c FROM RC_Event_Question_Test_Set__c where event_id__c = :eventID];
        List<RC_Event_Question_Test_Set__c> aptiQuestions = new List<RC_Event_Question_Test_Set__c>();
        List<RC_Event_Question_Test_Set__c> cprogramQuestions = new List<RC_Event_Question_Test_Set__c>();
        for(Integer i = 0; i < allQuestions.size(); i++)
        {
            if(allQuestions[i].question_category__c == 'Aptitude')
            {
                aptiQuestions.add(allQuestions[i]);
            }
            else
            {
                cprogramQuestions.add(allQuestions[i]);
            }
        }

        Utility.getInstance().AssignRandomQuestionsStudents(cprogsize,cprogramQuestions,questionsForStudent);
        Utility.getInstance().AssignRandomQuestionsStudents(aptiSize,aptiQuestions,questionsForStudent);
         
        return questionsForStudent;
    }
    
    //student registration DML class
    public RC_student__c createStudentBasicAccount(
        String name, String phone, String email, 
        String address1,
        // String address2, 
        String usn, 
        String city, 
        String state, 
        String pincode,
        String collegeId,
        String schoolName, 
        Decimal schoolMarks, 
        String schoolPassYear, 
        String secondarySchoolName, 
        Decimal puMarks, 
        String puPassingYear,
        String degreeType,
        String branchType,
        Decimal degreeMarks, 
        String degreePassingYear) 
    {
            System.debug('Entered createStudent');
            RC_student__c student = new RC_student__c();
            student.Name = name;
            student.Phone__c = phone;
            student.email__c = email;
            student.usn__c = usn;
            student.street__c = address1;
            student.city__c = city;
            student.state__c = state;
            student.pincode__c = Integer.valueOf(pincode);
            student.hsc_name__c = schoolName;
            student.hsc_marks__c = schoolMarks;
            student.hsc_pass_year__c = schoolPassYear;
            student.ssc_name__c = secondarySchoolName;
            student.ssc_marks__c = puMarks;
            student.ssc_pass_year__c = puPassingYear;
            student.college_id__c = collegeId; 
            student.degree_pursuing__c = degreeType;
            student.branch_type__c = branchType;
            student.degree_cgpa__c = degreeMarks;
            student.degree_pass_year__c = degreePassingYear;
            
            
            insert student;
            return student;
    }
}
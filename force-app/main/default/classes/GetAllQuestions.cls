public with sharing class GetAllQuestions {
    public List<RC_Event_Question_Test_Set__c> questions { get; private set; }
    public List<RC_Question_Set__c> allQuestions { get; private set; }
    public Id oppid{get;set;}

   

    public Integer pageSize { get; set; }
    public Integer pageNumber { get; set; }
    public Integer totalPages { get; private set; }
    public Integer totalRecords { get; set; }
    public String selectedEventId { get; set; }
    public String searchText { get; set; }
    public String questionID {get;set;}
    public Boolean updateTable {get; set;}
    public String adminID{get;set;}


    public class WrapperQuestions{

        public Id Id { get; set; }
        public String Name {get;set;}
        public Boolean hasProgram { get; set; }
        public String option_1 { get; set; }
        public String option_2 { get; set; }
        public String option_3 { get; set; }
        public String option_4 { get; set; }
        public String question_Category { get; set; }
        public String question_Correct_Answer { get; set; }
        public String question_Description { get; set; }
        public String question_difficulty { get; set; }
        public String question_Title { get; set; }
        public Boolean isFromQuestionSets {get;set;}

        public WrapperQuestions(){
              this.Id = null;
              this.Name = '';
              this.hasProgram = false;
              this.option_1 = '';
              this.option_2 = '';
              this.option_3 = '';
              this.option_4 = '';
              this.question_Category = '';
              this.question_Correct_Answer = '';
              this.question_Description = '';
              this.question_difficulty = '';
              this.question_Title = '';
              this.isFromQuestionSets = false;
        }
    }

    public List<WrapperQuestions> questionsFromDB { get;  set; }

    public GetAllQuestions() {
        // Default page size is set to 10 records
        pageSize = 10;
        pageNumber = 1;
        totalRecords = 0;
        updateEventList();
        updateTable = true;
        adminID = apexpages.currentpage().getparameters().get('adminId');
    }

    public void removeQuestion()
    {
        updateTable = false;
        System.debug('Deleting question with question ID: ' + questionID);
        List<RC_question_set__c> questionToDelete = [SELECT Id FROM RC_question_set__c WHERE Id = :questionID];
        List<Database.DeleteResult> srList = Database.delete(questionToDelete);

        for (Database.DeleteResult sr : srList) {
            if (sr.isSuccess()) 
            {
                //continue
            }
            else{
                updateTable = false;
                return;
            }            
        }

        updateAllQuestions();

        if(questionsFromDB.size() == 0)
        {
            pageNumber -= 1;

            if(pageNumber <= 0) 
            {
                System.debug('You deleted all the questions!');
            }

            updateAllQuestions();
            updateEventList();
            pageNumber = totalPages;
            // totalPages -= 1;
        }
        updateTable = true;
    }

    private void updateAllQuestions()
    {
        Integer offset = (pageNumber - 1) * pageSize;
        allQuestions = [SELECT Id,Name, hasProgram__c, option_1__c, option_2__c, option_3__c, option_4__c, question_Category__c, question_Correct_Answer__c, question_Description__c, question_difficulty__c, question_Title__c FROM RC_Question_Set__c LIMIT :pageSize OFFSET :offset];
            questionsFromDB = new List<WrapperQuestions>();
            for(Integer i = 0;i<allQuestions.size();i++){
                WrapperQuestions obj = new WrapperQuestions();
                obj.Id = allQuestions[i].Id;
                obj.Name = allQuestions[i].Name;
                obj.hasProgram = allQuestions[i].hasProgram__c;
                obj.option_1= allQuestions[i].option_1__c;
                obj.option_2= allQuestions[i].option_2__c;
                obj.option_3= allQuestions[i].option_3__c;
                obj.option_4= allQuestions[i].option_4__c;
                obj.question_Category= allQuestions[i].question_Category__c;
                obj.question_Correct_Answer= allQuestions[i].question_Correct_Answer__c;
                obj.question_Description= allQuestions[i].question_Description__c;
                obj.question_difficulty= allQuestions[i].question_difficulty__c;
                obj.question_Title= allQuestions[i].question_Title__c;
                obj.isFromQuestionSets = true;
                questionsFromDB.add(obj);
            }

            totalPages = (totalRecords + pageSize - 1) / pageSize;
    }

    

    public List<SelectOption> getEventOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('noAccSelected', '------'));
        options.add(new SelectOption('displayAllQuestions', 'View All Questions'));
        for (RC_event__c acc : [SELECT Id, Name FROM RC_event__c]) {
            options.add(new SelectOption(acc.Id, acc.Name));
        }
        return options;
    }

    public void updateEventList() {
        if (selectedEventId != null) {
            System.System.debug(selectedEventId);
            if (selectedEventId == 'displayAllQuestions'){totalRecords = [SELECT COUNT() FROM RC_Question_Set__c];}
            else{
                totalRecords = [SELECT COUNT() FROM RC_Event_Question_Test_Set__c WHERE event_id__c = :selectedEventId];
            }
            pageSize=10;
            totalPages = (totalRecords + pageSize - 1) / pageSize;
            pageNumber = 1;
            updateEvents();
        }
    }
    public Boolean getPrevDisabled() {
        return pageNumber <= 1;
    }
    
    public Boolean getNextDisabled() {
        return pageNumber >= totalPages;
    }
    
    public void first() {
        pageNumber = 1;
        updateEvents();
    }
    
    public void previous() {
        pageNumber--;
        updateEvents();
    }
    
    public void next() {
        pageNumber++;
        updateEvents();
    }
    
    public void last() {
        pageNumber = totalPages;
        updateEvents();
    }
    
    public Boolean getShowPagination() {
        return totalRecords > 20;
    }

    public List<SelectOption> getPageSizeOptions() {
        List<Integer> pageSizes = new List<Integer>{
            10,
            (Integer)Math.round(0.2 * totalRecords / 10) * 10,
            (Integer)Math.round(0.3 * totalRecords / 10) * 10,
            (Integer)Math.round(0.5 * totalRecords / 10) * 10,
            (Integer)Math.round(0.75 * totalRecords / 10) * 10,
            totalRecords
        };
    
        List<SelectOption> pageSizeOptions = new List<SelectOption>();
        for (Integer size : pageSizes) {
            pageSizeOptions.add(new SelectOption(String.valueOf(size), String.valueOf(size)));
        }
        return pageSizeOptions;
    } 

    // public Boolean isDefaultAccountSelected {
    //     get { return selectedEventId == null || selectedEventId == 'noAccSelected'; }
    // }

    // public Boolean getContactNotFound(){
    //     return totalRecords == 0;
    // }
    
    private void updateEvents() {
        Integer offset = (pageNumber - 1) * pageSize;
        if (selectedEventId == 'displayAllQuestions'){
            allQuestions = [SELECT Id,Name, hasProgram__c, option_1__c, option_2__c, option_3__c, option_4__c, question_Category__c, question_Correct_Answer__c, question_Description__c, question_difficulty__c, question_Title__c FROM RC_Question_Set__c LIMIT :pageSize OFFSET :offset];
            questionsFromDB = new List<WrapperQuestions>();
            for(Integer i = 0;i<allQuestions.size();i++){
                WrapperQuestions obj = new WrapperQuestions();
                obj.Id = allQuestions[i].Id;
                obj.Name = allQuestions[i].Name;
                obj.hasProgram = allQuestions[i].hasProgram__c;
                obj.option_1= allQuestions[i].option_1__c;
                obj.option_2= allQuestions[i].option_2__c;
                obj.option_3= allQuestions[i].option_3__c;
                obj.option_4= allQuestions[i].option_4__c;
                obj.question_Category= allQuestions[i].question_Category__c;
                obj.question_Correct_Answer= allQuestions[i].question_Correct_Answer__c;
                obj.question_Description= allQuestions[i].question_Description__c;
                obj.question_difficulty= allQuestions[i].question_difficulty__c;
                obj.question_Title= allQuestions[i].question_Title__c;
                obj.isFromQuestionSets = true;
                questionsFromDB.add(obj);
            }
        }
        else{
            questions = [SELECT Id,Name, hasProgram__c, option_1__c, option_2__c, option_3__c, option_4__c, question_Category__c, question_Correct_Answer__c, question_Description__c, question_difficulty__c, question_Title__c FROM RC_Event_Question_Test_Set__c WHERE event_id__c = :selectedEventId LIMIT :pageSize OFFSET :offset];
            questionsFromDB = new List<WrapperQuestions>();
            for(Integer i = 0;i<questions.size();i++){
                WrapperQuestions obj = new WrapperQuestions();
                obj.Id = questions[i].Id;
                obj.Name = questions[i].Name;
                obj.hasProgram= questions[i].hasProgram__c;
                obj.option_1= questions[i].option_1__c;
                obj.option_2= questions[i].option_2__c;
                obj.option_3= questions[i].option_3__c;
                obj.option_4= questions[i].option_4__c;
                obj.question_Category= questions[i].question_Category__c;
                obj.question_Correct_Answer= questions[i].question_Correct_Answer__c;
                obj.question_Description= questions[i].question_Description__c;
                obj.question_difficulty= questions[i].question_difficulty__c;
                obj.question_Title= questions[i].question_Title__c;
                obj.isFromQuestionSets = false;
                questionsFromDB.add(obj);
            }
        }
        
        totalPages = (totalRecords + pageSize - 1) / pageSize;
    }
    
    // public void searchEvents() {
    //     if (selectedEventId != null) {
    //         System.debug(selectedEventId);
    //         if (!String.isBlank(searchText)) {
    //             contacts = [SELECT Id, FirstName, LastName, Email
    //                         FROM Contact
    //                         WHERE AccountId = :selectedEventId AND (FirstName LIKE :searchText OR LastName LIKE :searchText)
    //                         ORDER BY FirstName ASC
    //                         LIMIT :pageSize
    //                         OFFSET :((pageNumber - 1) * pageSize)];
    //             totalRecords = [SELECT COUNT()
    //                             FROM Contact
    //                             WHERE AccountId = :selectedEventId AND (FirstName LIKE :searchText OR LastName LIKE :searchText)];
    //         } else {
    //             updateEventList();
    //         }
    //         totalPages = (totalRecords + pageSize - 1) / pageSize;
    //     }
    // }
    
    public void changePageSizeAction() {
        // Update the page size and reset to the first page
        pageNumber = 1;
        updateEvents(); // To prevent any navigation
    }
}
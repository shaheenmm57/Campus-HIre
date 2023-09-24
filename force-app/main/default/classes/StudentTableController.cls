public with sharing class StudentTableController {
    public List<RC_student__c> studentList {get; private set;}
    public List<RC_college__c> collegeList {get; private set;}
    
    public Integer reqRecords { get; set; }
    public String selectedUserFilter {get; set;}
    public String selectedCollegeId { get; set; }
    public String selectedEventId { get; set; } // Add this property for event selection
    public String studentListType {get; set;}

    public Integer pageSize { get; set; }
    public Integer pageNumber { get; set; }
    public Integer totalPages { get; private set; }

    public String searchText { get; set; }

    public StudentTableController() {
        pageSize = 10;
        pageNumber = 1;
        reqRecords = 0;
        updateStudentList();
    }

    public List<SelectOption> getUserFilterOptions(){
        List<SelectOption> filterOptions = new List<SelectOption>();
        filterOptions.add(new SelectOption('noFilterSelected', '------'));
        filterOptions.add(new SelectOption('displayAllStudents', 'View All Students'));
        filterOptions.add(new SelectOption('displayEventStudents', 'Event'));
        filterOptions.add(new SelectOption('displayCollegeStudents', 'College'));

        return filterOptions;
    }

    public List<SelectOption> getSelectOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('noCollegeSelected', '------'));
        if (studentListType == 'college') {
            for(RC_college__c college: [SELECT Id, Name FROM RC_college__c]){
                options.add(new SelectOption(college.Id, college.Name));
            }
        }
        if (studentListType == 'event') {
            for(RC_event__c event: [SELECT Id, Name FROM RC_event__c]){
                options.add(new SelectOption(event.Id, event.Name));
            }
        }
        
        return options;
    }

    public void updateUserFilter(){
        if (selectedUserFilter == 'displayAllStudents'){
            studentListType = null;
        }
        if (selectedUserFilter == 'displayEventStudents'){
            studentListType = 'event';
        }
        if (selectedUserFilter == 'displayCollegeStudents'){
            studentListType = 'college';
        }
        updateStudentList();
    }


    public void updateStudentList(){
        if (selectedCollegeId != null) {
            System.debug(selectedCollegeId);
            if (selectedCollegeId == 'displayAllStudents'){
                reqRecords = [SELECT COUNT() FROM RC_student__c];
            }
            else if (studentListType == 'event') {
                if(selectedCollegeId!=null){
                reqRecords = [SELECT COUNT () FROM RC_student_test__c WHERE event_id__c = :selectedCollegeId];}
            }
            else {
                if(selectedCollegeId!=null){
                reqRecords = [SELECT COUNT() FROM RC_student__c WHERE college_id__c = :selectedCollegeId];}
            }
            pageSize = 10;
            totalPages = (reqRecords + pageSize - 1) / pageSize;
            pageNumber = 1;
            updateStudents();
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
        updateStudents();
    }
    
    public void previous() {
        pageNumber--;
        updateStudents();
    }
    
    public void next() {
        pageNumber++;
        updateStudents();

    }
    
    public void last() {
        pageNumber = totalPages;
        updateStudents();
    }

    public Boolean getShowPagination() {
        return reqRecords > 20;
    }

    public List<SelectOption> getPageSizeOptions() {
        List<Integer> pageSizes = new List<Integer>{
            10,
            (Integer)Math.round(0.2 * reqRecords / 10) * 10,
            (Integer)Math.round(0.3 * reqRecords / 10) * 10,
            (Integer)Math.round(0.5 * reqRecords / 10) * 10,
            (Integer)Math.round(0.75 * reqRecords / 10) * 10,
            reqRecords
        };
    
        List<SelectOption> pageSizeOptions = new List<SelectOption>();
        for (Integer size : pageSizes) {
            pageSizeOptions.add(new SelectOption(String.valueOf(size), String.valueOf(size)));
        }
        return pageSizeOptions;
    }

    public void updateStudents(){
        Integer offset = (pageNumber - 1) * pageSize;

        if (selectedUserFilter == 'displayAllStudents'){
            studentList = [SELECT Id, Name, usn__c, college_id__r.Name , email__c, phone__c, branch_type__c, degree_cgpa__c FROM RC_student__c LIMIT :pageSize OFFSET :offset];
        }
        else if (studentListType == 'event') {
            studentList = [SELECT Id, Name, usn__c, college_id__r.Name , email__c, phone__c, branch_type__c, degree_cgpa__c FROM RC_student__c WHERE Id IN (SELECT student_id__c FROM RC_student_test__c WHERE event_id__c = :selectedCollegeId ) LIMIT :pageSize OFFSET :offset];
        }
        else if (studentListType == 'college') {
            studentList = [SELECT Id, Name, usn__c, college_id__r.Name , email__c, phone__c, branch_type__c, degree_cgpa__c FROM RC_student__c WHERE college_id__c = :selectedCollegeId LIMIT :pageSize OFFSET :offset];
        }
        totalPages = (reqRecords + pageSize - 1) / pageSize;
    }

    public PageReference changePageSizeAction() {
        // Update the page size and reset to the first page
        pageNumber = 1;
        updateStudents();
        return null; // To prevent any navigation
    }
}
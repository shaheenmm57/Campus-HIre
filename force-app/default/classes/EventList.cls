public with sharing class EventList {

    public class StudentInfo {
        public String studentName { get; set; }
        public Decimal marksScored { get; set; }
        public Boolean clearedCutoff { get; set; }
    
        public StudentInfo(String name, Decimal marks, Boolean cleared) {
            studentName = name;
            marksScored = marks;
            clearedCutoff = cleared;
        }
    }

    public class MyWrapper {
        public List<RC_student__c> student_list { get; set; }
        public List<RC_event__c> Event_List { get; set; }
        public List<RC_student_test__c> student_test_details { get; set; }
        public List<StudentInfo> studentInfoList { get; set; }
    }



    @RemoteAction
    public static MyWrapper showResults(String event_id, Integer check){

        MyWrapper result = new MyWrapper();
        result.studentInfoList = new List<StudentInfo>();


        if (check == 1){
        result.student_test_details = [Select student_id__c,student_marks_scored__c,has_cleared_cutoff__c from RC_student_test__c where event_id__c = :event_id];
        
        
        Set<Id> studentIds = new Set<Id>();
        for (RC_student_test__c junctionRecord : result.student_test_details) {
            studentIds.add(junctionRecord.student_id__c);
        }

        result.student_list = [SELECT Name FROM RC_student__c WHERE Id IN :studentIds];


        Map<Id, String> studentNameMap = new Map<Id, String>();

        // Populate a map of student Ids to student names
        for (RC_student__c student : result.student_list) {
            studentNameMap.put(student.Id, student.Name);
        }


        for (RC_student_test__c junctionRecord : result.student_test_details) {
            String studentName = studentNameMap.get(junctionRecord.student_id__c);
            if (studentName != null) {
                StudentInfo studentInfo = new StudentInfo(studentName, junctionRecord.student_marks_scored__c, junctionRecord.has_cleared_cutoff__c);
                result.studentInfoList.add(studentInfo);
            }
        }


        return result;


    }
    else{
        result.Event_List = [select Name,event_date__c from RC_event__c];
        return result;
    }
}
}
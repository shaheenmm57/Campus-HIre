public with sharing class EventList {

    public class StudentInfo {
        public StudentPersonalInfo studentData { get; set; }
        public Decimal marksScored { get; set; }
        public Decimal cpMarks { get; set; }
        public Decimal aptiMarks { get; set; }
        public Decimal negtotalMarks { get; set; }
        public Decimal negcpMarks { get; set; }
        public Decimal negaptiMarks { get; set; }
        public String Id { get; set; }
    
        public StudentInfo(String fid, StudentPersonalInfo sdata, Decimal marks, Decimal cpm, Decimal aptim, Decimal negtm, Decimal negcpm, Decimal negaptim) {
            studentData = sdata;
            marksScored = marks;
            cpMarks = cpm;
            aptiMarks = aptim;
            negtotalMarks = negtm;
            negcpMarks = negcpm;
            negaptiMarks = negaptim;
            Id = fid;

        }
    }

    public class StudentPersonalInfo{
        public String name { get; set; }
        public String phone { get; set; }
        public String email { get; set; }
        public String usn { get; set; }

        public StudentPersonalInfo(String sname, String sphone, String semail, String susn){
            name = sname;
            phone = sphone;
            email = semail;
            usn = susn;
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
        result.student_test_details = [Select student_id__c, student_marks_scored__c, student_cprogram_marks__c, student_apti_marks__c, neg_student_marks_scored__c, neg_student_cprogram_marks__c, neg_student_apti_marks__c from RC_student_test__c where event_id__c = :event_id];
        
        
        Set<Id> studentIds = new Set<Id>();
        for (RC_student_test__c junctionRecord : result.student_test_details) {
            studentIds.add(junctionRecord.student_id__c);
        }

        result.student_list = [SELECT Name,	phone__c,email__c,	usn__c FROM RC_student__c WHERE Id IN :studentIds];


        Map<Id, StudentPersonalInfo> studentNameMap = new Map<Id, StudentPersonalInfo>();

        // Populate a map of student Ids to student names
        for (RC_student__c student : result.student_list) {
            StudentPersonalInfo info = new StudentPersonalInfo(student.Name,student.phone__c,student.email__c,student.usn__c);
            studentNameMap.put(student.Id, info);
        }


        for (RC_student_test__c junctionRecord : result.student_test_details) {
            StudentPersonalInfo studentData = studentNameMap.get(junctionRecord.student_id__c);
            if (studentData != null) {
                StudentInfo studentInfo = new StudentInfo(junctionRecord.student_id__c, studentData, junctionRecord.student_marks_scored__c,junctionRecord.student_cprogram_marks__c, junctionRecord.student_apti_marks__c, junctionRecord.neg_student_marks_scored__c, junctionRecord.neg_student_cprogram_marks__c, junctionRecord.neg_student_apti_marks__c);
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
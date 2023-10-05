public with sharing class studentProfileController {
    public studentProfileController() {

    }
    @RemoteAction
    public static Map<String, Object> retriveStudentDetails(String studentId, String eventId){
        Map<String, Object> result = new Map<String, Object>();
        
        try {
            RC_student__c student = [SELECT Id, Name, branch_type__c, city__c, college_id__r.Name, diploma_college_name__c, 
                                            diploma_passing_year__c, email__c, hsc_marks__c, hsc_name__c, phone__c, 
                                            hsc_pass_year__c, pincode__c, ssc_marks__c, ssc_name__c, ssc_pass_year__c, 
                                            state__c, street__c, usn__c, isHired__c, diploma_marks__c, 
                                            degree_pursuing__c, degree_cgpa__c, degree_pass_year__c 
                                      FROM RC_student__c 
                                      WHERE Id = :studentId];
            result.put('Id', student.Id);
            result.put('Name', student.Name);
            result.put('branch_type__c', student.branch_type__c);
            result.put('city__c', student.city__c);
            result.put('college_id__c', student.college_id__r.Name);
            result.put('diploma_college_name__c', student.diploma_college_name__c);
            result.put('diploma_passing_year__c', student.diploma_passing_year__c);
            result.put('email__c', student.email__c);
            result.put('hsc_marks__c', student.hsc_marks__c);
            result.put('hsc_name__c', student.hsc_name__c);
            result.put('phone__c', student.phone__c);
            result.put('hsc_pass_year__c', student.hsc_pass_year__c);
            result.put('pincode__c', student.pincode__c);
            result.put('ssc_marks__c', student.ssc_marks__c);
            result.put('ssc_name__c', student.ssc_name__c);
            result.put('ssc_pass_year__c', student.ssc_pass_year__c);
            result.put('state__c', student.state__c);
            result.put('street__c', student.street__c);
            result.put('usn__c', student.usn__c);
            result.put('isHired__c', student.isHired__c);
            result.put('diploma_marks__c', student.diploma_marks__c);
            result.put('degree_pursuing__c', student.degree_pursuing__c);
            result.put('degree_cgpa__c', student.degree_cgpa__c);
            result.put('degree_pass_year__c', student.degree_pass_year__c);
            
            result.put('success', true);
        } catch (Exception e) {
            result.put('success', false);
            result.put('errorMessage', e.getMessage());
        }

        try {
            RC_student_test__c studentTest = [SELECT Name, Id, student_id__c, event_id__c, student_marks_scored__c, has_cleared_cutoff__c, event_cutoff__c, student_test_current_time__c, student_test_duration__c, student_test_start_time__c, student_test_isStarted__c, student_test_warning__c, isLoggedIn__c, code_warnings__c, student_apti_marks__c, student_cprogram_marks__c, neg_student_marks_scored__c, neg_student_apti_marks__c, neg_student_cprogram_marks__c FROM RC_student_test__c WHERE student_id__c = :studentId AND event_id__c = :eventId];
            
            if (studentTest != null) {
                result.put('StudentTestId', studentTest.Id);
                result.put('StudentMarksScored', studentTest.student_marks_scored__c);
                result.put('HasClearedCutoff', studentTest.has_cleared_cutoff__c);
                result.put('EventCutoff', studentTest.event_cutoff__c);
                result.put('StudentTestCurrentTime', studentTest.student_test_current_time__c);
                result.put('StudentTestDuration', studentTest.student_test_duration__c);
                result.put('StudentTestStartTime', studentTest.student_test_start_time__c);
                result.put('StudentTestIsStarted', studentTest.student_test_isStarted__c);
                result.put('StudentTestWarning', studentTest.student_test_warning__c);
                result.put('IsLoggedIn', studentTest.isLoggedIn__c);
                result.put('CodeWarnings', studentTest.code_warnings__c);
                result.put('StudentAptitudeMarks', studentTest.student_apti_marks__c);
                result.put('StudentCProgramMarks', studentTest.student_cprogram_marks__c);
                result.put('NegStudentMarksScored', studentTest.neg_student_marks_scored__c);
                result.put('NegStudentAptitudeMarks', studentTest.neg_student_apti_marks__c);
                result.put('NegStudentCProgramMarks', studentTest.neg_student_cprogram_marks__c);
            }
            result.put('success', true);
        } catch (Exception e) {
            result.put('success', false);
            result.put('errorMessage', e.getMessage());
        }
        
        return result;
    }
    
}
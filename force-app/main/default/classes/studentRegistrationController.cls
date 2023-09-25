public without sharing class studentRegistrationController {
    public studentRegistrationController() {

    }

    @RemoteAction
    public static RC_student__c createStudentBasicAccount(
        String name, 
        String phone, 
        String email, 
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
        return DML.getInstance().createStudentBasicAccount(name, phone, email, address1, usn, city, state, pincode,collegeId, schoolName, schoolMarks, schoolPassYear, secondarySchoolName, puMarks, puPassingYear, degreeType, branchType, degreeMarks, degreePassingYear);
    }

    @RemoteAction
    public static List<RC_college__c> getAllCollegeNames()
    {
        List<RC_college__c> collegeNames = [Select Name from RC_college__c];
        return collegeNames;
    }

    @RemoteAction
    public static Boolean checkIfUsnAndEmailExist(String usn, String email) {
        Boolean usnExists = [SELECT COUNT() FROM RC_student__c WHERE usn__c = :usn] > 0;
        Boolean emailExists = [SELECT COUNT() FROM RC_student__c WHERE email__c = :email] > 0;
        
        return (usnExists || emailExists);
    }

}
public with sharing class CollegeRegistration {
    @RemoteAction
    public static Boolean saveForm(CollegeRegistrationDTO formData) {
        return DML.getInstance().insertCollegeRecord(formData);
    }
}
public with sharing class LoginPageController {
    public String emailID { get; set; }
    public String eventID { get; set; }
    public String messageScript{get; set;}
    public Boolean showErrors{get;set;}
    public String errorTextValue{get;set;}
    public List<RC_student_test__c> validation{get;set;}
    public List<RC_student__c> stud{get;set;}
    public  List<RC_event__c> event_id_list{get;set;}
    public ID event_id_q{get;set;}
    public ID studID{get;set;}
    public RC_student_test__c newStudTest{get;set;}
    
    public LoginPageController(){
        emailID=null;
        eventID=null;
        validation=null;
        showErrors=false;
        errorTextValue=null;
    }

    public PageReference successfulLogin(String eventID, String studentID){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Login successful!  Email-ID : '+emailID+' Event Password : '+eventID));           
            PageReference pageRef = Page.InstructionsPage;
            pageRef.getParameters().put('studentId', studentID);
            pageRef.getParameters().put('eventId', eventID);
            pageRef.setRedirect(true);
            return pageRef;
    }
    
    public void showAlert(String message) {
        errorTextValue=message;
        showErrors=true;
    }
    
    public void closeErrorPopUp(){
        showErrors=false;
    }
    
    public PageReference Login() {

        if(String.isEmpty(emailID) || String.isEmpty(eventID)){
            showAlert('Empty fields exist');
            return null;
        }
        
        validation=[select Name, isLoggedIn__c from RC_student_test__c   
        	 where (student_id__r.email__c=:emailID and event_id__r.event_id__c=:eventID)]; //existing stud_test record
        
        
      
        
        if(validation.size()==0)
        {	
			//System.debug('Student list '+stud);
            
            stud=[select ID from RC_student__c where email__c=:emailID];// valid email exists

            if(stud.size()==0)
            {

              showAlert('Email ID not registered');
              return null; 
                
            }
            else
            {
				studID=stud[0].id;
                System.debug('Student ID '+studID);

                event_id_list=[select event_id__c from RC_event__c where event_id__c=:eventID]; //valid event exists

               
                
                if(event_id_list.size()==0)
                {	
                    showAlert('Invalid event password');
					return null;                    
                }
                else
                {
                    event_id_q=event_id_list[0].id;
                    System.debug('Event ID retreived '+event_id_q);
                    
                    newStudTest=new RC_student_test__c(student_id__c=studID,event_id__c=event_id_q,isLoggedIn__c=true);
                    System.debug('New studTest : '+newStudTest);
                    insert newStudTest;

                    Boolean result = DML.getInstance().createStudentTestQuestions(newStudTest.Id,event_id_q);

                    if(result == false)
                    {
                        showAlert('Something went Wrong, Please Try again');
                        return null;
                    } 
                    

                    return successfulLogin(event_id_q,studID);
                }
            }
        }
            else{
                
                System.debug('Entered a valid login');
                Boolean isLoggedIn = validation[0].isLoggedIn__c;
                if(isLoggedIn == true){
                    showAlert('User Already Logged in, Please Contact Admin');
                    return null;
                }
                validation[0].isLoggedIn__c = true;
                update validation;
                
                
               
                return successfulLogin(event_id_q,studID);
           }
    }

    public PageReference OpenPage() {   //on create new student
        PageReference pr = new PageReference('/apex/studentRegistrationAlt');
		pr.setRedirect(true);
		return pr;
    }
}
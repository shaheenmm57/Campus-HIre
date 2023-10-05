public with sharing class autoEventSubmitCtrl {

    public autoEventSubmitCtrl() {
    }

    @RemoteAction
    public static List<RC_Event__C> retrieveEvents(){
        List<RC_Event__C> eventList=[select Name,id from RC_Event__C];

        return eventList;
    }

    @RemoteAction
    public static String compileEventTests(String eventID){
       
        List<RC_student_test__C> a=[SELECT Id FROM RC_student_test__c WHERE event_id__c=:eventID];
        Integer n = (Integer)Math.ceil(a.size());
        
        for(Integer i=0;i<n;i+=20){
            updateTestsFuture(eventID,i);
        }
        return 'Updation Completed';

    }

    @future
    public static void updateTestsFuture(String eventID,Integer i){
        try{
        List<RC_student_test__c > stlist=[SELECT Id, event_id__c, student_id__c FROM RC_student_test__c
        where event_id__c=:eventID order by student_id__c asc limit 20 offset :i ];

       // Integer start = System.Now().millisecond();
      //  while(System.Now().millisecond()< start+1000){ 
      //  }
        
        for(RC_student_test__c r:stlist)
            {
            AltQuestionPageCtrl.updateTestMarks(r.student_id__c,r.event_id__c );
             }
          
        }catch(Exception e){
            System.debug('compileEventTests exception : '+e);
            System.debug('Exception in compileEventTests');
        }
       System.debug('compileEventTests Succesfully');
     }
    
}
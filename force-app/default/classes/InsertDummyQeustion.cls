public  class InsertDummyQeustion {
     
    public static void runFn(){
         
        try{ 
            List<RC_student_question__c> ls = [SELECT Id,question_title__c FROM RC_student_question__c];
            for(Integer i = 0;i<ls.size();i++){
                ls[i].question_title__c =   'title  ' + i + ': Which keyword is used to prevent any changes in the variable within a C program?';
            }
            update ls;
           /*List<RC_student_question__c> questionObj = new List<RC_student_question__c>();
           List<RC_question_set__c> tmpQuestionset = [SELECT Id, question_correct_answer__c, question_description__c, question_title__c, student_attempt__c, option_1__c, option_2__c, option_3__c, question_category__c, option_4__c, question_difficulty__c FROM RC_question_set__c];
            
            for(Integer i = 1;i<=30;i++){
               QuestionsPageDTO obj =  new QuestionsPageDTO();
               obj.question_number = i;
               if(Math.mod(i, 2) !=0 )
                {
                 obj.question_cat = 'c-programming';
                }
              else{
                 obj.question_cat = 'Aptitude';
              }
               obj.question_title = 'title  ' + i + ': Which keyword is used to prevent any changes in the variable within a C program?';
               if( Math.mod(i, 2) != 0 && i < 15)
                   {
                    obj.question_desc =tmpQuestionset[0].question_description__c;
                   } 
                else{
                 if( i >= 15 ){
                    obj.question_desc = ' c-program question description';
                    
                 }else{
     
                    obj.question_desc = ' apptitude question description';
                 }
                }
               obj.option_1 = i +  'immuteable';
               obj.option_2 = i + 'mutable ';
               obj.option_3 = i + 'constant';
               obj.option_4 = i + 'valatile';
               obj.isAnswered = false;
               if(i < 7){
                 obj.isAnswered = true;
               }
               obj.hasProgram = false;
               if( i < 15){
                 obj.hasProgram = true;
               }
               if(i == 1){
                 obj.currentQuestion = true;
               }else{
                 obj.currentQuestion = false;
               }
                
                RC_student_question__c tmpobj = new RC_student_question__c();
                tmpobj.question_difficulty__c = 'easy';
                tmpobj.hasProgram__c = obj.hasProgram;
                tmpobj.currentQuestion__c  = obj.currentQuestion;
                tmpobj.is_attempted__c = obj.isAnswered;
                tmpobj.option_1__c = obj.option_1;
                tmpobj.option_2__c = obj.option_2;
                tmpobj.option_3__c = obj.option_3;
                tmpobj.option_4__c = obj.option_4;
                tmpobj.question_description__c = obj.question_desc;
                tmpobj.student_test_id__c = 'a075j00000A2W68AAF';
                questionObj.add(tmpobj);
     
            }
            System.debug('t^ ' + questionObj);
            
            insert questionObj;*/
            
             
        }catch(Exception  e){ 
        }
        
    }
}
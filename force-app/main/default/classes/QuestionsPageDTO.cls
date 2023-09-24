public with sharing class QuestionsPageDTO {
    public Integer question_number{get;set;}
    public String question_cat{get;set;}
    public String question_title { get; set; }
    public String question_desc { get; set; }
    public String option_1 { get; set; }
    public String option_2 { get; set; }
    public String option_3 { get; set; }
    public String option_4 { get; set; } 
    public Boolean hasProgram {get;set;}
    public Boolean isAnswered {get;set;}
    public Boolean currentQuestion {get;set;}

}
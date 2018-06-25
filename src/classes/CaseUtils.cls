/**
 * CaseUtils.cls
 * @description A collection of methods pertaining to the Case object
 * @autor Mikhail Glushko, 2018
 * @version 1 
 */
public with sharing class CaseUtils {
    /**
     * values for calculate Case.Priority using Contact.Contact_Level__c
     */ 
    private static Map<String,String> prioritys = new Map<String,String>{
        'Primary'  =>'High', 'Secondary'=>'Medium', 'Tertiary' =>'Low', null =>'', '' =>''
    };
    /**
     * calcPriorityForCase
     * @description A Case utility method calculate Priority for new Case using value Contact_Level of Contact
     * Primary   => High
     * Secondary => Medium
     * Tertiary  => Low
     * @param Contact con - which contain Contact_Level parameter
     * @return String - Priority parameter for Case
     */
    public static String calcPriorityForCase(Contact con){
        return prioritys.get(con.Contact_Level__c);
    }
}
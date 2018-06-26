/**
 * ContactUtils.cls
 * @description A collection of methods pertaining to the Contact object
 * @autor Mikhail Glushko, 2018
 * @version 1
 */
public with sharing class ContactUtils {
    /** 
     * @description A staic method for a Contact object containing logic to be performed 
     * on the after insert event
     * @param newList List collection of Contact records to execute logic on
     */
    public static void afterInsert(List<Contact> newList){
        // create collection of accountIds for all new created Contacts 
        // using input collection of Contacts
        Set<Id>  accountIds = new Set<Id>();      
        for(Contact con: newList){
            if(con.AccountId!=null){
                accountIds.add(con.AccountId);
            }
        }
        // create map Account.Id => Account.ownerid 
        // using collection of "accountIds" and Accounts 
        Map<Id,Id> accountMap = new Map<Id,Id>();
        if(accountIds!=null && accountIds.size()!=0){
        	for(Account acc: [select Id, OwnerId from Account where Id in :accountIds]){
        		accountMap.put(acc.Id,acc.OwnerId);    
        	}
    	}
        
		// create collection of Case to be autocreated for for all new Contacts
		// using input collection of Contacts and "accountMap"        
    	List<Case> caseList = new List<Case>();
    	for(Contact con: newList){
        	caseList.add(new Case(ContactId = con.id,
                              	  AccountId = con.AccountId,
                              	  Status = 'Working',
                              	  Origin = 'New Contact',
                              	  Priority = CaseUtils.calcPriorityForCase(con),
                              	  OwnerId = (con.AccountId!=null) ? accountMap.get(con.AccountId) : con.OwnerId
                                 ));
    	}
        
        // insert prepared Cases to databese
        if(caseList!=null && caseList.size()!=0){
       		insert caseList;
            // show information in message section on page
           	if(ApexPages.currentPage()!=null){
           		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                   	                                       'Cases #'+caseList+' was created'
                       	                                  ));
               }
               System.debug('Cases #'+caseList+' was created');
         }                
    }
    
    /**
     * @description A staic method for a Contact object containing logic to be performed 
     * on the before delete event
     * @param newList List collection of Contact records to execute logic on
     */
    public static void beforeDelete(List<Contact> newList){     
        // create collection of Cases to be delete with Contacts
        List<Case> caseList = [select Id, ContactId from Case where ContactId in :newList];
        
        // delete exists cases
        if(caseList!=null && caseList.size()!=0){
            delete caseList;
            // show information in message section on pahe
            if(ApexPages.currentPage()!=null){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                    	                                   'Cases #'+caseList+' was deleted'
                        	                               ));
            }
            System.debug('Cases #'+caseList+' was deleted');
         }
    }
}
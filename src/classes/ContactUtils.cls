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
        // create accountIds set for all new created contacts 
        Set<Id>  accountIds = new Set<Id>();      
        for(Contact con: newList){
            if(con.AccountId!=null){
                accountIds.add(con.AccountId);
            }
        }
        
        // map account.Id => account.ownerid  
        Map<Id,Id> accountMap = new Map<Id,Id>();
        if(accountIds!=null && accountIds.size()!=0){
        	for(Account acc: [select Id, OwnerId from Account where Id in :accountIds]){
        		accountMap.put(acc.Id,acc.OwnerId);    
        	}
    	}
        
		// create new case for for all new contacts        
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
        
        // insert prepared cases
    	try{
            if(caseList!=null && caseList.size()!=0){
        		insert caseList;
            	if(ApexPages.currentPage()!=null){
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                    	                                       'Cases #'+caseList+' was created'
                        	                                  ));
                }
                System.debug('Cases #'+caseList+' was created');
            }                
    	}
    	catch(DmlException ex){
            if(ApexPages.currentPage()!=null){
       			ApexPages.addMessages(ex);
            }
            System.debug(ex);
    	}
    }
    
    /**
     * @description A staic method for a Contact object containing logic to be performed 
     * on the before delete event
     * @param newList List collection of Contact records to execute logic on
     */
    public static void beforeDelete(List<Contact> newList){
	// deleted contacts list
        List<Contact> contactList = new List<Contact>();
        for(Contact con: newList){
        	contactList.add(con);        
        }
        // case list to be delete for contacts
        List<Case> caseList = new List<Case>(); 
        if(contactList!=null && contactList.size()!=0){
        	caseList = [select Id, ContactId from Case where ContactId in :contactList];
    	}
        // delete exists cases
        try{
            if(caseList!=null && caseList.size()!=0){
            	delete caseList;
            	if(ApexPages.currentPage()!=null){
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                    	                                       'Cases #'+caseList+' was deleted'
                        	                                  ));
            	}
                System.debug('Cases #'+caseList+' was deleted');
            }
        }
        catch(DmlException ex){
            if(ApexPages.currentPage()!=null){
       			ApexPages.addMessages(ex);
            }
            System.debug(ex);
    	}        
    }
}
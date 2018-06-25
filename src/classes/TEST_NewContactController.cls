/**
 * @description Test methods for NewContactController.cls
 * @autor Mikhail Glushko, 2018
 */
@isTest
public class TEST_NewContactController {
    /**
     *	@desctiption This test method checks in general the addition of new records 
     */ 
	@testSetup
    static void setup(){
        Account defaultAccount = new Account(name = 'Test Account'); insert defaultAccount;
		List<Contact> contactList = new List<Contact>();
        
        for(Integer i=0; i<25; i++){
			contactList.add(new Contact(lastname='lastname'+i, accountid = defaultAccount.id)); 
        }
        insert contactList;
		
        List<Contact> contacts = [SELECT Id, LastName FROM CONTACT];
        System.assertEquals(25, contacts.size());
              
    }
    
    /**
     * @description This test method checks the operation of the Save button 
     * and saves the Contact object to the database
     */ 
    @isTest
    static void NewContactSave(){
        PageReference pageRef = Page.NewContact;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getHeaders().put('referer','ContactManager');

        Account defaultAccount = new Account(name = 'Test Account'); insert defaultAccount;
        Contact defaultContact = new Contact(lastname='lastname', accountid = defaultAccount.id);
        ApexPages.StandardController defaultStandardController = new ApexPages.StandardController(defaultContact);
        NewContactController ncc = new NewContactController(defaultStandardController);  
        ncc.save();
        
        List<Contact> result = [Select id, lastname FROM Contact where lastname=:defaultContact.LastName];
        System.assertEquals(1, result.size());
    }
    
    /**
     * @description This test method checks the operation of the Cancel button 
     */     
    @isTest
    static void NewContactCancel(){
        PageReference pageRef = Page.NewContact;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getHeaders().put('referer','ContactManager');

        Account defaultAccount = new Account(name = 'Test Account'); insert defaultAccount;
        Contact defaultContact = new Contact(lastname='lastname', accountid = defaultAccount.id);
        ApexPages.StandardController defaultStandardController = new ApexPages.StandardController(defaultContact);
        NewContactController ncc = new NewContactController(defaultStandardController);  
        ncc.cancel();
        
        List<Contact> result = [Select id, lastname FROM Contact where lastname=:defaultContact.LastName];
        System.assertEquals(0, result.size());
    }
}
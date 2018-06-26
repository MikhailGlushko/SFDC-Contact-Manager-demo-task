/**
 * @description Test methods for NewContactController.cls
 * @autor Mikhail Glushko, 2018
 */
@isTest
public class NewContactControllerTest {
    /**
     *	@desctiption This test method checks in general the addition of new records 
     */ 
	@testSetup
    static void setup(){
        // create new Account ans insert it
        Account defaultAccount = new Account(name = 'Test Account'); insert defaultAccount;
        // create and insert 25 Contacts 
		List<Contact> contactList = new List<Contact>();
        for(Integer i=0; i<25; i++){
			contactList.add(new Contact(lastname='lastname'+i, accountid = defaultAccount.id)); 
        }
        insert contactList;
		// Contact insertion validation check
        List<Contact> contacts = [SELECT Id, LastName FROM CONTACT];
        System.assertEquals(25, contacts.size());
    }
    
    /**
     * @description This test method checks the operation of the Save button 
     * and saves the Contact object to the database
     */ 
    @isTest
    static void NewContactSave(){
        // preparing current page and refferer parameter for redirection
        PageReference pageRef = Page.NewContact;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getHeaders().put('referer','ContactManager');
		// create new Account and insert it
        Account defaultAccount = new Account(name = 'Test Account'); insert defaultAccount;
        // create new Contact
        Contact defaultContact = new Contact(lastname='lastname', accountid = defaultAccount.id);
        //create instance of DefaultController
        ApexPages.StandardController defaultStandardController = new ApexPages.StandardController(defaultContact);
        // create instance of NewContactController
        NewContactController ncc = new NewContactController(defaultStandardController);
        // save new Contact
        ncc.save();
        // result validation check
        List<Contact> result = [Select id, lastname FROM Contact where lastname=:defaultContact.LastName];
        System.assertEquals(1, result.size());
    }
    
    /**
     * @description This test method checks the operation of the Cancel button 
     */     
    @isTest
    static void NewContactCancel(){
        // preparing current page and refferer parameter for redirection
        PageReference pageRef = Page.NewContact;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getHeaders().put('referer','ContactManager');
        Contact defaultContact = new Contact(lastname='lastname');
        ApexPages.StandardController defaultStandardController = new ApexPages.StandardController(defaultContact);
        NewContactController ncc = new NewContactController(defaultStandardController);  
        ncc.cancel();
         // result validation check
        List<Contact> result = [Select id, lastname FROM Contact where lastname=:defaultContact.LastName];
        System.assertEquals(0, result.size());
    }   
}
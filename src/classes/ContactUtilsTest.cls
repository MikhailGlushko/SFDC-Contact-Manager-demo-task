/**
 * @description Test methods for ContactUtils.cls
 * @autor Mikhail Glushko, 2018
 */
@isTest
public class ContactUtilsTest {
	/**
	 * @description This test method checks the correctness of the after insert trigger operation
	 * when adding new Contacts 
	 * and automatic creation new Cases
	 */
    @isTest
    static void afterInsert(){
        // create new Account and insert it to database
    	Account a = new Account(name='Test', OwnerId=UserInfo.getUserId()); insert a;
        // create new Contact and insert it to database
        Contact c = new Contact(firstname='first', lastname='last', OwnerId = UserInfo.getUserId(), AccountId = a.Id, Contact_Level__c = 'Primary'); insert c;
        // check result after insert
        Contact validationContact = [select id, firstname, lastname from Contact where id = :c.id];
        List<Case> caselist = [SELECT Id, ContactId, AccountId, Status, Origin, OwnerId, Priority FROM Case WHERE ContactId =:c.Id];
        Case validationCase;
        if(caselist!=null && caselist.size()>0){
            validationCase = caselist.get(0); 
        }
        
        // Case fields validation check 
        System.assertEquals(c.Id, validationCase.ContactId);
        System.assertEquals(a.Id, validationCase.AccountId);
        System.assertEquals('Working', validationCase.Status);
        System.assertEquals('New Contact', validationCase.Origin);
        System.assertEquals(a.OwnerId, validationCase.OwnerId);
        System.assertEquals('High', validationCase.Priority);
    }

	/**
	 * @description This test method checks the correctness of the before delete trigger operation
	 * when deleting exist Contacts 
	 * and automatic removal of related Cases before deleting Contacts
	 */    
    @isTest
    static void beforeDelete(){
        //create new Account and insert it
    	Account a = new Account(name='Test', OwnerId=UserInfo.getUserId()); insert a;
        //create new Contact and insert it 
        Contact c = new Contact(firstname='first', lastname='last', OwnerId = UserInfo.getUserId(), AccountId = a.Id, Contact_Level__c = 'Primary'); insert c;
        
        // delete created Contact
        List<Case> cs = [SELECT Id, ContactId, AccountId, Status, Origin, OwnerId, Priority FROM Case WHERE ContactId =:c.Id];
        delete c;
        
        // Contact deletion check
        List<Contact> result = [select id, firstname, lastname from Contact where id = :c.id];
        System.assertEquals(0, result.size());
        
        // Case deletion check
        cs = [SELECT Id, ContactId, AccountId, Status, Origin, OwnerId, Priority FROM Case WHERE ContactId =:c.Id];
        System.assertEquals(0, cs.size());
    }
}
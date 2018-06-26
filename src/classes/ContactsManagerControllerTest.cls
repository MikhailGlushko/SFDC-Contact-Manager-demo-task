/**
 * @description Test methods for ContactsManagerController.cls
 * @autor Mikhail Glushko, 2018
 */
@isTest
public class ContactsManagerControllerTest {
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
    }
    
    /**
     * This test method validate the correct creation of the ContactsManagerController
     */ 
    @isTest
    static void testConstructor(){
    	ContactsManagerController cmc = new ContactsManagerController();
        System.assertEquals(5, cmc.pageSizeItems.size());
        System.assertEquals(10, cmc.pageSize);
        System.assertEquals('', cmc.searchString);
        System.assertEquals(0, cmc.orderIndex);
    }
    
    /**
     * This test method checks the operation of pagination
     */ 
    @isTest
    static void testGetContactsList(){
    	ContactsManagerController cmc = new ContactsManagerController();
        List<Contact> result = cmc.contactsList;
       	System.assert(result!=null);
        System.assertEquals(10, result.size());
        
        List<Contact> old = result;
        
        cmc.first();
        result = cmc.contactsList;
        System.assertEquals(old, result);
        
        old = result;
        
        cmc.prev();
        result = cmc.contactsList;
        System.assertEquals(old, result);
        
        old = result;
        
        cmc.next();
        result = cmc.contactsList;
        System.assertNotEquals(old, result);
        
        old = result;
        
        cmc.end();
        result = cmc.contactsList;
        System.assertNotEquals(old, result);
        System.assertEquals(5, result.size());
    }
    
    /**
     * This test method checks the operation of ordering
     */
    @isTest
    static void testSetOrderIndex(){
    	ContactsManagerController cmc = new ContactsManagerController();
        cmc.pageSize = 50;
        cmc.setItemsPerPage();
        List<Contact> old = cmc.contactsList;
        cmc.orderIndex = 0;
        cmc.setOrderIndex();
        List<Contact> result = cmc.contactsList;
        System.assertNotEquals(old[0], result[0]);
        System.assertEquals(old[0], result[result.size()-1]);
        
        cmc.setOrderIndex();
        result = cmc.contactsList;
        System.assertEquals(old[0], result[0]);
        System.assertNotEquals(old[0], result[result.size()-1]);
        
        cmc.orderIndex = 1;
        cmc.setOrderIndex();
        result = cmc.contactsList;
        System.assertNotEquals(old, result);
    }
    
    /**
     * This test method checks the operation of searching
     */
    @isTest
    static void testSearch(){
        ContactsManagerController cmc = new ContactsManagerController();
        cmc.searchString = 'firstname';
        cmc.search();
        List<Contact> result = cmc.contactsList;
        System.assertEquals(0, result.size());
        
        cmc.searchString = 'lastname10';
        cmc.search();
        result = cmc.contactsList;
        System.assertEquals(1, result.size());
    }
    
    /**
     * This test method checks the operation of deleting exist record
     */
    @isTest
    static void testDeleteExist(){
        ContactsManagerController cmc = new ContactsManagerController();
        List<Contact> result = cmc.contactsList;
        cmc.contactId = result[0].Id;
        cmc.del();
        List<Contact> newResult = cmc.contactsList;
        System.assertNotEquals(result[0], newResult[0]);
    }
    
    /**
     * This test method checks the operation of deleting no exist record
     */ 
    @istest
    static void testDeleteNoExist(){
        ContactsManagerController cmc = new ContactsManagerController();
        List<Contact> result = cmc.contactsList;
        cmc.contactId = null;
        cmc.del();
        List<Contact> newResult = cmc.contactsList;
        System.assertEquals(result[0], newResult[0]);
    }
    
    @isTest
    static void testNewContact(){
        ContactsManagerController cmc = new ContactsManagerController();
        PageReference page = cmc.newContact();     
        System.assertEquals(new PageReference('/apex/NewContact').getUrl(), page.getUrl());     
    }
}
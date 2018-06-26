/**
 * @description Test methods for CaseUtils.cls
 * @autor Mikhail Glushko, 2018
 */
@isTest
private class CaseUtilsTest {
    /**
     * @desctiption This test method validates the calculation of the field value "Case.Priority" 
     * on the basis of the field value "Contact.Contact_Level__c"
     */
    @isTest
    static void testCalcPriorityForCase(){
        // create new Contact object
        Contact con = new Contact(FirstName='First Name',
                                  LastName = 'Last Name',
                                  Email = 'email@email.com',
                                  Contact_level__c = 'Primary');
		
        // calculate priority for Contact_Level is Primary
        String priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('High', priority);
        
        // calculate priority for Contact_Level is Secondary
        con.Contact_Level__c = 'Secondary';
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('Medium', priority);
        
        // calculate priority for Contact_Level is Tertiary    
        con.Contact_Level__c = 'Tertiary';
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('Low', priority); 
        
        // calculate priority for Contact_Level is is not selected    
        con.Contact_Level__c = '';
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('', priority);
        
        // calculate priority for Contact_Level is null    
        con.Contact_Level__c = null;
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('', priority);
    }
    
}
/**
 * @description Test methods for CaseUtils.cls
 * @autor Mikhail Glushko, 2018
 */
@isTest
private class TEST_CaseUtils {
    /**
     * @desctiption This test method validates the calculation of the field value "Case.Priority" 
     * on the basis of the field value "Contact.Contact_Level__c"
     */
    @isTest
    static void testCalcPriorityForCase(){
        Contact con = new Contact(FirstName='First Name',
                                  LastName = 'Last Name',
                                  Email = 'email@email.com',
                                  Contact_level__c = 'Primary');
		
        String priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('High', priority);
        
        con.Contact_Level__c = 'Secondary';
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('Medium', priority);
            
        con.Contact_Level__c = 'Tertiary';
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('Low', priority); 
            
        con.Contact_Level__c = '';
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('', priority);
            
        con.Contact_Level__c = null;
        priority = CaseUtils.calcPriorityForCase(con);
        System.assertEquals('', priority);
    }
    
}
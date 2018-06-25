/**
 * ContactsManagerController.cls
 * Controller for Contacts Detail page 
 * show data grid, search contact by first/last name, pagination, ordering by field, new contact button
 * @autor Mikhail Glushko, 2018 
 * @version 1 
 */ 
public with sharing class ContactsManagerController {     
    private final String NEW_CONTACT_PAGE = '/apex/NewContact';
    
    //list of contactsList
    public  List<Contact> contactsList  {get; private set;}
    private List<String>  contactsFieldList {get; private set;}
    private integer contactsListCount   {get;set;}
    private integer contactsListOffset  {get;set;}
    // ordering
    public  integer orderIndex     {get;set;}
    private String  orderDirection {get;set;}
    private integer prevOrderIndex  = 0;
    // pagination
    public  final integer PAGE_SIZE_DEFAULT_INDEX = 1; 
    public  List<SelectOption>  pageSizeItems {get; private set;}
    public  integer pageSize    {get;set;}
    public  integer pageCount   {get;set;}
    public  integer currentPage {get;set;} 
    //
    public String contactId    {get;set;}
    public String searchString {get;set;}
    
    //constructor
    public ContactsManagerController(){
        // set fields list
		this.contactsFieldList = new List<String>{'Name',
            									  'Email',
            									  'Contact_Level__c', 
            									  'Account.Name', 
            									  'Owner.Name', 
            								      'CreatedBy.Name', 
            									  'CreatedDate'};
        //set count items per page allowable values
        this.pageSizeItems = new List<SelectOption>{
            								   new SelectOption('5','5'),
            								   new SelectOption('10','10'),
            								   new SelectOption('20','20'),
                                               new SelectOption('50','50'),
                                               new SelectOption('100','100')};
        // set default count items per page                                           
        this.pageSize = Integer.valueOf(pageSizeItems.get(PAGE_SIZE_DEFAULT_INDEX).getValue());
        //set default filter to search
        this.searchString = '';
        //set default column bumber to ordering 
        this.orderIndex = 0;
        //set default direction to ordering
        this.orderDirection = 'ASC';
        // set default offset for pagination
        this.contactsListOffset = 0;
        //build contacts list
        getContactsList();  
    }
    
    // get list of contactsList    
    private void getContactsList(){
        getTotalRecords();
        // notnalize value to '' if null
        this.searchString = (searchString==null) ? '' : searchString;
        // calculate current page
        this.currentPage=contactsListOffset+1;
        // fetch records from database
        this.contactsList = Database.query('SELECT '+
                                  String.join(contactsFieldList, ',')+
                                  ' FROM contact '+
                                  ' WHERE firstName like \'%'+searchString+'%\' OR lastName like \'%'+searchString+'%\' '+ 
                                  ' ORDER BY '+contactsFieldList.get(orderIndex)+' '+orderDirection+
                                  ' LIMIT '+pageSize+
                                  ' OFFSET '+contactsListOffset*pageSize);
    }
    
    // get total count of records
    private void getTotalRecords(){
        // notnalize value to '' if null
        this.searchString = (searchString==null) ? '' : searchString;     
        // fetch total count from database
        this.contactsListCount = Database.countQuery('select count() FROM contact '+' WHERE firstName like \'%'+searchString+'%\' OR lastName like \'%'+searchString+'%\' ');
        // calculate page count
        this.pageCount = ((contactsListCount / pageSize)*pageSize!=contactsListCount)
            ? (contactsListCount / pageSize+1) : (contactsListCount / pageSize);
        // show message if no recirds found
        if(contactsListCount==0 && ApexPages.currentPage()!=null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No records found'));
        }
    }
    
    // get records for first page
    public void first(){
        this.contactsListOffset = 0;
        //rebuild contacts list
        getContactsList();
    }
    
    // get records for previous pages
    public void prev(){
        this.contactsListOffset = (contactsListOffset>0) ? contactsListOffset-1 : contactsListOffset;
        //rebuild contacts list
        getContactsList();
    }
    
    //get records for next page
    public void next(){
        this.contactsListOffset = ((contactsListOffset+1)*pageSize<contactsListCount)
            ? contactsListOffset+1 : contactsListOffset;
        //rebuild contacts list
        getContactsList();
    }
    
    //get records for last pages
    public void end(){
        contactsListOffset = contactsListCount / pageSize;
        this.contactsListOffset = (contactsListOffset*pageSize==contactsListCount && contactsListOffset>0)
            ? contactsListOffset-1 : contactsListOffset;
        //rebuild contacts list
        getContactsList();
    }
    
    // set order and order direction
    public void setOrderIndex(){
        if(prevOrderIndex==orderIndex){
            if('ASC'.equals(orderDirection))
                this.orderDirection = 'DESC';
            else
                this.orderDirection = 'ASC';
        }
        
        if(prevOrderIndex!=orderIndex){
            this.prevOrderIndex=orderIndex;
            this.orderDirection = 'ASC';
        }
        //rebuild contacts list
        getContactsList();
    }
    
    // delele decord
    public void del(){
        if(contactId==null)
            return;
        // get contact by Id
        Contact cnt = [select Id from contact where Id = :contactId];
        // delete contact
        try{
        	delete cnt;
            if(ApexPages.currentPage()!=null){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact #'+contactId+' was deleted'));
            }
        } 
        catch(DmlException ex){
            if(ApexPages.currentPage()!=null){
        		ApexPages.addMessages(ex);
            }
    	}
        //rebuild contacts list
        getContactsList();
    }
    
    // search and show records
    public void search(){
        this.contactsListOffset = 0;
        //rebuild contacts list
        getContactsList();
    }
    
    // re init count items per page
    public void setItemsPerPage(){
        //rebuild contacts list
        getContactsList();
    }
    
    // redirect to new contact page
    public PageReference newContact(){
    	PageReference pr = new PageReference(NEW_CONTACT_PAGE);
    	pr.setRedirect(true);  
        return pr;
    }
}
/**
 * NewContactController.cls
 * Controller for New Contact page 
 * input new data, save and cancel
 * @autor Mikhail Glushko, 2018
 * @version 1
 */
public with sharing class NewContactController {
    private String reffererPage;
    private Contact newContact {get; set;}
    
    // cunstructor with standatd controller
    public NewContactController(ApexPages.StandardController controller){
        // get contact information from StandardController
       	this.newContact = (Contact)controller.getRecord(); 
        //get refferer page information
        this.reffererPage = ApexPages.currentPage().getHeaders().get('Referer');
    }

    // save command - inserd prepared record of new Contact to database
    public Pagereference save(){
        //seve new conact
   		insert newContact;
        //redirect to previous page (Contact Manager Page)
		return redirect();
    }
    
    //cancel command - do nothing
    public Pagereference cancel(){
        // redirect to previous page (Contact Manager Page)
		return redirect();
    }
    
    // redirect command - redirect to refferer page (Contact Manager Page)
    private Pagereference redirect(){
        PageReference pr = new PageReference(reffererPage);
        pr.setRedirect(true);
        return pr;        
    }
}
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
    
    // cunstructor
    public NewContactController(ApexPages.StandardController controller){
        // get contact information from StandardController
       	this.newContact = (Contact)controller.getRecord(); 
        //get refferer page information
        this.reffererPage = ApexPages.currentPage().getHeaders().get('Referer');
    }

    // save command
    public Pagereference save(){
        //seve new conact
        try{
    		insert newContact;
        }
        catch(DmlException ex){
       		ApexPages.addMessages(ex);
    	}
        //redirect
		return redirect();
    }
    
    //cancel command
    public Pagereference cancel(){
        // redirect
		return redirect();
    }
    
    // redirect command
    private Pagereference redirect(){
        PageReference pr = new PageReference(reffererPage);
        pr.setRedirect(true);
        return pr;        
    }
}
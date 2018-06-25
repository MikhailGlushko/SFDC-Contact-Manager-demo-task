/**
 * Contacts.trg
 * Trigger for Contact (after insert, before delete)
 * - afrer insert:
 * create new Case
 * - before delete:
 * delete exist Case
 * @autor Mikhail Glushko, 2018
 * @version 1
 */ 
trigger ContactTrigger on Contact (after insert, before delete) {
    // route after insert event to corresponding ContactUtils method
    if(Trigger.isAfter && Trigger.isInsert){
        ContactUtils.afterInsert(Trigger.new);
    }
    
    // route before delete event to corresponding ContactUtils method
    else if(Trigger.isBefore && Trigger.isDelete){
        ContactUtils.beforeDelete(Trigger.old);
    }
}
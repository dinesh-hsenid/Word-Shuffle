public with sharing class ContactTriggerHandler {
    public ContactTriggerHandler() {

    }

    public static void afterInsertHandler(List<Contact> newContacts) {
        Set<Id> uniqueAccountIds = new Set<Id>();
            for(Contact contact : newContacts) {
                // Checking that contact is linked with Parent Account
                if(String.isNotBlank(contact.AccountId)) {
                    uniqueAccountIds.add(contact.AccountId);
                }
            }

            AccountContactService.updateActiveContactsToAccount(uniqueAccountIds);        
    }

    public static void afterUpdateHandler(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        Set<Id> uniqueAccountIds = new Set<Id>();
            for(Contact con : newContacts) {
                // Checking that contact is linked with Parent Account
                // Checking the Active status of the Account is flipped/updated
                if(String.isNotBlank(con.AccountId) 
                    && oldContactsMap.get(con.Id).IsActive__c != con.IsActive__c) {
                    uniqueAccountIds.add(con.AccountId);
                }

                // Checking the Parent Account is changed/updated
                if(oldContactsMap.get(con.Id).AccountId != con.AccountId) {
                    uniqueAccountIds.add(con.AccountId);
                    uniqueAccountIds.add(oldContactsMap.get(con.Id).AccountId);
                }
            }

            AccountContactService.updateActiveContactsToAccount(uniqueAccountIds);
    }

    public static void afterDeleteHandler(List<Contact> oldContacts) {
        Set<Id> uniqueAccountIds = new Set<Id>();
            for(Contact contact : oldContacts) {
                // Checking that contact is linked with Parent Account
                if(String.isNotBlank(contact.AccountId)) {
                    uniqueAccountIds.add(contact.AccountId);
                }
            }
            AccountContactService.updateActiveContactsToAccount(uniqueAccountIds);        
    }

    public static void afterUndeleteHandler(List<Contact> newContacts) {
        Set<Id> uniqueAccountIds = new Set<Id>();
            for(Contact contact : newContacts) {
                // Checking that contact is linked with Parent Account
                if(String.isNotBlank(contact.AccountId)) {
                    uniqueAccountIds.add(contact.AccountId);
                }
            }

            AccountContactService.updateActiveContactsToAccount(uniqueAccountIds);   
    }
}

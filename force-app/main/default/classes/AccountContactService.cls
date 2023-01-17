public with sharing class AccountContactService {
    public AccountContactService() {

    }

    public static void updateActiveContactsToAccount(Set<Id> uniqueAccountIds) {
        List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts FROM Contact
        WHERE IsActive__c = true
        AND AccountId IN :uniqueAccountIds
        GROUP BY AccountId];

        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

        // build final last contacts to update
        for(AggregateResult result : results) {
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));

            Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
            accountsToUpdate.put(accId, acc);
        }

        // update accounts with zero active contacts
        for(Id accId : uniqueAccountIds) {
            if(!accountsToUpdate.containsKey(accId)) {
                accountsToUpdate.put(accId, new Account(Id = accId, Active_Contacts__c = 0));
            }
        }
        update accountsToUpdate.values();
    }

    // ALTERNATE Solution apart from using Map
    // Using SOQL in Account obj, rather than Contact obj
    public static void updateActiveContactsToAccountAlter(Set<Id> uniqueAccountIds) {
        List<Account> results = [SELECT Id, Active_Contacts__c, 
        (SELECT Id FROM Contacts WHERE IsActive__c = true) 
        FROM Account
        WHERE Id IN: uniqueAccountIds];


        List<Account> updatedAccounts = new List<Account>();

        for(Account result : results) {
            String accId = result.Id;
            Integer contactCount = 0;

            for(Contact con : result.contacts) {
                contactCount++;
            }

            updatedAccounts.add(new Account(Id = accId, Active_Contacts__c = contactCount));
        }

        update updatedAccounts;
    }
}

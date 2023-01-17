@isTest
public with sharing class ContactTriggerHandlerTest {
    

    @TestSetup
    public static void makeData(){
        List<Account> testAccounts = new List<Account>();

        testAccounts.add(new Account(Name='Test Account 1'));
        testAccounts.add(new Account(Name='Test Account 2'));

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();

        testContacts.add(new Contact(LastName = 'Test Contact 01', AccountId = testAccounts[0].Id, IsActive__c = true));
        testContacts.add(new Contact(LastName = 'Test Contact 02', AccountId = testAccounts[0].Id, IsActive__c = true));
        testContacts.add(new Contact(LastName = 'Test Contact 03', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName = 'Test Contact 04', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName = 'Test Contact 05', AccountId = testAccounts[1].Id));

        insert testContacts;
    }

    @isTest
    public static void afterInsertHandlerTest2() {

        List<Account> accounts = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, accounts.size());

        for(Account acc : accounts) {
            if(acc.Name == 'Test Account 1') {
                System.assertEquals(2, acc.Active_Contacts__c);
            }

            if(acc.Name == 'Test Account 2') {
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }

        List<Contact> allContacts = [SELECT Id, Name FROM Contact];
        System.assertEquals(5, allContacts.size());
    }

    @isTest
    public static void afterInsertHandlerBulkTest() {

        Account testAccount1 = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        List<Contact> allContacts = new List<Contact>();

        for(Integer i=0; i<1000; i++) {
            allContacts.add(new Contact(LastName='Test Contact '+i, AccountId = testAccount1.Id, IsActive__c = true));
        }

        insert allContacts;

        List<Account> testAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, testAccounts.size());

        for(Account acc: testAccounts) {
            if(acc.Name == 'Test Account 1') {
                System.assertEquals(1002, acc.Active_Contacts__c);
            }

            if(acc.Name == 'Test Account 2') {
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }

        List<Contact> testContacts = [SELECT Id FROM Contact];

        System.assertEquals(1005, testContacts.size());
    }

    @isTest
    public static void afterUpdateHandlerTest1() {
       
        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];

        //Performing update Making Active status to true for Test contact 1 and 2
        for(Contact con : allContacts) {
            if(con.LastName == 'Test Contact 03' || con.LastName == 'Test Contact 04') {
                con.IsActive__c = true;
            }
        }

        // Create a fresh set of Governor limits, if we use after Test.startTest()
        Test.startTest();
        update allContacts;
        Test.stopTest();

        List<Account> accs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for(Account acc: accs) {
            if(acc.Name == 'Test Account 1') {
                System.assertEquals(4, acc.Active_Contacts__c);
            }

            if(acc.Name == 'Test Account 2') {
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }

        System.assertEquals(5, allContacts.size());
    }

    @isTest
    public static void afterUpdateHandlerTest2() {
        Account testAccount2 = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 2'];
        
        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];

        //Performing update Making Active status to true for Test contact 1 and 2
        for(Contact con : allContacts) {
            if(con.LastName == 'Test Contact 03') {
                con.IsActive__c = true;
                con.AccountId = testAccount2.Id;
            }
        }

        // Create a fresh set of Governor limits, if we use after Test.startTest()
        Test.startTest();
        update allContacts;
        Test.stopTest();

        List<Account> accs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for(Account acc: accs) {
            if(acc.Name == 'Test Account 1') {
                System.assertEquals(2, acc.Active_Contacts__c);
            }

            if(acc.Name == 'Test Account 2') {
                System.assertEquals(1, acc.Active_Contacts__c);
            }
        }

        System.assertEquals(5, allContacts.size());
    }

    @isTest
    public static void afterDeleteHandlerTest() {
        List<Contact> contactsToBeDeleted = [SELECT Id, LastName FROM Contact WHERE LastName IN ('Test Contact 01', 'Test Contact 05')];

        Test.startTest();
        delete contactsToBeDeleted;
        Test.stopTest();

        List<Account> allAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account];

        System.assertEquals(2, allAccounts.size());

        for(Account acc : allAccounts) {
            if(acc.Name == 'Test Account 1') {
                System.assertEquals(1, acc.Active_Contacts__c);
            }

            if(acc.Name == 'Test Account 2') {
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }

        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(3, allContacts.size());
    }
    
    @isTest
    public static void afterUnDeleteHandlerTest() {
        List<Contact> contactsToBeDeleted = [SELECT Id, LastName FROM Contact WHERE LastName IN ('Test Contact 01', 'Test Contact 05')];
        delete contactsToBeDeleted;

        Test.startTest();
        undelete contactsToBeDeleted;
        Test.stopTest();

        List<Account> allAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account];

        System.assertEquals(2, allAccounts.size());

        for(Account acc : allAccounts) {
            if(acc.Name == 'Test Account 1') {
                System.assertEquals(2, acc.Active_Contacts__c);
            }

            if(acc.Name == 'Test Account 2') {
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }

        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(5, allContacts.size());
    }


}

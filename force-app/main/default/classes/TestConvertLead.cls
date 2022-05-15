@isTest
public class TestConvertLead {
    @isTest public static void testLeadFromWeb(){
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons', LeadSource='Web', Email='we@tut.by');
		insert myLead;
    }
    
    @isTest public static void testLeadNotFromWeb(){
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons', LeadSource='Other');
        insert myLead;
    }
    
    @isTest public static void testListOfLeads(){        
        Account myAcc = new Account(Name='Belarus Poets');
        insert myAcc;
        
        List<Contact> myContactList = new List<Contact>{
            new Contact(LastName='Brouka Contact', Email='Brouka@tut.by', AccountID=myAcc.Id),
            new Contact(LastName='Kalinouski Contact', Email='Kalinouski@tut.by', AccountID=myAcc.Id)
        };
        insert myContactList;
        
        System.debug('Before merge:' + [SELECT Name, Email, MobilePhone, Account.Name FROM Contact]);
        
        List<Lead> myLeadList = new List<Lead>{
            new Lead(LastName='Brouka', Company='Brouka Co', Status='Open - Not Contacted', Email='Brouka@tut.by', LeadSource='Web', MobilePhone='Brouka Phone'),
            new Lead(LastName='Kalinouski', Company='Kalinouski Co', Status='Open - Not Contacted', Email='Kalinouski@tut.by', LeadSource='Other', MobilePhone='Kalinouski Phone'),
            new Lead(LastName='Kolas', Company='Kolas Co', Status='Open - Not Contacted', Email='Kolas@tut.by')
        };            
        insert myLeadList;
        
        System.debug('After merge:' + [SELECT Name, Email, MobilePhone, Account.Name FROM Contact]);
    }
    
    //testLeadWithOneContactWithAccount
    //testLeadWithOneContactWithNoAccount
    //testLeadWithSeveralContacts
    //testLeadWithNoContacts
    //testLeadWithSeveralContacts
    //--testLeadWithSeveralContactsOnlyOneAccont
    //--testLeadWithSeveralContactsSeveralAccounts
    //--testLeadWithSeveralContactsNoAccounts
}
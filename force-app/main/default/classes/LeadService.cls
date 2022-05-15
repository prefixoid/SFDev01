public without sharing class LeadService {
    public static void ConvertWebLead(List<Lead> newValues) {
        //return;
        List<String> leadsEmailList = new List<String>();
        for(Lead lead : newValues){
            leadsEmailList.add(lead.Email);
        }
        
        //SELECT Contacts by Mail 
        List<Contact> contactsByMailList = [SELECT Name, AccountID, Email FROM Contact WHERE Email IN :leadsEmailList];
        //Create Map with Email as a key
        Map<String, Contact> contactsByMailMap = new Map<String, Contact>();
        for(Contact con : contactsByMailList){
            contactsByMailMap.put(con.Email, con);
        }
        
        List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        for(Lead lead : newValues){
            if(lead.LeadSource=='Web'){
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(lead.id);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Contact conForMerge = contactsByMailMap.get(lead.Email);
                if(conForMerge != null){
                    lc.setAccountId(conForMerge.AccountId);
                    lc.setContactId(conForMerge.Id);
                }
                leadConvertList.add(lc);
            }
        }
        
        List<Database.LeadConvertResult> lcrList = Database.convertLead(leadConvertList);
        for(Database.LeadConvertResult lcr : lcrList){
            System.assert(lcr.isSuccess());
        }
    }
}
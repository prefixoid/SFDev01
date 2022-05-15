trigger ConvertLead on Lead (after insert) {
    return;
    List<String> leadsEmailList = new List<String>();
    for(Lead lead : Trigger.new){
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
    for(Lead lead : Trigger.new){
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

//TODO:
//a) Refactor to TriggerTemplate
//d) what if several contacts with this mail is founded
//e) Handle if Lead have no mail
//
//??
//a) Several cases might happen:
//	There is one contact with account
//	There is one contact with no account
//	There is no contacts
//	There are several contacts
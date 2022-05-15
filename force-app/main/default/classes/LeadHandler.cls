public without sharing class LeadHandler implements TriggerTemplate.Handler
{
    private List<Lead> newValues;
    private Map<Id, Lead> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues)
    {
        this.newValues = newValues;
        this.oldValues = (Map<Id, Lead>) oldValues;
    }

    public void handle(TriggerTemplate.TriggerAction action)
    {
        if (action == TriggerTemplate.TriggerAction.afterInsert)
        {
            LeadService.convertWebLead(newValues);
        }
    }
}
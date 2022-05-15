trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerTemplate.TriggerManager triggerManager = new TriggerTemplate.TriggerManager();
    triggerManager.addHandler(
        new LeadHandler(), new List<TriggerTemplate.TriggerAction>
            {
                TriggerTemplate.TriggerAction.afterInsert
            }
    );
    triggerManager.runHandlers();
}
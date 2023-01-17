({
    blockClickHandler : function(component, event, helper) {
        let open = component.get("v.open");

        if(!open) {
            component.set("v.open", true);

            // fire the block click event
            let compEvent = component.getEvent("onclick");
            const label = component.get("v.label");

            compEvent.setParams({value : label}); 
            compEvent.fire();
        }
    },

    scriptsLoaded : function(component) {
        const divElement = component.getElement(".board-block");
        fitText(divElement);
    }
})

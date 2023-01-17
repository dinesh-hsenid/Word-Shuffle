({
    addResultRecord : function(component, gameResult) {
        // Create an apex method call action
        const action = component.get("c.addResult");

        // Set method parameters
        const gameMode = component.get("v.selectedMode").toUpperCase();
        action.setParams({
            result : gameResult.toUpperCase(),
            mode : gameMode
        });

        // Define a call back
        action.setCallback(this, function(response) {
            const state = response.getState();

            if(state !== "SUCCESS") {
                console.error("Error in saving a record");
            }
        });

        // call the apex method
        $A.enqueueAction(action);
    },

    showToast : function(titleValue, messageValue, typeValue) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titleValue,
            "message": messageValue,
            "type" : typeValue
        });
        toastEvent.fire();
    }
});

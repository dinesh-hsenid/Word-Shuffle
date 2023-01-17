({
    startNewGame : function(component, event, helper) {
        // Access the combo-box 
        let gameModefromComboBox = component.find("gameMode");

        // Access the values of the combo-box
        let selectedValue = gameModefromComboBox.get("v.value");

        // Setting the selected value to the selectedGameMode attribute
        component.set("v.selectedMode", selectedValue);

        const selectedMode = component.get("v.selectedMode");

        if(selectedMode) {
            const boardComp = component.find("boardComp");
            // call Aura method from Board.cmp
            boardComp.startGame();
        }

        console.log('Start new Game button is clicked. And the selected value is: ' +selectedValue);
    },

    reshuffleBoard : function(component, event, helper) {
        const boardComp = component.find("boardComp");
        boardComp.reShuffleBoard();
        component.set("v.reshuffleDisabled", true);
    },

    onResultHandler : function(component, event, helper) {
        const result = event.getParam("result");

        if(result === "win") {
            component.set("v.reshuffleDisabled", true);
            helper.showToast("You Win", "Hooray!!!", "Success");
        }
        else {
            component.set("v.reshuffleDisabled", false);
            helper.showToast("You Lose", "Press Reshuffle button to keep playing", "Error");
        }

        helper.addResultRecord(component, result);
    }
})

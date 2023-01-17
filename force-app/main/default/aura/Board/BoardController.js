({
    doInit : function(component, event, helper) {
        console.log('Initialization completed');

        // Getting the game mode (Easy/medium/hard)
        let gameMode = component.get("v.mode");
        // Getting column values based on game mode
        let column = 0;

        if(gameMode && gameMode === "hard") {
            column = 6;
        }
        else if(gameMode === "medium") {
            column = 4;
        }
        else {
            column = 3;
        }

        let layoutSize = 12/column;
        component.set("v.layoutSize", layoutSize);

        // Calling helper method using helper.getWords()
        const words = helper.getWords(column * column);
        // Setting words from JS to Html
        component.set("v.words", words);

        // Calling helper method using helper.getWinWord()
        const winWord = helper.getWinWord(words);
        // Setting winWord from JS to Html
        component.set("v.winWord", winWord);

        helper.resetGame(component);
    },

    doRender: function (component, event, helper) {
        console.log("Render completed");
    },

    handleBlockClick : function(component, event, helper) {
        
        let clickCount = component.get("v.clickCount") + 1;
        // Get event value
        let value = event.getParam("value");

        let winWord = component.get("v.winWord");
        
        if(winWord === value) {
            component.set("v.result", "YOU WIN");
            console.log('You Win');
            helper.blockDisabled(component);
            helper.fireResultEvent("win");
        }

        else if(clickCount === 3) {
            component.set("v.result", "YOU LOSE");
            console.log('You Lose');
            helper.blockDisabled(component);
            helper.fireResultEvent("lose");
        }
        component.set("v.clickCount", clickCount);
    },

    reshuffleBoard : function(component, event, helper) {
        const words = component.get("v.words");
        const randomizeWords = helper.randomizeArray(words);
        component.set("v.words", randomizeWords);
        helper.resetGame(component);
    }

})

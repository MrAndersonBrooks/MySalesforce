({
	onFormSubmit : function(component, event, helper) {
		var data = event.getParam("formData");
       console.log(data);
        var boatSearchResultsCmp = component.find("boatSearchResultsCmp");
        if (boatSearchResultsCmp) {
            boatSearchResultsCmp.search(data.boatTypeId);
        }
	}
    
})
function validateFloorplans(inputFile) {
	var maxExceededMessage = "This file exceeds the maximum allowed file size (5 MB)";
	var extErrorMessage = "Only image files with extension: .jpg, .jpeg, or .png are allowed";
	var allowedExtension = ["jpg", "jpeg", "JPG", "JPEG", "PNG", "png", "pdf", "PDF"];
	var extName;
	var maxFileSize = $(inputFile)
		.data('max-file-size');
	var sizeExceeded = false;
	var extError = false;
	var floorPlanList = [];
	$.each(inputFile.files, function() {
		floorPlanList.push("  " + this.name)
		if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {
			sizeExceeded = true;
		};
		extName = this.name.split('.')
			.pop();
		if ($.inArray(extName, allowedExtension) == -1) {
			extError = true;
		};
	});
	if (sizeExceeded) {
		window.alert(maxExceededMessage);
		$(inputFile)
			.val('');
	};

	if (extError) {
		window.alert(extErrorMessage);

		$(inputFile)
			.val('');
	};
	if (floorPlanList.length > 0 && extError == false && sizeExceeded == false) {
		$('#floorplan-label')
			.html(floorPlanList);
		$('#fsubmit')
			.removeClass('d-none');
	}
}
function validateFiles(inputFile) {
	console.log(this);
	var maxExceededMessage = "This file exceeds the maximum allowed file size (5 MB)";
	var extErrorMessage = "Only image files with extension: .jpg, .jpeg, or .png are allowed";
	var allowedExtension = ["jpg", "jpeg", "JPG", "JPEG", "PNG", "png"];
	var extName;
	var maxFileSize = $(inputFile)
		.data('max-file-size');
	var sizeExceeded = false;
	var extError = false;
	var photoList = [];
	$.each(inputFile.files, function() {
		photoList.push("  " + this.name)
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
	if (photoList.length > 0 && extError == false && sizeExceeded == false) {
		$('#photo-label')
			.html(photoList);
		$('#psubmit')
			.removeClass('d-none');
	}
}

function validatePhotos(inputFile) {
	var maxExceededMessage = "This file exceeds the maximum allowed file size (5 MB)";
	var extErrorMessage = "Only image files with extension: .jpg, .jpeg, or .png are allowed";
	var allowedExtension = ["jpg", "jpeg", "JPG", "JPEG", "PNG", "png"];
	var extName;
	var maxFileSize = $(inputFile)
		.data('max-file-size');
	var sizeExceeded = false;
	var extError = false;
	var photoList = [];
	$.each(inputFile.files, function() {
		photoList.push("  " + this.name)
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
	if (photoList.length > 0 && extError == false && sizeExceeded == false) {
		$('#photo-label')
			.html(photoList);
		$('#fsubmit')
			.removeClass('d-none');
	}
}

function readURL(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();

		reader.onload = function(e) {
			$('#profile-avatar')
				.attr('src', e.target.result);
		}

		reader.readAsDataURL(input.files[0]); // convert to base64 string
	}
}
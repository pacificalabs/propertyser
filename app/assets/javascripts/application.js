$(document).ready(function() {
    // Utility functions

    const form = document.getElementById('photo-form');
    const updateButton = document.getElementById('update-description-btn');

    // debugger;

    if (form && updateButton) {
        form.addEventListener('change', () => {
            updateButton.classList.remove('d-none');
        });
    }

    const validateRequiredFields = (div) => {
        let isValid = true;
        div.find('input[required], select[required], textarea[required]').each(function() {
            if ($(this).val() === '') {
                $(this).addClass('is-invalid');
                isValid = false;
            } else {
                $(this).removeClass('is-invalid');
            }
        });
        return isValid;
    };

    const updateProgressIndicators = (currentIndex, newIndex) => {
        $(`.part-${currentIndex + 1}`).toggleClass('active', newIndex > currentIndex);
    };

    // Form navigation setup
    const formSections = $('div[id^="part-"]');
    let currentIndex = 0;

    const updateButtonVisibility = () => {
        $('#back-button-buy-property').toggleClass('d-none', currentIndex === 0);
        $('#next-button-buy-property').toggleClass('d-none', currentIndex === formSections.length - 1);
        $('#startSearching').toggleClass('d-none', currentIndex !== formSections.length - 1);
    };

    const navigateForm = (isNext) => {
        const currentSection = formSections.eq(currentIndex);
        if (isNext && !validateRequiredFields(currentSection)) {
            alert("Please fill in all required fields before proceeding.");
            return;
        }

        const newIndex = isNext ? currentIndex + 1 : currentIndex - 1;
        if (newIndex >= 0 && newIndex < formSections.length) {
            formSections.eq(currentIndex).addClass('d-none');
            formSections.eq(newIndex).removeClass('d-none');
            updateProgressIndicators(currentIndex, newIndex);
            currentIndex = newIndex;
            updateButtonVisibility();
        }
    };

    // Event listeners
    $('#next-button-buy-property, #back-button-buy-property').click(function(event) {
        event.preventDefault();
        navigateForm($(this).attr('id') === 'next-button-buy-property');
    });

    $('#sell-submit').click(function(event) {
        event.preventDefault();
        if (validateRequiredFields($('form'))) {
            $('form').submit();
        } else {
            alert("Please fill in all required fields before submitting.");
        }
    });

    // Initialize form
    updateButtonVisibility();

    // File validation and handling
    const maxFileSize = 5 * 1024 * 1024; // 5MB
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];
    const maxExceededMessage = "This file exceeds the maximum allowed file size (5 MB)";
    const extErrorMessage = "Only image files (jpg, jpeg, png) and PDF files are allowed";

    window.validateAndAssignFiles = function(fileType) {
        const inputFile = document.getElementById(`apartment_${fileType}`);
        inputFile.click();

        inputFile.onchange = function() {
            const dataTransfer = new DataTransfer();
            const newFileList = [];
            let isValid = true;

            Array.from(this.files).forEach(file => {
                if (file.size > maxFileSize) {
                    alert(maxExceededMessage);
                    isValid = false;
                    return;
                }

                const extName = file.name.split('.').pop().toLowerCase();
                if (!allowedExtensions.includes(extName)) {
                    alert(extErrorMessage);
                    isValid = false;
                    return;
                }

                newFileList.push(file.name);
                dataTransfer.items.add(file);
            });

            if (isValid && newFileList.length > 0) {
                updateFileList(fileType, newFileList, true);
                this.files = dataTransfer.files;
                updateSubmitButtonVisibility();
            }

            return isValid;
        };
    };

    function updateFileList(fileType, newFileList, append = false) {
        const headerElement = document.getElementById(`${fileType}-header`);
        const listElement = document.getElementById(`${fileType}-list`);

        if (newFileList.length > 0 || (append && listElement.children.length > 0)) {
            headerElement.classList.remove('d-none');
            if (!append) listElement.innerHTML = '';
            newFileList.forEach(fileName => {
                const li = document.createElement('li');
                li.textContent = fileName;
                listElement.appendChild(li);
            });
        } else {
            headerElement.classList.add('d-none');
            listElement.innerHTML = '';
        }
    }

    function updateSubmitButtonVisibility() {
        const photoInput = document.getElementById('apartment_photos');
        const floorplanInput = document.getElementById('apartment_floorplans');
        const submitButton = document.getElementById('file-submit');
        submitButton.classList.toggle('d-none', !(photoInput.files.length || floorplanInput.files.length));
    }

    function updateCategorySubmitButtonVisibility() {
        var selectedCategoryIds = $(".tag-select").val();
        // Check if any category is selected
        if (selectedCategoryIds && selectedCategoryIds.length > 0) {
            // Show the submit button
            $("#category-submit").removeClass("d-none");
        } else {
            // Hide the submit button
            $("#category-submit").addClass("d-none");
        }
    }

    // Viewport handling
    window.viewport = {
        height: window.innerHeight,
        width: window.innerWidth,
        ratio: window.devicePixelRatio
    };
    document.cookie = "viewPort=" + JSON.stringify(window.viewport);

    // Form submission handling
    $('form').on('submit', function() {
        $('#progress-circle').removeClass('d-none').fadeIn();
    });

    // Initialize file lists and submit button visibility
    if (window.location.href.includes('photos')) {
        updateSubmitButtonVisibility();
        updateFileList('photos', []);
        updateFileList('floorplans', []);
    }
    $(".tag-select").on("change", updateCategorySubmitButtonVisibility);
    updateCategorySubmitButtonVisibility();
});
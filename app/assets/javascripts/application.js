// Include this script in your application.js or equivalent
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('a[data-method]').forEach(anchor => {
        anchor.addEventListener('click', (event) => {
            event.preventDefault();
            const method = anchor.getAttribute('data-method');
            const url = anchor.getAttribute('href');

            fetch(url, {
                method: method.toUpperCase(),
                headers: {
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                }
            }).then(response => {
                if (response.ok) {
                    window.location.reload(); // Reload the page or handle success
                } else {
                    // Parse the error response
                    return response.text().then(text => {
                        // Display the error message
                        alert(text || 'An error occurred');
                    });
                }
            }).catch(error => {
                alert('An error occurred: ' + error.message);
            });
        });
    });
});

$(document).ready(function() {
    // Size of browser viewport.
    window.viewport = {
        height: window.innerHeight,
        width: window.innerWidth,
        ratio: window.devicePixelRatio
    }
    document.cookie = "viewPort=" + JSON.stringify(window.viewport);

    $('form').on('submit', function() {
        $('#progress-circle').removeClass('d-none').fadeIn();
    });

    // Function to validate required fields in the current visible section
    window.validateRequiredFields = function(currentDiv) {
        let isValid = true;
        currentDiv.find('.form-control[required]').each(function() {
            if ($(this).val().trim() === "") {
                isValid = false;
                return false; // Exit loop as soon as an empty required field is found
            }
        });
        return isValid;
    }

    // Consolidated click event for both 'next' and 'back' buttons
    $('#next-button-buy-property, #back-button-buy-property').click(function(event) {
        event.preventDefault();

        var isNext = $(this).attr('id') === 'next-button-buy-property'; // Check if it's the next button
        var DivId = $(this).attr('nextvalue');
        var currentDiv = $(`#${DivId}`);

        // If moving to the next section, validate required fields
        if (isNext && !validateRequiredFields(currentDiv)) {
            alert("Please fill in all required fields before proceeding.");
            return;
        }

        var targetDiv = isNext ? currentDiv.next() : currentDiv.prev(); // Determine target div based on button
        if (targetDiv && targetDiv.length) {
            $(this).attr('nextvalue', targetDiv.attr('id'));
            $(this).siblings('button').attr('nextvalue', targetDiv.attr('id'));

            targetDiv.removeClass("d-none");

            if (isNext) {
                // If moving forward, update button states and progress indicators
                if (targetDiv.attr('id') === "part-2") {
                    $(this).prev().removeClass("disable-btn");
                }
                var circleDiv = $(`.${targetDiv.attr('id')}`);
                if (circleDiv) {
                    circleDiv.addClass('active');
                }
            } else {
                // If moving backward, update progress indicators
                var circleDiv = $(`.${currentDiv.attr('id')}`);
                if (circleDiv) {
                    circleDiv.removeClass('active');
                    circleDiv.prev().addClass('active');
                }
            }

            currentDiv.addClass("d-none");

            if (isNext && currentDiv.attr('id') === "part-4") {
                $('#startSearching').removeClass("d-none");
                $(this).addClass('d-none');
            }
            if (!isNext && targetDiv.attr('id') === "part-1") {
                $(this).addClass('disable-btn');
            }
            if (!isNext && targetDiv.attr('id') === "part-4") {
                $('#startSearching').addClass("d-none");
                $(this).next().removeClass('d-none');
            }
        }
    });

    window.validateFloorplans = function(inputFile) {
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

    window.validateFiles = function(inputFile) {
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
            // $('#photo-label')
            // .html(photoList);
            $('#psubmit')
                .removeClass('d-none');
        }
    }

    window.validatePhotos = function(inputFile) {
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

    window.readURL = function(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function(e) {
                $('#profile-avatar')
                    .attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]); // convert to base64 string
        }
    }

    var deviceIsIpad = function(angle) {
        if (window.navigator.userAgent.includes('iPad') && angle == 0) {
            console.log(angle);
            console.log(document.location.pathname);
            if (document.location.pathname != "/ipad") {
                window.location = "/ipad";
            };
        } else {
            window.location = "/";
            return false;
        };
    };

    window.onorientationchange = function(event) {
        console.log("the orientation of the device is now " + event.target.screen.orientation.angle);
        deviceIsIpad(event.target.screen.orientation.angle);
    };

    document.onscroll = function() {
        if (window.innerHeight + window.scrollY > (document.body.clientHeight - 50)) {
            if (document.getElementById('navArrow')) {
                document.getElementById('navArrow').style.display = 'none';
            }
        } else {
            if (document.getElementById('navArrow')) {
                document.getElementById('navArrow').style.display = 'block';
            }
        }
    }

    // Iterate over each multi-select field
    $('.tag-select').each(function() {
        // Store initial selected options for each select
        let initialSelection = $(this).val();

        // Listen for changes on this specific select field
        $(this).change(function() {
            let currentSelection = $(this).val();

            // Check if the selection has changed
            if (JSON.stringify(currentSelection) !== JSON.stringify(initialSelection)) {
                // If changed, activate the submit button
                $('#category-submit').removeClass('disabled').prop('disabled', false);
                $('#category-submit').css('display', 'inline-block');
            } else {
                // If unchanged, disable the button again
                $('#category-submit').addClass('disabled').prop('disabled', true);
                $('#category-submit').css('display', 'none');

            }
        });
    });

    window.addEventListener('turbo:load', function() {
        alert()

        if ($('.alert')) {
            $('.alert').delay(1200).fadeOut();
        }

        removeLoader();
        var priceModifier = function(price) {
            price = parseInt(price);
            p = new Intl.NumberFormat()
                .format(price);
            return p;
        }

        $('#apartment_asking_price')
            .blur(function() {
                var internal = $(this)
                    .val()
                    .replace(/\D/g, '');
                if (internal) {
                    $(this)
                        .val("$" + priceModifier(internal))
                }
            });
        $('#apartment_asking_price')
            .focus(function() {
                var internal = $(this)
                    .val()
                    .replace(/\D/g, '');
                $(this)
                    .val(internal);
            });


        $('#apartment_land_size, #apartment_internal_space')
            .blur(function() {
                var internal = $(this)
                    .val()
                    .replace(/\D/g, '');
                $(this)
                    .val(internal + " sqM")
            });
        $('#apartment_land_size, #apartment_internal_space')
            .focus(function() {
                var internal = $(this)
                    .val()
                    .replace(/\D/g, '');
                $(this)
                    .val(internal);
            });

        function setMinMaxItems(selectedObject) {
            var from = ($(selectedObject)
                .data("from"));
            var to = ($(selectedObject)
                .data("to"));
            $(selectedObject).siblings('.slider-min').val(from);
            $(selectedObject).siblings('.slider-max').val(to);
            var getDiv = $("#item-display");
            var divType = $(selectedObject).attr('slider-type');
            if (getDiv && divType) {
                iconAddRemove(getDiv, divType, from, to);
            }
        }

        function rangeSlider(selectedObject) {
            if (selectedObject) {
                selectedObject.ionRangeSlider({
                    skin: "round",
                    step: 1,
                    type: "double",
                    min: 0,
                    max: 10,
                    from: 2,
                    to: 4,
                    hide_min_max: true,
                    drag_interval: true,
                    min_interval: null,
                    max_interval: null,
                    grid_snap: true
                });
                setMinMaxItems(selectedObject);
                selectedObject.on("change", function() {
                    setMinMaxItems(this);
                });
            }
        }

        var buySlider = $('#price-slider');
        var bedSlider = $('#bed-slider');
        var bathSlider = $('#bath-slider');
        var parkingSlider = $('#parking-slider');

        rangeSlider(bedSlider);
        rangeSlider(bathSlider);
        rangeSlider(parkingSlider);

        buySlider.ionRangeSlider({
            skin: "round",
            type: "double",
            min: 0,
            max: 5000000,
            from: 2000000,
            to: 3000000,
            step: 50000,
            hide_min_max: true,
            hide_from_to: true,
            drag_interval: true,
            min_interval: 25000,
            max_interval: null,
            grid_snap: true,
            prefix: "$",
            onFinish: function() {
                var slider = $("#price-slider").data("ionRangeSlider");
                if (slider) {
                    var from = slider.old_from;
                    var to = slider.old_to;
                    if (from && to) {
                        var newMin = from - ((to - from) / 2);
                        if (newMin < 0) {
                            newMin = 0;
                        }
                        slider.update({
                            min: Math.round(newMin / 50000) * 50000,
                            max: Math.round((to + ((to - from) / 2)) / 50000) * 50000
                        });
                    }
                }
            }
        });

        function currencyConvertor(amount) {
            const newAmount = (amount).toLocaleString('en-US', {
                style: 'currency',
                currency: 'USD',
                maximumSignificantDigits: 3
            });
            return newAmount;
        }

        function setBuySliderValue(selectedObject) {
            var from = ($(selectedObject)
                .data("from"));
            var to = ($(selectedObject)
                .data("to"));
            $('#from-price-range').text(currencyConvertor(from));
            $('#to-price-range').text(currencyConvertor(to));
            $('#pricing-slider-min')
                .val(from);
            $('#pricing-slider-max')
                .val(to);
        }

        //	if(buySlider) {
        //		setBuySliderValue(buySlider);
        //	}

        $("#reset-price-range").on("click", function() {
            var slider = $("#price-slider").data("ionRangeSlider");
            if (slider) {
                slider.update({
                    min: 0,
                    max: 5000000,
                    from: 2000000,
                    to: 3000000,
                });
            }
        });

        buySlider.on("change", function() {
            setBuySliderValue(this);
        });

        $('#personal-page-form')
            .change(function() {
                $('#my-details-send')
                    .removeClass('btn-outline-info')
                    .addClass('btn-outline-primary')
            });

        $('#avatar')
            .change(function() {
                readURL(this);
                $("#profile-avatar-label")
                    .text("Now click 'SAVE'")
            })

        $('a.like-reply.ml-2')
            .click(function(e) {
                $('#comment-box')
                    .find('.reply-field')
                    .removeClass('d-none')
                    .addClass('d-none');
                $(this)
                    .siblings('.reply-field')
                    .removeClass('d-none')
                    .find('.reply-box')
                    .focus();
            });

        $('.tt')
            .tooltip();

        $('input')
            .on('invalid', function(e) {
                setTimeout(function() {

                    if ($(this)
                        .scrollTop() > 1000) {
                        var newScrollTop = +500
                    } else {
                        var newScrollTop = -150
                    };

                    $('html,body')
                        .animate({
                            scrollTop: $(this)
                                .scrollTop() + newScrollTop
                        }, 0);
                }, 0);
            });

        // carousel text
        $('.carousel')
            .carousel();
        var caption = $('.carousel-caption h6');
        $('.new-caption-area')
            .html(caption.html());
        caption.css('display', 'none');
        $(".carousel")
            .on('slide.bs.carousel', function(e) {
                var caption = $('div.carousel-item:nth-child(' + ($(e.relatedTarget)
                    .index() + 1) + ') .carousel-caption h6');
                $('.new-caption-area')
                    .html(caption.html());
                caption.css('display', 'none');
            });

        function generateWidthHeightValue(iconsCount) {
            var widthHeight = 0;
            if (iconsCount <= 4) {
                widthHeight = 45;
            } else if (iconsCount <= 6) {
                widthHeight = 40;
            } else {
                widthHeight = 30;
            }
            return widthHeight;
        }

        function iconAddRemove(getDiv, divType, minValue, maxValue) {
            if (getDiv && divType) {
                var innerDiv = "";
                const widthHeightValue = generateWidthHeightValue(maxValue);
                const defaultIconStyle = `max-width: ${widthHeightValue}px; max-height: ${widthHeightValue}px;`
                if (divType === "bed") {
                    innerDiv = getDiv.find('.side-icon-bed');
                    maxImageUrl = `<img src="https://imgix-homblok1.s3-ap-southeast-2.amazonaws.com/assets/images/new_system_icons/bed.svg" alt="bed" class="side-image-icon" style='${defaultIconStyle}'>`;
                    minImageUrl = `<img src="https://imgix-homblok1.s3-ap-southeast-2.amazonaws.com/assets/images/new_system_icons/blue-bed.svg" alt="bed" class="side-image-icon" style='${defaultIconStyle}'>`;
                    iconUpdate(maxImageUrl, minImageUrl, innerDiv, minValue, maxValue);
                } else if (divType === "bath") {
                    innerDiv = getDiv.find('.side-icon-bath');
                    maxImageUrl = `<img src="https://imgix-homblok1.s3-ap-southeast-2.amazonaws.com/assets/images/new_system_icons/bath.svg" alt="bathtub" class="side-image-icon" style='${defaultIconStyle}'>`;
                    minImageUrl = `<img src="https://imgix-homblok1.s3-ap-southeast-2.amazonaws.com/assets/images/new_system_icons/blue-bath.svg" alt="bathtub" class="side-image-icon"style='${defaultIconStyle}'>`;
                    iconUpdate(maxImageUrl, minImageUrl, innerDiv, minValue, maxValue);
                } else if (divType === "parking") {
                    innerDiv = getDiv.find('.side-icon-parking');
                    maxImageUrl = `<img src="https://imgix-homblok1.s3-ap-southeast-2.amazonaws.com/assets/images/new_system_icons/car.svg" alt="car" class="side-image-icon" style='${defaultIconStyle}'>`;
                    minImageUrl = `<img src="https://imgix-homblok1.s3-ap-southeast-2.amazonaws.com/assets/images/new_system_icons/blue-car.svg" alt="car" class="side-image-icon" style='${defaultIconStyle}'>`;
                    iconUpdate(maxImageUrl, minImageUrl, innerDiv, minValue, maxValue);
                }
            }
        }

        function iconUpdate(maxImageUrl, minImageUrl, innerDiv, minValue, maxValue) {
            var collectData = "";
            var countMax = maxValue - minValue;
            for (var i = 0; i < minValue; i++) {
                collectData += minImageUrl;
            }
            if (countMax > 0) {
                for (var i = 0; i < countMax; i++) {
                    collectData += maxImageUrl;
                }
            }
            innerDiv.html(collectData);
        }

        $('.circle')
            .click(function() {
                addRemoveLoader();
                var allCircle = $('.progress div');
                var circleValue = $(this).attr('circlevalue');
                var allDiv = $('.buy-property-data div.buy-property-data-div');
                $('#startSearching').addClass("d-none");
                if (allCircle) {
                    $.each(allCircle, function(index, value) {
                        $(value).removeClass('active');
                    });
                    $(this).addClass('active');
                }
                if (allDiv) {
                    $.each(allDiv, function(index, value) {
                        $(value).addClass('d-none');
                    });
                }
                var formDiv = $(`#${circleValue}`);
                if (formDiv) {
                    formDiv.removeClass('d-none')
                    var nextButton = $('#next-button-buy-property');
                    if (nextButton) {
                        nextButton.attr('nextvalue', circleValue);
                        nextButton.prev().attr('nextvalue', circleValue);
                        nextButton.removeClass('d-none');
                        nextButton.prev().removeClass('disable-btn');
                        if (circleValue === "part-5") {
                            $('#startSearching').removeClass("d-none");
                            nextButton.addClass('d-none');
                        }
                        if (circleValue === "part-1") {
                            nextButton.prev().addClass('disable-btn');
                        }
                    }
                }
            });

        $('#scrollable-location-menu .typeahead').typeaheadmulti(null, {
            name: 'location',
            limit: 100,
            display: Handlebars.compile('{{locality}} ({{postcode}}) '),
            source: function show(data, cb, cba) {
                var url = '/search_location/' + data;
                $.ajax({
                        url: url
                    })
                    .done(function(res) {
                        const locationArray = [];
                        var locationDiv = $('#hidden-location-data').children();
                        if (locationDiv.length > 0) {
                            locationDiv.each(function() {
                                locationArray.push($(this).attr('locality'));
                            });
                            for (var i = res.length - 1; i >= 0; i--) {
                                for (var j = 0; j < locationArray.length; j++) {
                                    if (res[i] && (res[i].locality === locationArray[j])) {
                                        res.splice(i, 1);
                                    }
                                }
                            }
                        }
                        cba(res);
                    });
            },
            templates: {
                empty: [
                    "<div class='empty-message'>",
                    "Unable to find this location!!",
                    "</div>"
                ].join('\n'),
                suggestion: Handlebars.compile('<div><strong>{{locality}}</strong> ({{postcode}})</div>')
            }
        });

        $('#locations-list-input').keypress(function(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
            }
        });
    });
})
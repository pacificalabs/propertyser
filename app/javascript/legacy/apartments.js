/*
 * @Author: Tarun Mookhey
 * @Date:   2024-09-10 12:58:01
 * @Last Modified by:   Tarun Mookhey
 * @Last Modified time: 2024-09-10 13:00:18
 */

$(document)
    .on('turbo:click ajax:send direct-uploads:start',
        function() {
            addLoader();
            NProgress.start();
            NProgress.configure({
                parent: '#homblok-container'
            });
        });
$(document)
    .on('turbo:render ajax:complete direct-uploads:end', function() {
        NProgress.done();
        NProgress.remove();
        // deviceIsIpad();
    });


// function addLoader() {
//     $(".loader-gif").fadeIn('fast');
//     $('.main-content').addClass('opacity-10');
// }

// function removeLoader() {
//     $(".loader-gif").fadeOut('fast');
//     $('.main-content').removeClass('opacity-20');
// }

// function addRemoveLoader() {
//     addLoader();
//     setTimeout(() => {
//         removeLoader();
//     }, 1000);
// }
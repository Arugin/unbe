/**
 * deep_linking.js
 * Adds deep linking to links with @data-remote = true
 *
 * For getting this script to work views should be properly organized:
 *
 *  + projects
 *    - <index.html.haml>
 *        which has #projects element
 *    - <index.js.haml>
 *        which renders partial "projects_block" into #projects element
 *        with $().updateHtml() method
 *    - <_projects_block.html.haml>
 *        which has links with ":remote => true"
 *
 * This script relies heavily on "hashchange" browser event.
 * This script uses jQuery Address plugin for handling "hashchange" event
 * (jquery.address.min.js)
 *
 */

/**
 * $().updateHtml()
 *
 * updates html block on the page and rebinds addressing events
 */

(function( $ ) {
    $.fn.updateHtml = function (el) {
        //
        var disabledLink = 'javascript:void(0)';

        $.each(this, function () {
            $(this).html(el);
            $(this).find('nav.pagination a[data-remote][href!="' + disabledLink + '"],')
                .attr('href', function (i, o) { return "#" + o; })
                .address(function () {
                    return $(this).attr('href').replace(/^#/, '');
                });
        });
    }
})( jQuery );

$(function () {

    // Event listener for remote links
    $(document).on('ajax:beforeSend', 'nav.pagination a[data-remote]', function(e, xhr, settings) {
        // Block default UJS ajax requests
        return false;
    });

    // Add hashchange event listener
    if ($(".ujs-pagination").length !== 0) {
        $(document).on('ujs:complete', function () {
            $("#spinner").hide();
        });
        $.address.change(function (event) {
            // Show a spinner
            $("#spinner").show();
            // Handle remote request through UJS
            $.rails.handleRemote($(
                {
                    href: (event.value == '/') ? document.location.href : event.value
                }));
        });
    }

    // Add address events to remote links on page load
    $.address.init(function () {
        $('nav.pagination a[data-remote]').attr('href', function (i, o) { return "#" + o; })
            .address(function () {
                return $(this).attr('href').replace(/^#/, '');
            });
    });
});

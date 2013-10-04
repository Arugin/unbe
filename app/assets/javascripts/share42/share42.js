/* share42.com | 09.09.2013 | (c) Dimox */
(function ($) {
    $(function () {
        $('div.share42init').each(function (idx) {
            var el = $(this),
                u = el.attr('data-url'),
                t = el.attr('data-title'),
                i = el.attr('data-image'),
                d = el.attr('data-description'),
                f = el.attr('data-path');
            if (!u) u = location.href;

            function fb_count(url) {
                var shares;
                console.log ('http://graph.facebook.com/?callback=?&ids=' + encodeURIComponent(url));
                $.getJSON('http://graph.facebook.com/?callback=?&ids=' + encodeURIComponent(url), function (data) {
                    shares = (data[url].shares || 0);
                    el.find('a[data-count="fb"]').html('<span>' + shares + '</span>');
                });
            }
            fb_count(u);

            function twi_count(url) {
                var shares;
                $.getJSON('http://urls.api.twitter.com/1/urls/count.json?callback=?&url=' + url, function (data) {
                    shares = data.count;
                    el.find('a[data-count="twi"]').html('<span>' + shares + '</span>');
                });
            }
            twi_count(u);

            function vk_count(url) {
                var shares;
                $.getScript('http://vk.com/share.php?act=count&index=' + idx + '&url=' + url);
                if (!window.VK) window.VK = {};
                window.VK.Share = {
                    count: function (idx, number) {
                        shares = number;
                        $('div.share42init').eq(idx).find('a[data-count="vk"]').html('<span>' + shares + '</span>');
                    }
                };
            }
            vk_count(u);
            if (!f) {
                function path(name) {
                    var sc = document.getElementsByTagName('script'),
                        sr = new RegExp('^(.*/|)(' + name + ')([#?]|$)');
                    for (var i = 0, scL = sc.length; i < scL; i++) {
                        var m = String(sc[i].src).match(sr);
                        if (m) {
                            if (m[1].match(/^((https?|file)\:\/{2,}|\w:[\/\\])/)) return m[1];
                            if (m[1].indexOf("/") == 0) return m[1];
                            b = document.getElementsByTagName('base');
                            if (b[0] && b[0].href) return b[0].href + m[1];
                            else return document.location.pathname.match(/(.*[\/\\])/)[0] + m[1];
                        }
                    }
                    return null;
                }
                f = path('share42.js');
            }
            if (!t) t = document.title;
            if (!d) {
                var meta = $('meta[name="description"]').attr('content');
                if (meta !== undefined) d = meta;
                else d = '';
            }
            u = encodeURIComponent(u);
            t = encodeURIComponent(t);
            t = t.replace(/\'/g, '%27');
            i = encodeURIComponent(i);
            d = encodeURIComponent(d);
            d = d.replace(/\'/g, '%27');
            var fbQuery = 'u=' + u;
            if (i != 'null' && i != '') fbQuery = 's=100&p[url]=' + u + '&p[title]=' + t + '&p[summary]=' + d + '&p[images][0]=' + i;
            var vkImage = '';
            if (i != 'null' && i != '') vkImage = '&image=' + i;
            var s = new Array('"#" data-count="fb" onclick="window.open(\'http://www.facebook.com/sharer.php?' + fbQuery + '\', \'_blank\', \'scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0\');return false" title="Поделиться в Facebook"', '"#" onclick="window.open(\'https://plus.google.com/share?url=' + u + '\', \'_blank\', \'scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0\');return false" title="Поделиться в Google+"', '"#" data-count="twi" onclick="window.open(\'https://twitter.com/intent/tweet?text=' + t + '&url=' + u + '\', \'_blank\', \'scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0\');return false" title="Добавить в Twitter"', '"#" data-count="vk" onclick="window.open(\'http://vk.com/share.php?url=' + u + '&title=' + t + vkImage + '&description=' + d + '\', \'_blank\', \'scrollbars=0, resizable=1, menubar=0, left=100, top=100, width=550, height=440, toolbar=0, status=0\');return false" title="Поделиться В Контакте"');
            var l = '';
            for (j = 0; j < s.length; j++) l += '<a rel="nofollow" style="display:inline-block;vertical-align:bottom;width:32px;height:32px;margin:0 6px 6px 0;padding:0;outline:none;background:url(' + f + 'icons.png) -' + 32 * j + 'px 0 no-repeat" href=' + s[j] + ' target="_blank"></a>';
            el.html('<span id="share42">' + l + '</span>');
        })
    })
})(jQuery);
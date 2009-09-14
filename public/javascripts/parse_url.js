//parse a URL to form an object of properties
function parseURL(url)
{
    //save the unmodified url to href property
    //so that the object we get back contains
    //all the same properties as the built-in location object
    var loc = { 'href' : url };

    //split the URL by single-slashes to get the component parts
    var parts = url.replace('//', '/').split('/');

    //store the protocol and host
    loc.protocol = parts[0];
    loc.host = parts[1];

    //extract any port number from the host
    //from which we derive the port and hostname
    parts[1] = parts[1].split(':');
    loc.hostname = parts[1][0];
    loc.port = parts[1].length > 1 ? parts[1][1] : '';

    //splice and join the remainder to get the pathname
    parts.splice(0, 2);
    loc.pathname = '/' + parts.join('/');

    //extract any hash and remove from the pathname
    loc.pathname = loc.pathname.split('#');
    loc.hash = loc.pathname.length > 1 ? '#' + loc.pathname[1] : '';
    loc.pathname = loc.pathname[0];

    //extract any search query and remove from the pathname
    loc.pathname = loc.pathname.split('?');
    loc.search = loc.pathname.length > 1 ? '?' + loc.pathname[1] : '';
    loc.pathname = loc.pathname[0];

    //return the final object
    return loc;
}
xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $id := request:get-parameter('id','')
let $filename := concat($id,'.xml')

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')
let $removed := xmldb:remove('/db/apps/basar/data/sellers', $filename)

return 
    '"Seller removed: ' || $id || '"'
    
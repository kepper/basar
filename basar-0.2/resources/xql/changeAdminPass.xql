xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $adminUser := request:get-parameter('adminUser','')
let $oldPass := request:get-parameter('oldPass','')
let $newPass := request:get-parameter('newPass','')

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')

let $config := doc('/db/apps/basar/config.xml')//config

let $update8 := update value $config/admin/@user with $adminUser
let $update9 := if($oldPass = $config/admin/@password) then(update value $config/admin/@password with $newPass) else()

return 
    'Values updated'
    
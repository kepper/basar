xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $name := request:get-parameter('name','')
let $mail := request:get-parameter('mail','')
let $id := request:get-parameter('id','')
let $old.id := request:get-parameter('oldID','')

let $filename := concat(replace($name,'\s',''),'.xml')
let $newDoc := <seller xml:id="{$id}" name="{$name}" mail="{$mail}"/>

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')

let $removed := xmldb:remove('/db/apps/basar/data/sellers', $old.id || '.xml')
let $store := xmldb:store('/db/apps/basar/data/sellers', $filename, $newDoc)

return 
    '"Document removed: ' || $old.id || ', Document stored: ' || $store || '"'
    
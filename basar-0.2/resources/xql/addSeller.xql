xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $name := request:get-parameter('name','')
let $mail := request:get-parameter('mail','')
let $id := request:get-parameter('id','')
let $pass := request:get-parameter('pass','')
let $cake := request:get-parameter('cake','')


let $filename := concat(replace($name,'\s',''),'.xml')
let $doc := <seller xml:id="{$id}" name="{$name}" mail="{$mail}" cake="{$cake}" password="{$pass}"/>

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')
let $exists := doc-available(concat('/db/apps/basar/data/sellers/',$filename))

let $store := if($exists) then() else(xmldb:store('/db/apps/basar/data/sellers', $filename, $doc))
let $response := if($exists) 
                then(concat('Verkäufer ',$id,' existiert bereits. Bitte gib einen anderen Namen ein.')) 
                else(concat('Verkäufer ',$id,' erfolgreich angelegt. Bitte mit diesem Namen und dem gewählten Passwort anmelden, um Artikellisten zu bearbeiten.'))

return 
    $response
    
    
    
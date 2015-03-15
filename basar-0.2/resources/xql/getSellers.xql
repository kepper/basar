xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $collection := collection('/db/apps/basar/data/sellers')
let $sellers := $collection//seller
let $sellersArray := for $seller at $i in $sellers
                    let $num := $i
                    let $name := $seller/@name
                    let $mail := $seller/@mail
                    let $id := $seller/@xml:id
                    return
                        '{' ||
                            '"name":"' || $name || '",' ||
                            '"mail":"' || $mail || '",' ||
                            '"num":"' || $num || '",' ||
                            '"id":"' || replace($name,'\s','') || '"' ||
                        '}'
                        
return 
    '[' ||
        string-join($sellersArray,',') ||
    ']'
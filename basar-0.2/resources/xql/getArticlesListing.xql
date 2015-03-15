xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace uuid="java:java.util.UUID";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

(:uuid:randomUUID():)

declare function local:getArticles($seller as element(), $configDoc as node()) as xs:string {
    if($seller/article)
    then(
        let $articles := for $article at $i in $seller/article
                        return 
                            '{"id":"' || $article/@xml:id || '",' ||
                            '"desc":"' || $article/@desc || '",' ||
                            '"n":"' || $i || '",' ||
                            '"price":"' || $article/@price || '",' ||
                            '"size":"' || $article/@size || '"' ||
                            '}'
                        
        return '[' || string-join($articles,',') || ']'
    )
    else(
        let $articles := for $i in (1 to (number($configDoc//sellers/@items) cast as xs:integer))
                        return 
                            '{"id":"' || $seller/@xml:id || '_article' || $i || '",' ||
                            '"desc":"",' ||
                            '"n":"' || $i || '",' ||
                            '"price":"0.00",' ||
                            '"size":"80"' ||
                            '}'
        return '[' || string-join($articles,',') || ']'
    )
};

let $user := request:get-parameter('user','')
let $pass := request:get-parameter('pass','')

let $seller := collection('/db/apps/basar/data/sellers')//seller[@xml:id = $user]
let $configDoc := doc('/db/apps/basar/config.xml') 


let $result := if(exists($seller) and $pass = $seller/@password)
                then(local:getArticles($seller, $configDoc))
                else('[]')

return 
    $result
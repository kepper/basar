xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')
let $sellers := collection('/db/apps/basar/data/sellers')//seller
(:
let $updates := for $seller at $i in $sellers
                let $articleN := for $article at $j in $seller/article
                                 return
                                    if($article/@desc = '')
                                    then(update delete $article)
                                    else()
                                    
                return
                    'done':)

(:let $updates := $sellers[article[@size != '' and string(number(@size)) = 'NaN']]/@name:)

(:let $problemSellers := $sellers[article[@price = '']]

let $updates := for $x in $problemSellers
                let $items := for $item in $x/article[@price = '']
                              return
                                $item/@desc || ' (Größe ' || $item/@size || ')'
                                
                return
                    $x/@name || ' (' || $x/@mail || ', ' || count($items) || ' Artikel): ' || string-join($items,' // '):)

let $articles := $sellers//article[contains(@desc,'Töpfchen')]

let $updates := for $article in $articles
                let $seller := $article/parent::seller
                return
                    ( $seller/@name || ': ' || $article/@desc)


(:let $updates := collection('/db/apps/basar/data/sells')//sell[contains(.,'66-48')]/@xml:id:)

(:
let $objects := for $article in $items
                let $id := $article/@xml:id
                let $desc := $article/@desc
                let $price := $article/@price
                let $size := $article/@size
                let $article := <article xml:id="{$id}" desc="{$desc}" price="{$price}" size="{$size}"/>
                
                let $seller := collection('/db/apps/basar/data/sellers')//seller[@xml:id = substring-before($id,'_article')]
                let $processing := if(exists($seller/article[@xml:id = $id]))
                                   then(update replace $seller/article[@xml:id = $id] with $article)
                                   else(update insert $article into $seller)
                return 
                    $seller/@name
:)

(:let $filename := concat(replace($name,'\s',''),'.xml')
let $doc := <seller xml:id="{$id}" name="{$name}" mail="{$mail}" cake="{$cake}" password="{$pass}"/>
:)
(:let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', 'ehsittal')
let $exists := doc-available(concat('/db/apps/basar/data/sellers/',$filename))

let $store := if($exists) then() else(xmldb:store('/db/apps/basar/data/sellers', $filename, $doc))
let $response := if($exists) 
                then(concat('Verkäufer ',$id,' existiert bereits. Bitte gib einen anderen Namen ein.')) 
                else(concat('Verkäufer ',$id,' erfolgreich angelegt. Bitte mit diesem Namen und dem gewählten Passwort anmelden, um Artikellisten zu bearbeiten.'))
:)
return 
    (:$response:)
    (:string-length($post-data):)
    count($updates) || ': ' || string-join($updates,' – ')
    
    
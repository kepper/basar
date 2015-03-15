xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $inputString := request:get-parameter('items','')
let $itemIDs := tokenize($inputString,',')

(:let $items := collection('/db/apps/basar/data/sellers')//article[@xml:id = $itemIDs]:)
let $items := for $itemID in $itemIDs
              let $seller.n := number(substring-before($itemID,'-'))
              let $article.n := number(substring-after($itemID,'-'))
              let $seller := collection('/db/apps/basar/data/sellers')//seller[@n = $seller.n]
              let $article := $seller/article[@article.n = $article.n]
              return $article

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')
let $done := for $item in $items
             let $update := update insert attribute sold {'true'} into $item
             return
                $item

let $protocol.id := concat('sell_',replace(replace(string(current-dateTime()),':','_'),'\+','-'))
let $protocol := <sell xml:id="{$protocol.id}" when="{current-dateTime()}" sum="{sum($items/@price)}" articles="{count($itemIDs)}">{$inputString}</sell>
let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')
let $verkauf := xmldb:store('/db/apps/basar/data/sells', $protocol.id || '.xml', $protocol)

return 
    count($items)
    
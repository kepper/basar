xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace uuid="java:java.util.UUID";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=no";

let $itemID := request:get-parameter('item','')

let $seller.n := number(substring-before($itemID,'-'))
let $article.n := number(substring-after($itemID,'-'))

let $article := collection('/db/apps/basar/data/sellers')//seller[@n = $seller.n]/article[@article.n = $article.n]

return 

    concat('{"exists":',exists($article),',"desc":"',$article/@desc,'","price":"',$article/@price,'","size":"',$article/@size,'","sold":',if($article/@sold = 'true') then('true') else('false'),'}')
    
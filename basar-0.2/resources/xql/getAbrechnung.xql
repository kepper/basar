xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace uuid="java:java.util.UUID";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=no";


let $sellers := collection('/db/apps/basar/data/sellers')//seller
let $config := doc('/db/apps/basar/config.xml')//config

let $sellers.string := for $seller in $sellers
                       let $percent := if($seller/@organizer and $seller/@organizer = 'true') then('0%') else(if($seller/@cake = 'true') then($config/margins/@reduced || '%') else($config/margins/@percent || '%'))
                       let $ratio := if($seller/@organizer and $seller/@organizer = 'true') then(1) else(if($seller/@cake = 'true') then((100 - number($config/margins/@reduced)) div 100) else((100 - number($config/margins/@percent)) div 100))
                       let $fixedPrice := if($seller/@organizer and $seller/@organizer = 'true') then(0) else(number($config/margins/@fix))
                       let $articles := $seller/article
                       let $articles.string := for $article in $articles
                                               (:order by $article/@sold:)
                                               return
                                                '{' ||
                                                    '"desc":"' || $article/@desc || '",'||
                                                    '"sold":' || (if($article/@sold = 'true') then('true') else('false')) || ','||
                                                    '"price":"' || $article/@price || '",'||
                                                    '"size":"' || $article/@size || '",'||
                                                    '"itemNo":"' || $seller/@n || '-' || $article/@article.n || '",'||
                                                    '"n":"' || $article/@article.n || '"'||
                                                '}'
                       let $brutto := sum($seller//article[@sold = 'true']/@price)
                       let $netto := (round($brutto * $ratio * 2) div 2) - $fixedPrice
                       
                       return
                            '{' ||
                                '"name":"' || $seller/@name || '",'||
                                '"mail":"' || $seller/@mail || '",'||
                                '"id":"' || $seller/@xml:id || '",'||
                                '"n":"' || $seller/@n || '",'||
                                '"percent":"' || $percent || '",'||
                                '"fixed":"' || $fixedPrice || '",'||
                                '"brutto":"' || $brutto || '",'||
                                '"netto":"' || $netto || '",'||
                                '"articles":[' || string-join($articles.string,',') || ']'||
                            '}'
let $sells := collection('/db/apps/basar/data/sells')//sell
let $soldArticles := sum($sells/@articles)
let $salesVolume := sum($sellers//article[@sold = 'true']/@price)
let $totalValue := sum($sellers//article/@price)

return 
    '{' ||
        '"sells":' || count($sells) || ',' ||
        '"soldArticles":' || $soldArticles || ',' ||
        '"salesVolume":' || $salesVolume || ',' ||
        '"totalValue":' || $totalValue || ',' ||
        '"date":"' || current-dateTime() || '",' ||
        '"sellers":[' || string-join($sellers.string,',') || ']' ||
    '}'
        
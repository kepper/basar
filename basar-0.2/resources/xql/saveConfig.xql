xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

let $sellerCount := request:get-parameter('sellerCount','')
let $itemCount := request:get-parameter('itemCount','')
let $marginPercent := request:get-parameter('marginPercent','')
let $marginPercentReduced := request:get-parameter('marginPercentReduced','')
let $marginFix := request:get-parameter('marginFix','')
let $cakesMax := request:get-parameter('cakesMax','')
let $biddingStartDate := request:get-parameter('biddingStartDate','')
let $biddingStartTime := request:get-parameter('biddingStartTime','')

let $login := xmldb:login('/db/apps/basar/data/sellers', 'admin', '')

let $config := doc('/db/apps/basar/config.xml')//config

let $update1 := update value $config/sellers/@max with $sellerCount
let $update2 := update value $config/sellers/@items with $itemCount
let $update3 := update value $config/margins/@percent with $marginPercent
let $update4 := update value $config/margins/@reduced with $marginPercentReduced
let $update5 := update value $config/margins/@fix with $marginFix
let $update6 := update value $config/cakes/@max with $cakesMax
let $update7 := update value $config/bidding/@startDate with $biddingStartDate
let $update8 := update value $config/bidding/@startTime with $biddingStartTime

return 
    'Values updated'
    
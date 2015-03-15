xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace uuid="java:java.util.UUID";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

(:uuid:randomUUID():)

declare function local:getPrice($price as xs:string) as xs:string {
    let $comma := if(contains($price,'.'))
                then(replace($price,'\.',','))
                else($price)
                
    let $trailing := if(contains($comma,','))
                     then(
                        if(contains($comma,',5'))
                        then(substring-before($comma,',') || ',50')
                        else(substring-before($comma,',') || ',00')
                     )
                     else($comma || ',00')
                     
    return $trailing
};

declare function local:getSellerHTML($seller as element(), $num as xs:integer) as element()? {
    
    let $name := $seller/@name
    let $articles := $seller/article
    
    return
        
        <div class="seller">
            {
                for $article at $i in $articles
                let $break := if($i mod 24 = 0)
                              then(' break')
                              else('')
                return
                    <div data-seller="{$seller/@xml:id}" class="article{$break}">
                        <div class="id">Verkäufer {string($seller/@name)} | Artikel {string($article/@n)}</div>
                        <div class="size">{string($article/@size)}</div>
                        <img class="barCode" id="{format-number($seller/@n,'000')}-{format-number($article/@article.n,'00')}"></img>
                        <div class="desc">{string($article/@desc)}</div>
                        <div class="price">{local:getPrice(format-number(number($article/@price),'##0.00'))}</div>
                    </div>
            }
            
            {
                if(count($articles) lt 72)
                then(
                    for $placeholder at $j in ((count($articles) + 1) to 72)
                    let $break := if($j mod 24 = 0)
                                  then(' break')
                                  else('')
                    return
                        <div class="article placeholder{$break}"></div>
                )
                else()
            }
        </div>
        
};

(:let $sellers := collection('/db/apps/basar/data/sellers')//seller
:)

let $sellers := doc('/db/apps/basar/backup/sellersTemp/nachReichungen.xml')//seller

return 
    <div>
        {
            for $seller at $i in $sellers
            return local:getSellerHTML($seller,$i)
        }
    </div>
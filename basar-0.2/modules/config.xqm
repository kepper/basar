xquery version "3.0";

(:~
 : A set of helper functions to access the application context from
 : within a module.
 :)
module namespace config="https://github.com/kepper/basar/config";

declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace expath="http://expath.org/ns/pkg";

(: 
    Determine the application root collection from the current module load path.
:)
declare variable $config:app-root := 
    let $rawPath := system:get-module-load-path()
    let $modulePath :=
        (: strip the xmldb: part :)
        if (starts-with($rawPath, "xmldb:exist://")) then
            if (starts-with($rawPath, "xmldb:exist://embedded-eXist-server")) then
                substring($rawPath, 36)
            else
                substring($rawPath, 15)
        else
            $rawPath
    return
        substring-before($modulePath, "/modules")
;

declare variable $config:data-root := $config:app-root || "/data";

declare variable $config:repo-descriptor := doc(concat($config:app-root, "/repo.xml"))/repo:meta;

declare variable $config:expath-descriptor := doc(concat($config:app-root, "/expath-pkg.xml"))/expath:package;

declare variable $config:basar := doc(concat($config:app-root,"/config.xml"))//config;

(:~
 : Resolve the given path using the current application context.
 : If the app resides in the file system,
 :)
declare function config:resolve($relPath as xs:string) {
    if (starts-with($config:app-root, "/db")) then
        doc(concat($config:app-root, "/", $relPath))
    else
        doc(concat("file://", $config:app-root, "/", $relPath))
};

(:~
 : Returns the repo.xml descriptor for the current application.
 :)
declare function config:repo-descriptor() as element(repo:meta) {
    $config:repo-descriptor
};

(:~
 : Returns the expath-pkg.xml descriptor for the current application.
 :)
declare function config:expath-descriptor() as element(expath:package) {
    $config:expath-descriptor
};

declare %templates:wrap function config:app-title($node as node(), $model as map(*)) as text() {
    $config:expath-descriptor/expath:title/text()
};

declare function config:app-meta($node as node(), $model as map(*)) as element()* {
    <meta xmlns="http://www.w3.org/1999/xhtml" name="description" content="{$config:repo-descriptor/repo:description/text()}"/>,
    for $author in $config:repo-descriptor/repo:author
    return
        <meta xmlns="http://www.w3.org/1999/xhtml" name="creator" content="{$author/text()}"/>
};

(:~
 : For debugging: generates a table showing all properties defined
 : in the application descriptors.
 :)
declare function config:app-info($node as node(), $model as map(*)) {
    let $expath := config:expath-descriptor()
    let $repo := config:repo-descriptor()
    return
        <table class="app-info">
            <tr>
                <td>app collection:</td>
                <td>{$config:app-root}</td>
            </tr>
            {
                for $attr in ($expath/@*, $expath/*, $repo/*)
                return
                    <tr>
                        <td>{node-name($attr)}:</td>
                        <td>{$attr/string()}</td>
                    </tr>
            }
            <tr>
                <td>Controller:</td>
                <td>{ request:get-attribute("$exist:controller") }</td>
            </tr>
        </table>
};


declare %templates:wrap function config:basar-maxSellers($node as node(), $model as map(*)) as xs:string {
    $config:basar/sellers/@max
};

declare %templates:wrap function config:basar-itemsPerSeller($node as node(), $model as map(*)) as xs:string {
    $config:basar/sellers/@items
};

declare %templates:wrap function config:basar-marginsPercent($node as node(), $model as map(*)) as xs:string {
    concat($config:basar/margins/@percent,'%')
};

declare %templates:wrap function config:basar-marginsReduced($node as node(), $model as map(*)) as xs:string {
    concat($config:basar/margins/@reduced,'%')
};

declare %templates:wrap function config:basar-maxCakes($node as node(), $model as map(*)) as xs:string {
    $config:basar/cakes/@max
};

declare %templates:wrap function config:basar-marginsFix($node as node(), $model as map(*)) as xs:string {
    concat($config:basar/margins/@fix,'€')
};

declare %templates:wrap function config:basar-registrationStart($node as node(), $model as map(*)) as xs:string {
    concat(substring($config:basar/bidding/@startDate,9,2),'. ',substring($config:basar/bidding/@startDate,6,2),'. ',substring($config:basar/bidding/@startDate,1,4),', ',$config:basar/bidding/@startTime,' Uhr')
};

declare %templates:wrap function config:basar-articleListing($node as node(), $model as map(*)) as xs:string {
    concat(substring($config:basar/articleListing/@endDate,9,2),'. ',substring($config:basar/articleListing/@endDate,6,2),'. ',substring($config:basar/articleListing/@endDate,1,4),', ',$config:basar/articleListing/@endTime,' Uhr')
};

declare %templates:wrap function config:basar-registration($node as node(), $model as map(*)) as node() {
    let $sellers := count(collection(concat($config:app-root,"/data/sellers"))//seller)
    let $sellersMax := number($config:basar/sellers/@max)
    let $startDate := xs:date($config:basar/bidding/@startDate)
    let $startTime := xs:time(if(string-length($config:basar/bidding/@startTime) = 5) then(concat($config:basar/bidding/@startTime,':00')) else($config:basar/bidding/@startTime))
    
    let $rightDate := boolean(current-date() ge $startDate)
    let $rightTime := boolean(current-time() ge $startTime)
    
    let $freeSlots := boolean($sellers lt $sellersMax)
    
    let $result := if(not($rightTime and $rightDate))
                    then(
                        <div>
                            Die Registrierung ist erst ab dem <b>{concat(substring($config:basar/bidding/@startDate,9,2),'. ',substring($config:basar/bidding/@startDate,6,2),'. ',substring($config:basar/bidding/@startDate,1,4),', ',$config:basar/bidding/@startTime,' Uhr')}</b> möglich.
                        </div>
                    )
                    else(
                        if($freeSlots)
                        then(
                            <div>
                                <a class="btn" href="#" id="registerBtn">Zum Verkauf registrieren</a>
                            </div>
                        )
                        else(
                            <div>
                                Leider haben sich bereits {string($sellersMax)} Verkäufer/innen registriert. Weitere Registrierungen können
                                nicht angenommen werden. 
                            </div>
                        )
                    )
    
    return
        $result
};

declare %templates:wrap function config:basar-promiseCake($node as node(), $model as map(*)) as node() {
    
    let $cakes := count(collection(concat($config:app-root,"/data/sellers"))//seller[@cake = 'true'])
    let $cakesMax := number($config:basar/cakes/@max)
    
    let $result := if($cakes lt $cakesMax)
                    then(
                        <div class="control-group">
                            <div class="controls">
                                <label class="checkbox">
                                    <input id="promiseCake" type="checkbox"/> Ich werde einen Kuchen spenden
                                </label>
                            </div>
                        </div>
                    )
                    else(<div>Es wurden bereits ausreichend Kuchen gespendet, so dass keine weiteren Kuchen angenommen werden können.</div>)
    
    return
        $result
};

declare %templates:wrap function config:basar-countSellers($node as node(), $model as map(*)) as xs:string {
    string(count(collection(concat($config:app-root,"/data/sellers"))//seller))
};
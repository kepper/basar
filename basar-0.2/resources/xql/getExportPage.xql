xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

declare function local:getExportPage() as element() {

    let $sellers := collection('/db/apps/basar/data/sellers')//seller
    let $sellers.woArticles := $sellers[not(article)]
    let $sellers.articlesWoDesc := $sellers[article[@desc = '']]

    return
        <div id="exportPage">
            <div class="page-header">
                <h1>Export der Verkaufsetiketten</h1>
                <p>
                    Hier können die Verkaufstetiketten exportiert werden. Dazu einfach den Knopf "Etiketten erzeugen"
                    drücken. Dann wird die gesamt Seite durch die Etiketten für alle Verkäufer/innen ersetzt. Diese 
                    Seite muss dann ausgedruckt werden – erst dann stimmt die Formatierung. Es empfiehlt sich, zunächst
                    ein PDF zu erstellen und das dann zu überprüfen, ob alles so stimmt wie gewünscht.
                </p>
            </div>
            <div>
                <dl>
                    <dt>Benutzer ohne Artikel: {count($sellers.woArticles)}</dt>
                    <dd>{string-join($sellers.woArticles/@name,', ')}</dd>
                    <dt>Benutzer mit Artikeln ohne Beschreibung: {count($sellers.articlesWoDesc) + count($sellers.woArticles)}</dt>
                    <dd>{string-join($sellers.articlesWoDesc/@name,', ') || ', ' || string-join($sellers.woArticles/@name,', ')}</dd>
                </dl>
            </div>
            <hr/>
            <div>
                <a class="btn btn-primary" href="#" id="generateBadgesBtn">Etiketten erzeugen</a>
            </div>
        </div>
};

let $user := request:get-parameter('user','')
let $pass := request:get-parameter('pass','')

let $configDoc := doc('/db/apps/basar/config.xml')

let $result := if($user = $configDoc//admin/@user and $pass = $configDoc//admin/@password)
                then(local:getExportPage())
                else(<div>Falsches Passwort. Bitte neu laden.</div>)

let $login := xmldb:login('/db/apps/basar/data/sellers', string($configDoc//admin/@user), string($configDoc//admin/@password))



return 
    $result
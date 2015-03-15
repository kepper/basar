xquery version "3.0";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace transform="http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xml media-type=text/plain omit-xml-declaration=yes indent=yes";

declare function local:getConfigPage($config as element()) as element() {
    <div id="configPage">
        <div class="page-header">
            <h1>Konfiguration</h1>
            <p>
                Hier können alle wesentlichen Einstellungen des Basars geändert werden. Bitte aufpassen: Nicht während des laufenden Basars ändern ;-)
            </p>
        </div>
        <div class="row-fluid" style="position: relative;">
            <div class="span5">
                <h3>Allgemeine Einstellungen</h3>
                <form class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label" for="sellerCount">Anzahl Verkäufer/innen</label>
                        <div class="controls">
                            <input type="number" id="sellerCount" placeholder="100" value="{$config/sellers/@max}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="itemCount">Anzahl Artikel je Verkäufer/in</label>
                        <div class="controls">
                            <input type="number" id="itemCount" placeholder="80" value="{$config/sellers/@items}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="marginPercent">Umsatzbeteiligung (Prozent)</label>
                        <div class="controls">
                            <input type="number" id="marginPercent" placeholder="15" step="0.5" value="{$config/margins/@percent}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="marginPercentReduced">Umsatzbeteiligung reduziert (Prozent)</label>
                        <div class="controls">
                            <input type="number" id="marginPercentReduced" placeholder="10" step="0.5" value="{$config/margins/@reduced}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="marginFix">Verkaufsgebühr (in Euro)</label>
                        <div class="controls">
                            <input type="number" id="marginFix" placeholder="1.00" step="0.01" value="{$config/margins/@fix}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="cakesMax">Anzahl Kuchenspenden</label>
                        <div class="controls">
                            <input type="number" id="cakesMax" placeholder="1.00" value="{$config/cakes/@max}"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="span5">
            <h3>Zeitplanung</h3>
                <form class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label" for="biddingStartDate">Beginn der Registrierung (Datum)</label>
                        <div class="controls">
                            <input type="date" id="biddingStartDate" placeholder="2015-01-03" value="{$config/bidding/@startDate}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="biddingStartTime">Beginn der Registrierung (Uhrzeit)</label>
                        <div class="controls">
                            <input type="time" id="biddingStartTime" placeholder="10:00:00" value="{$config/bidding/@startTime}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="articleListingEndDate">Letztmögliche Artikelbeschreibung (Datum)</label>
                        <div class="controls">
                            <input type="date" id="articleListingEndDate" placeholder="2015-03-10" value="{$config/articleListing/@endDate}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="articleListingEndTime">Letztmögliche Artikelbeschreibung (Uhrzeit)</label>
                        <div class="controls">
                            <input type="time" id="articleListingEndTime" placeholder="10:00:00" value="{$config/articleListing/@endTime}"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="span2">
                <a href="#" id="saveBtn" class="btn" style="position: absolute; bottom: 10px; right: 10px;">Aktualisierte Daten speichern</a>
            </div>
        </div>
        <hr/>
        <div class="row-fluid" style="position: relative;">
            <div class="span5">
                <h3>Benutzerdaten</h3>
                <form class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label" for="inputUser">Benutzername (Administrator)</label>
                        <div class="controls">
                            <input type="text" id="inputUser" placeholder="admin" value="{$config/admin/@user}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="oldPassword">Altes Passwort</label>
                        <div class="controls">
                            <input type="password" id="oldPassword" placeholder="Passwort"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputPassword">Neues Passwort</label>
                        <div class="controls">
                            <input type="password" id="inputPassword" placeholder="Passwort"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="inputPassword2">Neues Passwort (Wiederholung)</label>
                        <div class="controls">
                            <input type="password" id="inputPassword2" placeholder="Passwort"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="span7">
                <a href="#" id="passBtn" class="btn" style="position: absolute; bottom: 10px; right: 10px;">Basar-Administrator aktualisieren</a>
            </div>
        </div>
    </div>
};

let $user := request:get-parameter('user','')
let $pass := request:get-parameter('pass','')

let $configDoc := doc('/db/apps/basar/config.xml')

let $result := if($user = $configDoc//admin/@user and $pass = $configDoc//admin/@password)
                then(local:getConfigPage($configDoc//config))
                else(<div>Nüscht</div>)

let $login := xmldb:login('/db/apps/basar/data/sellers', string($configDoc//admin/@user), string($configDoc//admin/@password))



return 
    $result
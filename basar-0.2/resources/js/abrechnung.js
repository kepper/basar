function renderPrice(price) {
    return parseFloat(price).toFixed(2).toString().replace('.',',') + ' €';
}

var holeDaten = function() {
    
    new jQuery.getJSON('resources/xql/getAbrechnung.xql',function(results) {
        
        var overview = '<div class="page"><h1>Abrechnung</h1><div>' + results.date + '</div><div>Umsatz: '+ renderPrice(results.salesVolume)+ ' (' + results.sells +' Verkäufe mit insgesamt '+ results.soldArticles +' Artikeln)</div><div>Warenwert (Gesamt): ' + renderPrice(results.totalValue) + '</div></div>';
        
        $('#abrechnungContainer').append(overview);
        
        $.each(results.sellers, function(index, seller) {
            var html = '<div class="page" id="' + seller.id + '"><h1>' + seller.n + ' ' + seller.name + '<span class="mail">' + seller.mail + '</span></h1></div>';
            $('#abrechnungContainer').append(html);
            $('#' + seller.id).append('<div class="brutto">Umsatz (brutto): <span>' + renderPrice(seller.brutto) + '</span></div>');
            $('#' + seller.id).append('<div class="percent">Gebühren (' + seller.percent + '): <span>- ' + renderPrice(seller.brutto * (seller.percent.replace("%", "")) / 100) + '</span></div>');
            $('#' + seller.id).append('<div class="fixed">Fixkosten: <span>- ' + renderPrice(seller.fixed)+ '</span></div>');
            $('#' + seller.id).append('<div class="profit">Gewinn: <span class="payment">= ' + renderPrice(seller.netto)+ '</span></div>');
            $('#' + seller.id).append('<div class="explain">Der Gewinn ist zur Auszahlung auf 0.50€ gerundet.</div>');
            $('#' + seller.id).append('<h2>Artikel</h2><table class="table1"><tbody></tbody></table><table class="table2"><tbody></tbody></table>');
            $.each(seller.articles, function(j,article) {
                $('#' + seller.id + (j < 36 ? ' .table1' : ' .table2') + ' tbody').append('<tr id="' + seller.id + '_article_' + j +'" class="articleList' + (article.sold ? ' sold' : '') + '"></tr>');
                $('#' + seller.id + (j < 36 ? ' .table1' : ' .table2') + ' tbody tr#' + seller.id + '_article_' + j).append('<td>'+ article.itemNo + '</td>');
                $('#' + seller.id + (j < 36 ? ' .table1' : ' .table2') + ' tbody tr#' + seller.id + '_article_' + j).append('<td>'+ article.desc + '</td>');
                $('#' + seller.id + (j < 36 ? ' .table1' : ' .table2') + ' tbody tr#' + seller.id + '_article_' + j).append('<td>'+ article.size + '</td>');
                $('#' + seller.id + (j < 36 ? ' .table1' : ' .table2') + ' tbody tr#' + seller.id + '_article_' + j).append('<td>'+ renderPrice(article.price) + '</td>');
                $('#' + seller.id + (j < 36 ? ' .table1' : ' .table2') + ' tbody tr#' + seller.id + '_article_' + j).append('<td>'+ (article.sold ? 'verkauft' : '') + '</td>');
            });
            
        });
        
    });
};

holeDaten();
function loadArticlesListing() {
    
    var user = $('#inputUser').val();
    var pass = Sha256.hash($('#inputPassword').val());

    new jQuery.getJSON('resources/xql/getArticlesListing.xql',{user: user, pass: pass}, function(articles) {
        
        $('#login').remove();
        
        var table = '<div class="span9"><table class="table table-striped" id="articleListing"><thead><tr><td>#</td><td>Beschreibung</td><td>Größe</td><td>Preis</td></tr><tbody></tbody></thead></table></div><div class="span3" style="position: relative;"><a id="saveBtn" class="btn btn-primary" href="#" style="position: fixed;">Speichern</a></div>'
        
        $('#configContainer').append(table);
        
        articles.forEach(function(article, index, articles) {
            var row = '<tr id="' + article.id + '"><td class="n">' + article.n + '</td><td class="desc"><input type="text" value="' + article.desc + '" placeholder="Beschreibung"/></td><td class="size"><input type="number" value="' + article.size + '" step="6" min="50" max="164"/></td><td class="price"><input type="number" value="' + article.price + '" step="0.5" min="0"/> €</td></tr>';
            $('#configContainer tbody').append(row);
        });
        
        $('#saveBtn').on('click',function() {saveArticles()});        
        //$('#configContainer').append(data);
        
    });
};

function saveArticles() {
    
    var items = $('<items></items>');
    
    $.each($('#configContainer tbody tr'), function(index,row) {
        
        var id = row.id;
        var desc = $(row).find('td.desc input')[0].value;
        var n = $(row).find('td:first').text();
        var price = $(row).find('td.price input')[0].value;
        var size = $(row).find('td.size input')[0].value;
        
        var string = 'id=' + id + '|||desc=' + desc + '|||price=' + price + '|||size=' + size;
        
        $(items).append('<article xml:id="' + id + '" desc="' + desc + '" price="' + price + '" size="' + size + '"/>');
        
    });
    
    var post = $('<post></post>');
    $(post).append($(items));
    
    /*$.post('resources/xql/saveArticles.xql', {},function( data ) {
        $( ".result" ).html( data );
    });*/
    
    $.ajax({
        type: "post",
        url: 'resources/xql/saveArticles.xql',
        contentType: 'text/xml',
        data: $(post)[0].innerHTML,
        success: function(result) {
            console.log('done');
        }
    });
    
    /*$.post('resources/xql/saveArticles.xql', {
        
        data: $(items),
        success: function(result) {
            console.log('done');
        }
    }); */
    
    
};

$('#loginBtn').on('click',function() {loadArticlesListing()});
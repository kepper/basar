function loadExportPage() {
    
    var user = $('#inputUser').val();
    var pass = Sha256.hash($('#inputPassword').val());

    new jQuery.get('resources/xql/getExportPage.xql',{user: user, pass: pass}, function(data) {
        
        $('#login').remove();
        
        $('#exportContainer').append(data);
        
        $('#generateBadgesBtn').on('click',function() {generateBadges()});
        
    });
};

function generateBadges() {
    new jQuery.get('resources/xql/getBadges.xql',function(data) {
        
        $('#exportContainer').remove();
        
        $('#content').append(data);
        
        $('.barCode').each(function(index,elem) {
            
            /*if(index > 100)
                return false;*/
            
            //console.log(elem.id);
            $('#' + elem.id).JsBarcode(elem.id, {
                width: 6, 
                height: 80,
                font: 'Helvetica Neue',
                fontSize: 30,
                format: 'CODE128',
                displayValue: true
            });
            
        });
        
    });
};




$('#loginBtn').on('click',function() {loadExportPage()});
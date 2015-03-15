
var cart = [];
var sum = 0;

function renderPrice(price) {
    return parseFloat(price).toFixed(2).toString().replace('.',',') + ' €';
}

function read(itemID) {
    
    //document.getElementById("list").innerHTML=itemID;
    
    console.log(itemID);
    if($('#' + itemID).length > 0) {
        return;
    }
        
    
    new jQuery.getJSON('resources/xql/getPrice.xql',{item: itemID}, function(json) {
            
        var row = '<tr id="item' + itemID + '"><td>' + json.desc + '</td><td class="price" data-price="' + json.price + '">' + renderPrice(json.price) + '</td><td class="itemID">' + itemID + '</td><td class="size">' + json.size + '</td><td class="remove"><i class="icon-remove"></i></td></tr>';
        if($('#item' + itemID).length > 0) {
           return false;
        }
        
        if(json.sold) {
            alert('Artikel bereits verkauft!');
            return false;
        }
        
        if(!json.exists) {
            alert('Artikel nicht im System vorhanden!');
            return false;
        }
        
        cart.push(itemID);
        sum = parseFloat(sum) + parseFloat(json.price);
        
        $('tbody').append(row);
        $('#count').html(cart.length);
        
        $('tbody #item'+itemID + ' i').on('click',function(){
            $('tbody #item'+itemID + ' i').off();
            $('tbody #item'+itemID).remove();
            sum = parseFloat(sum) - parseFloat(json.price);
            $('#sum').html(renderPrice(sum));
            cart = cart.filter(function(x) {
                return x !== itemID;
            });
            
            $('#count').html(cart.length);
        });
        
        $('#sum').html(renderPrice(sum));
        
    });
    
};	

$('#addBtn').on('click',function(e) {
    $('#articleForm').submit();
    e.preventDefault();
});

$('#articleForm').on('submit',function(e){
     
     var articleID = $('#articleID').val();
     read(articleID);
     
     $('#articleID').val('');
     $('#articleID').focus();
     e.preventDefault();
});

$('#articleID').focus();

$('button#checkout').on('click',function() {
    if(cart.length === 0)
        return;
    
    searching = false;
    
    var items = cart.toString(',');
    
    new jQuery.getJSON('resources/xql/sellArticles.xql',{items: items}, function(result) {
        alert(result + ' Artikel für ' + renderPrice(sum) + ' verkauft.');
        
        sum = 0;
        cart = [];
        
        $('#sum').html('0€');
        $('#count').html('0');
        $('tbody i').off();
        $('tbody tr').remove();
        
        $('#articleID').focus();
    });
    
    
});



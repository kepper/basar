function loadConfigPage() {
    
    var user = $('#inputUser').val();
    var pass = Sha256.hash($('#inputPassword').val());

    new jQuery.get('resources/xql/getConfigPage.xql',{user: user, pass: pass}, function(data) {
        
        $('#login').remove();
        
        $('#configContainer').append(data);
        
        $('#saveBtn').on('click',function() {saveConfig();});
        $('#passBtn').on('click',function() {changePass();});
        
    });
};

function saveConfig() {
    var sellerCount = $('#sellerCount').val();
    var itemCount = $('#itemCount').val();
    var marginPercent = $('#marginPercent').val();
    var marginPercentReduced = $('#marginPercentReduced').val();
    var marginFix = $('#marginFix').val();
    var cakesMax = $('#cakesMax').val();
    var biddingStartDate = $('#biddingStartDate').val();
    var biddingStartTime = $('#biddingStartTime').val();
    
    new jQuery.get('resources/xql/saveConfig.xql',
        {sellerCount: sellerCount, 
         itemCount: itemCount,
         marginPercent:marginPercent,
         marginPercentReduced:marginPercentReduced,
         marginFix:marginFix,
         cakesMax:cakesMax,
         biddingStartDate:biddingStartDate,
         biddingStartTime:biddingStartTime}, function(data) {
        
        alert('Daten erfolgreich geändert.');
        
    });
    
};

function changePass() {
    
    var adminUser = $('#inputUser').val();
    var oldPass = $('#oldPaddword').val();
    var adminPass = $('#inputPassword').val();
    var adminPass2 = $('#inputPassword2').val();
    
    if(adminPass !== adminPass2) {
        alert('Passwörter stimmen nicht überein. Bitte korrigieren.');
        return false;
    }
    oldPass = Sha256.hash(oldPass);
    adminPass = Sha256.hash(adminPass);
    
    new jQuery.get('resources/xql/changeAdminPass.xql',
        {adminUser:adminUser,
         oldPass:oldPass,
         newPass:adminPass}, function(data) {
        
        alert('Daten erfolgreich geändert.');
        
    });
    
};

$('#loginBtn').on('click',function() {loadConfigPage()});
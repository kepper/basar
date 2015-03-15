function openRegistration() {
    
    $('#registrationModal').modal('show');
    
    
    
};

function register() {
    
    var name = $('#addNameInput').val();
    var mail = $('#addEmailInput').val();
    var cake = $('#promiseCake').length > 0 ? $('#promiseCake').checked : false;
    var id = name.replace(/\s/,'');
    
    var pass = $('#inputPassword').val();
    var pass2 = $('#inputPassword2').val();
    
    if(pass !== pass2) {
        alert('Passwörter stimmen nicht überein. Bitte korrigieren.');
        return false;
    }
    
    pass = Sha256.hash(pass);
    
    new jQuery.get('resources/xql/addSeller.xql', 
        {name: name, 
        mail: mail, 
        id: id,
        cake: cake,
        pass: pass}, function(data) {
        
            $('#registrationModal').modal('hide');
            $('#registrationDetails').html('<div class="hero-unit"><h3>Registrierung erfolgreich</h3><p>' + data + '</p><p><b><a class="btn btn-primary" id="loginLink" href="#">Zur Anmeldung</a></b></p></div>');
            
            $('#loginLink').on('click',function(){
                alert('Login funktioniert noch nicht.'); 
            });
            
    });  
    
};

$('#registerBtn').on('click',function() {openRegistration()});
$('#createSeller').on('click',function() {register()});
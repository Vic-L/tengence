Tengence.HomePage.scrollTo = (id) ->
  $('html,body').animate({scrollTop: $('#' + id).offset().top}, 'slow');

Tengence.HomePage.promptRegistration = ->
  $('#register-modal').foundation('reveal', 'open')
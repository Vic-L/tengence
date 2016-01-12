window.Tengence ||= {}
Tengence.ReactFunctions ||= {}

Tengence.ReactFunctions.showLoading = ->
  $('section#tender-results').addClass('blur')
  document.body.classList.add('loading')

Tengence.ReactFunctions.stopLoading = ->
  $('section#tender-results').removeClass('blur');
  document.body.classList.remove('loading');

Tengence.ReactFunctions.showTender = (ref_no) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/tenders/' + encodeURIComponent(ref_no)
    dataType: 'json'
    method: 'get'
    cache: false
    success: (tender) -> 
      $('#view-more-modal').empty()
      ReactDOM.render `<ShowTender tender={tender}/>`, document.getElementById('view-more-modal')
      $('#view-more-modal').foundation('reveal', 'open')
      return
    error: (xhr, status, err) -> 
      # this.notifyError(window.location.href,'showTender', err.toString());
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return
window.Tengence ||= {}
Tengence.ReactFunctions ||= {}

Tengence.ReactFunctions.showLoading = ->
  $('section#tender-results').addClass('blur')
  document.body.classList.add('loading')

Tengence.ReactFunctions.stopLoading = ->
  $('section#tender-results').removeClass('blur')
  document.body.classList.remove('loading')

Tengence.ReactFunctions.getTenders = (reactParent, url, query, keywords) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: url
    data: 
      {query: query
      , keywords: keywords}
    method: 'GET',
    dataType: 'json',
    cache: false,
    success: (data) ->
      reactParent.setState(
        {pagination: data.pagination
        ,tenders: data.tenders
        ,results_count: data.results_count
        ,url: url})
      # history.pushState({ url: url }, '', url.replace('/api/v1',''));
      return
    error: (xhr, status, err) ->
      # this.notifyError(window.location.href,'getTenders', err.toString());
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

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

Tengence.ReactFunctions.watchTender = (reactParent,ref_no) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/watched_tenders'
    data:
      id: ref_no
    dataType: 'json'
    method: 'POST'
    success: (ref_no) ->
      tenders = reactParent.state.tenders
      for tender in tenders
        if tender.ref_no is ref_no
          tender.watched = true
          break
      reactParent.setState {tenders: tenders}, ->
        $("a.unwatch-button[data-gtm-label='" + ref_no + "']").notify "Successfully added to watchlist", "success", { position: "top" }
        return
      return
    error: (xhr, status, err) ->
      # this.notifyError(window.location.href,'watchTender', err.toString())
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.unwatchTender = (reactParent,ref_no) -> 
  Tengence.ReactFunctions.showLoading();
  $.ajax
    url: '/api/v1/watched_tenders/' + encodeURIComponent(ref_no)
    dataType: 'json'
    method: 'DELETE'
    success: (ref_no) ->
      tenders = reactParent.state.tenders
      for tender in tenders
        if tender.ref_no is ref_no
          tender.watched = false
          break
      reactParent.setState(
        {tenders: tenders}
        , ->
          $("a.watch-button[data-gtm-label='" + ref_no + "']").notify(
            "Successfully removed from watchlist"
            , "success"
            , { position: "top" })
          return
      )
      return
    error: (xhr, status, err) ->
      # this.notifyError(window.location.href,'unwatchTender', err.toString());
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return
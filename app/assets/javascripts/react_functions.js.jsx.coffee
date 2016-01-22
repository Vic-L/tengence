Tengence.ReactFunctions.showLoading = ->
  $('#tender-results').addClass('blur')
  document.body.classList.add('loading')

Tengence.ReactFunctions.stopLoading = ->
  $('#tender-results').removeClass('blur')
  document.body.classList.remove('loading')

Tengence.ReactFunctions.notifyError = (url, method, error) ->
  $.ajax
    url: "/api/v1/notify_error"
    method: 'GET'
    cache: false
    data: 
      {url: url
      ,method: method
      ,error: error}

Tengence.ReactFunctions.trackQuery = (url) ->
  if ga?
    ga('send', 'pageview', url);
    console.log url
  return

Tengence.ReactFunctions.getTenders = (parentComponent, url, query, keywords) ->
  # Tengence.ReactFunctions.trackQuery(query)
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
      finalUrl = new URI(url)
      finalUrl = finalUrl.removeQuery('query').removeQuery('keywords')
      if query?
        finalUrl.addQuery('query', query)
      if keywords?
        finalUrl.addQuery('keywords', query)
      Tengence.ReactFunctions.trackQuery(finalUrl.toString().replace('/api/v1',''))
      parentComponent.setState(
        {pagination: data.pagination
        ,tenders: data.tenders
        ,results_count: data.results_count
        ,url: finalUrl.toString()})
      return
    error: (xhr, status, err) ->
      Tengence.ReactFunctions.notifyError(window.location.href,'getTenders', xhr.statusText)
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.showTender = (ref_no) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/tenders/' + encodeURIComponent(ref_no).replace('.','&2E')
    dataType: 'json'
    method: 'get'
    cache: false
    success: (tender) -> 
      $('#view-more-modal').empty()
      ReactDOM.render `<ShowTender tender={tender}/>`, document.getElementById('view-more-modal')
      $('#view-more-modal').foundation('reveal', 'open')
      return
    error: (xhr, status, err) -> 
      Tengence.ReactFunctions.notifyError(window.location.href,'showTender', xhr.statusText)
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.watchTender = (parentComponent,ref_no) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/watched_tenders'
    data:
      id: ref_no
    dataType: 'json'
    method: 'POST'
    success: (ref_no) ->
      tenders = parentComponent.state.tenders
      for tender in tenders
        if tender.ref_no is ref_no
          tender.watched = true
          break
      parentComponent.setState {tenders: tenders}, ->
        $("a.unwatch-button[data-gtm-label='" + ref_no + "']").notify "Successfully added to watchlist", "success", { position: "top" }
        return
      return
    error: (xhr, status, err) ->
      Tengence.ReactFunctions.notifyError(window.location.href,'watchTender', xhr.statusText)
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.unwatchTender = (parentComponent,ref_no) -> 
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/watched_tenders/' + encodeURIComponent(ref_no).replace('.','&2E')
    dataType: 'json'
    method: 'DELETE'
    success: (ref_no) ->
      tenders = parentComponent.state.tenders
      for tender in tenders
        if tender.ref_no is ref_no
          tender.watched = false
          break
      parentComponent.setState(
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
      Tengence.ReactFunctions.notifyError(window.location.href,'unwatchTender', xhr.statusText)
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.updateKeywords = (parentComponent,keywords) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/users/keywords'
    dataType: 'json'
    method: "POST"
    data:
      {keywords: keywords}
    success: ->
      parentComponent.setState({keywords: keywords})
      Tengence.ReactFunctions.getTenders(
        parentComponent
        ,'/api/v1/keywords_tenders'
        ,'stub_query'
        keywords)
      return
    error: (xhr, status, err) ->
      alert(xhr.statusText)
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.massDestroyTenders = (parentComponent, tender_ids) ->
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: "/api/v1/watched_tenders/mass_destroy"
    method: 'POST'
    data: 
      {ids: tender_ids}
    success: ->
      $('#select_all').prop('checked', false)
      Tengence.ReactFunctions.getTenders(
        parentComponent
        , parentComponent.state.url.split('page')[0]
        , document.getElementById('query-field').value)
    error: (xhr, status, err) ->
      Tengence.ReactFunctions.notifyError(window.location.href,'massDestroyTenders', xhr.statusText)
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused. The page will now refresh.")
      window.location.reload()
Tengence.ReactFunctions.showLoading = ->
  $('section#tender-results').addClass('blur')
  document.body.classList.add('loading')

Tengence.ReactFunctions.stopLoading = ->
  $('section#tender-results').removeClass('blur')
  document.body.classList.remove('loading')

Tengence.ReactFunctions.getTenders = (parentComponent, url, query, keywords) ->
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
      parentComponent.setState(
        {pagination: data.pagination
        ,tenders: data.tenders
        ,results_count: data.results_count
        ,url: url})
      # history.pushState({ url: url }, '', url.replace('/api/v1',''))
      return
    error: (xhr, status, err) ->
      # this.notifyError(window.location.href,'getTenders', err.toString())
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
      # this.notifyError(window.location.href,'showTender', err.toString())
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
      # this.notifyError(window.location.href,'watchTender', err.toString())
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.")
      return
    complete: (xhr, status) ->
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.unwatchTender = (parentComponent,ref_no) -> 
  Tengence.ReactFunctions.showLoading()
  $.ajax
    url: '/api/v1/watched_tenders/' + encodeURIComponent(ref_no)
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
      # this.notifyError(window.location.href,'unwatchTender', err.toString())
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
      alert(xhr.responseText)
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
      # this.notifyError(window.location.href,'massDestroyTenders', err.toString())
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused. The page will now refresh.")
      window.location.reload()
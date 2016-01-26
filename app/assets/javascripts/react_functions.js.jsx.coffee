Tengence.ReactFunctions.showLoading = ->
  $('#tender-results').addClass('blur')
  document.body.classList.add('loading')

Tengence.ReactFunctions.dissectUrl = (url) ->
  uri = new URI(url);
  params = URI.parseQuery(uri.query());
  path = new URI(uri.path());
  return {
    path: path.toString()
    page: params.page
    table: params.table
    query: params.query
    keywords: params.keywords
    sortOrder: params['sort']
  }

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

Tengence.ReactFunctions.trackQuery = (query) ->
  if dataLayer?
    dataLayer.push
      'event': 'searchQuery'
      'searchQuery': query
  return

Tengence.ReactFunctions.pushState = (url) ->
  # console.log url
  if (url.indexOf('demo_tenders') < 0)
    state = {url: url}
    history.pushState(state,'',url)

Tengence.ReactFunctions.getTenders = (parentComponent, url, table, page, query, keywords, sort) ->
  Tengence.ReactFunctions.showLoading()
  # console.log url
  # console.log query
  # console.log keywords
  # console.log sort
  $.ajax
    url: url
    data: 
      {query: query
      table: table
      page: page
      keywords: keywords
      sort: sort}
    method: 'GET',
    dataType: 'json',
    cache: false,
    success: (data) ->
      finalUrl = new URI(url)
      if page?
        finalUrl.removeQuery('page')
        finalUrl.addQuery('page', page)
      if table?
        finalUrl.removeQuery('table')
        finalUrl.addQuery('table', table)
      if query?
        finalUrl.removeQuery('query')
        finalUrl.addQuery('query', query)
      if keywords?
        finalUrl.removeQuery('keywords')
        finalUrl.addQuery('keywords', keywords)
      if sort?
        finalUrl.removeQuery('sort')
        finalUrl.addQuery('sort', sort)

      Tengence.ReactFunctions.pushState(finalUrl.toString().replace('/api/v1',''))

      parentComponent.setState({
        pagination: data.pagination
        tenders: data.tenders
        results_count: data.results_count
        url: finalUrl.toString()
        sort: sort})
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
        '/api/v1/keywords_tenders'
        null
        keywords)
      return
    error: (xhr, status, err) ->
      alert(xhr.responseText)
      Tengence.ReactFunctions.stopLoading()
      return

Tengence.ReactFunctions.massDestroyTenders = (parentComponent, tender_ids, url) ->
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
        url)
    error: (xhr, status, err) ->
      Tengence.ReactFunctions.notifyError(window.location.href,'massDestroyTenders', xhr.statusText)
      alert("Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused. The page will now refresh.")
      window.location.reload()
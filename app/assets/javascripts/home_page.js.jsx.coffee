Tengence.HomePage.scrollTo = (id) ->
  $('html,body').animate({scrollTop: $('#' + id).offset().top}, 'slow');

Tengence.HomePage.promptRegistration = ->
  $('#register-modal').foundation('reveal', 'open')

Tengence.HomePage.initHeader = ->
  $(window).load ->
    lastId = undefined
    topMenu = $('.menu-list')
    topMenuHeight = 80
    menuItems = topMenu.find('a:not(".unscrollable")')
    scrollItems = menuItems.map(->
      item = $($(this).attr('href'))
      if item.length
        return item
      return
    )
    # Bind click handler to menu items
    # so we can get a fancy scroll animation
    menuItems.click (e) ->
      href = $(this).attr('href')
      offsetTop = if href == '#' then 0 else $(href).offset().top - topMenuHeight + 1
      $('html, body').stop().animate { scrollTop: offsetTop }, 900
      e.preventDefault()
      return

    $(window).scroll ->
      # Get container scroll position
      fromTop = $(this).scrollTop() + topMenuHeight
      # Get id of current scroll item
      cur = scrollItems.map(->
        if $(this).offset().top < fromTop
          return this
        return
      )
      # Get the id of the current element
      cur = cur[cur.length - 1]
      id = if cur and cur.length then cur[0].id else ''
      if lastId != id
        lastId = id
        # Set/remove active class
        menuItems.parent().removeClass('active').end().filter('[href=#' + id + ']').parent().addClass 'active'
      return
    return

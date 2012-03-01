base = 'http://localhost:4567/'

transport = new XMLHttpRequest()
transport.open 'GET', base + 'mods_for?url=' + location.href
transport.onreadystatechange = ->
  if transport.readyState == 4
    done JSON.parse(transport.responseText)
transport.send()

done = (mod_list) ->
  for mod in mod_list
    append_stylesheet url for url in mod.css
    append_script url for url in mod.js

append_stylesheet = (url) ->
  node = document.createElement('link')
  node.type = 'text/css'
  node.rel = 'stylesheet'
  node.href = base + 'file/' + url
  document.head.appendChild(node)

append_script = (url) ->
  node = document.createElement('script')
  node.src = base + 'file/' + url
  document.head.appendChild(node)
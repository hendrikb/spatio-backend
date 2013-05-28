
$ ->
  $("ul.nav li").removeClass("active")
  if document.location.pathname.match("format_definition")
    $("li.format_definition").addClass("active")
  else
    $("li.import").addClass("active")

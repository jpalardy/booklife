
$(document).ready(function() {
  $(document).bind('keypress', {combi:'/', disableInInput: true}, function() { $('#nav input:text').focus(); return false; });
  // $('#sidebar li.selected').corners('20px left');
  // $('#nav li.selected').corners('20px top');
  // $('.rounded').corners('20px left');
});


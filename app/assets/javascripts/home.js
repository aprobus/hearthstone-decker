$(function() {
  $("tr.link-row").click(function(event) {
    var clickedRow = $(this);
    var linkTo = clickedRow.data('href');

    var actualTarget = $(event.target);
    var shouldFollowLink = actualTarget.parent('a, button').size() === 0

    if (shouldFollowLink) {
      window.location = linkTo;  
    }
  });
});


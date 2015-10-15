var count = 0;
var passed = 0;

function expect(orig_got, orig_expected) {
  ++count;

  got      = orig_got.replace(/\s\s+/g,      ' ').replace(/\s*([<>])\s*/g, "$1").trim();
  expected = orig_expected.replace(/\s\s+/g, ' ').replace(/\s*([<>])\s*/g, "$1").trim();

  if (got != expected) {
    console.log("TEST FAILED.  expected = '" + expected + "'");
    console.log("TEST FAILED.  got      = '" + got + "'");
    var $fail_div = $('#fail-tmpl').clone();
    $fail_div.removeAttr('id');
    $fail_div.find('.got').html(orig_got);
    $fail_div.find('.expected').html(orig_expected);
    $fail_div.show();
    $('body').append($fail_div);
    return false;
  }

  ++passed;
  return true;
}

function fh(html) {
  return GlassHtmlEditor.formatHtml(html);
}

$(function () {
  expect(fh('<p>before <span>in</span> after</p>'), 'before in after');
  expect(fh('<foo>stuff</foo>'), 'stuff')

  $('.testcase').each(function (){
    expect(fh($(this).find('.input').html()), $(this).find('.expect').html());
  });

  console.log("ALL TESTS COMPLETE. pass:" + passed + " fail:" + (count - passed));
});

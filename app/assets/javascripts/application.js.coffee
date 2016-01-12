# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require_self
#= require tyger/js/vendor/jquery
#= require jquery_ujs
#= require tyger/js/vendor/modernizr
#= require tyger/js/foundation.min
#= require tyger/js/foundation/foundation.accordion
#= require tyger/js/plugins
#= require tyger/js/jquery.cubeportfolio.min
#= require tyger/js/custom
#= require jquery.validate.min
#= require jquery.validate.additional-methods.min
#= require notify.min
#= require foundation-datepicker.min
#= require strftime
#= require filesize.min
#= require marked.min
#= require react
#= require react_ujs
#= require react_functions
#= require components
#= require_tree .

window.Tengence ||= {}
Tengence.ReactFunctions ||= {}

$(document).ready ->

  sendRequestForYelpData = (lat, long, term) ->
    $.ajax({
      url: '/points/yelp'
      type: 'POST'
      dataType: 'json'
      data: {
        center: {
          latitude: lat
          longitude: long
          term: term
        }
      }
      success: (data) ->
        console.log data

        $("<img src='http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&zoom=12&markers=" +
        data.lat.toString() + "%2C" + data.long.toString() + "'/>").insertAfter('#point_form')

        $("<p>" + data.location.address[0] + "</p>").insertAfter('#point_form')
        $("<p>" + data.location.city + "</p>").insertAfter('#point_form')
        $("<p>" + data.location.cross_streets + "</p>").insertAfter('#point_form')
        $("<p>" + data.name + "</p>").insertAfter('#point_form')
    })

  $('#point_form').submit ->
    $.ajax({
      url: '/points'
      type: 'POST'
      dataType: 'json'
      data: {
        point: {
          address1: $("input[name='point[address1]']").val()
          address2: $("input[name='point[address2]']").val()
          term: $("input[name='point[term]']").val()
        }
      }
      error: ->
        alert 'Something went wrong... Did you fill in both addresses?'
      success: (data) ->
        console.log 'Point form data back!' + data
        console.log data
        $("<img src='http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&zoom=12&markers=" +
        data.center.latitude.toString() + "%2C" + data.center.longitude.toString() + "&markers=" +
        data.address1.latitude.toString() + "%2C" + data.address1.longitude.toString() + "&markers=" +
        data.address2.latitude.toString() + "%2C" + data.address2.longitude.toString() + "'/>").insertAfter('#point_form')
        $('<p>' + data.center.address + '</p>').insertAfter('#point_form')
        sendRequestForYelpData(data.center.latitude, data.center.longitude, data.term)
    })
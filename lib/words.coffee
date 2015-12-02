exports.getAdjective = (change) ->
    if change > 0
        'fler'
    else if change < 0
        'färre'
    else
        'oförändrat antal'

exports.getVerb = (change) ->
    if change > 0
        'ökade'
    else if change < 0
        'minskade'
    else
        'var oförändrat'
        
exports.getNoun = (change) ->
    if change > 0
        'ökning'
    else if change < 0
        'minskning'

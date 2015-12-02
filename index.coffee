fs =            require 'fs'
path =          require 'path'
express =       require 'express'
bodyParser =    require 'body-parser'

app = express()

app.locals.formatThousands =        require('./lib/utils').formatThousands
app.locals.formatPercentage =       require('./lib/utils').formatPercentage
app.locals.getNumberString =        require('./lib/utils').getNumberString
app.locals.capitalizeFirstLetter =  require('./lib/utils').capitalizeFirstLetter

app.locals.getAdjective =           require('./lib/words').getAdjective
app.locals.getVerb =                require('./lib/words').getVerb
app.locals.getNoun =                require('./lib/words').getNoun

app.set 'view engine', 'jade'
app.set 'views', path.join __dirname, 'views'
app.use express.static path.join __dirname, 'public'
app.use bodyParser.urlencoded { extended: false }

data = JSON.parse fs.readFileSync('./data/data.json', 'utf8')
municipalityCodes = JSON.parse fs.readFileSync('./data/municipalityCodes.json', 'utf8')

population = 0
populationChange = 0
largestIncrease = 0
largestDecrease = 0
winners = 0
losers = 0

for key, value of data
    population += data[key].total
    populationChange += data[key].change
    if data[key].change > 0
        winners++
        if data[key].changeInPercent > largestIncrease
            largestIncrease = data[key].changeInPercent
    if data[key].change < 0
        losers++
        if data[key].changeInPercent < largestDecrease
            largestDecrease = data[key].changeInPercent
        
populationChangeInPercent = parseFloat ((populationChange / (population - populationChange)) * 100).toFixed(1)

app.locals.averageChange = populationChangeInPercent
app.locals.largestIncrease = largestIncrease
app.locals.largestDecrease = largestDecrease
app.locals.winners = winners
app.locals.losers = losers

app.get '/', (req, res) ->
    res.render 'index', {}

app.post '/', (req, res) ->
    choice = req.body.municipality.toLowerCase().trim()
    localData = data[municipalityCodes[choice]]
    if !localData
        res.render 'index', { municipality: choice, validChoice: false }
    else
        localData.validChoice = true
        res.render 'index', localData

app.listen process.env.PORT or 3000

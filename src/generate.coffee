fs = require('fs')
Combyne = require('combyne')

fs.readFile('./models/schema.coffee', (err, data) ->
    throw err if (err)

    result = JSON.parse(data)

    fs.readFile('./models/ModelTemplate.mustache', (err, data) ->
        model_template = Combyne(data.toString())
        fs.readFile('../test/TestTemplate.mustache', (err, data) ->
            test_template = Combyne(data.toString())
            fs.readFile('../test/TestTemplate_Short.mustache', (err, data) ->
                short_test_template = Combyne(data.toString())
                models = []
                i=0
                for model, schema of result
                    console.log("Looking at "+model)

                    continue if (model != "App" && model != "Address" && model != "Location" && model != "Trip" &&
                        model != "User" && model != "Vehicle"  && model != "Event" && model != "Mojio" &&
                        model != "Subscription" && model != "Product" && model != "Observer" &&
                        model != "AccelerationObserver" && model != "AccelerometerObserver" &&
                        model != "AltitudeObserver" && model != "BatteryVoltageObserver" &&
                        model != "ConditionalObserver" && model != "DiagnosticCodeObserver" &&
                        model != "DistanceObserver" && model != "EventObserver" &&
                        model != "FuelLevelObserver" && model != "GeoFenceObserver" &&
                        model != "HeadingObserver" && model != "OdometerObserver" &&
                        model != "RPMObserver" && model != "ScriptObserver" && model != "SpeedObserver")

                    console.log("Processing "+model)

                    view = {
                        Resource: model+"s"
                        Model: model
                        model: model.toLowerCase()
                        schema: ""
                    }

                    if (model == "Event")
                        # agregate all the Event based objects into one schema.
                        for event_model, event_schema of result
                            if (event_model.indexOf("Event") != -1)
                                for field, type of event_schema
                                    schema[field] = type

                    str = JSON.stringify(schema,null,4)
                    spl = str.split('\n')
                    for s in spl
                        view['schema'] += '            '+s+'\n'

                    output = model_template.render(view)
                    wstream = fs.createWriteStream("./models/"+model+".coffee")
                    wstream.write(output)
                    wstream.end()

                    continue if (model == "Address" || model == "Location" || model == "Observer" ||
                        model == "AccelerationObserver" || model == "AccelerometerObserver" ||
                        model == "AltitudeObserver" || model == "BatteryVoltageObserver" ||
                        model == "ConditionalObserver" || model == "DiagnosticCodeObserver" ||
                        model == "DistanceObserver" || model == "EventObserver" ||
                        model == "FuelLevelObserver" || model == "GeoFenceObserver" ||
                        model == "HeadingObserver" || model == "OdometerObserver" ||
                        model == "RPMObserver" || model == "ScriptObserver" || model == "SpeedObserver")

                    if (model != "Vehicle")
                        # these models have problems with put, post delete.
                        if (model == "Event" || model == "Subscription" || model == "Trip" || model == "User")
                            output = short_test_template.render(view)
                        else
                            output = test_template.render(view)
                        wstream = fs.createWriteStream("../test/"+model+"_test.coffee")
                        wstream.write(output)
                        wstream.end()

                    models[i++] = view

                fs.readFile('./MojioClientTemplate.mustache', (err, data) ->
                    client_template = Combyne(data.toString())
                    view['models'] = models
                    view['http_require'] = "Http = require './HttpNodeWrapper'"
                    view['http_request'] = "http = new Http()"
                    view['extra_signalr_params'] = "" # none.
                    view['signalr_require'] = "SignalR = require './SignalRNodeWrapper'"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./nodejs/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()

                    view['http_require'] = "Http = require './HttpBrowserWrapper'"
                    view['http_request'] = "http = new Http($)"
                    view['extra_signalr_params'] = ", $"
                    view['signalr_require'] = "SignalR = require './SignalRBrowserWrapper'"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./browser/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()
                )
            )
        )
    )
)
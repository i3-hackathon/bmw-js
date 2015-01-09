MojioModel = require('./MojioModel')

module.exports = class Vehicle extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "OwnerId": "String",
                "MojioId": "String",
                "Name": "String",
                "VIN": "String",
                "LicensePlate": "String",
                "IgnitionOn": "Boolean",
                "LastTripEvent": "String",
                "LastLocationTime": "String",
                "LastLocation": "Object",
                "LastSpeed": "Float",
                "FuelLevel": "Float",
                "LastFuelEfficiency": "Float",
                "CurrentTrip": "String",
                "LastTrip": "String",
                "LastContactTime": "String",
                "MilStatus": "Boolean",
                "FaultsDetected": "Boolean",
                "Viewers": "Array",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Vehicles'
    _model: 'Vehicle'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Vehicles'
    @_model: 'Vehicle'

    @resource: () ->
        return Vehicle._resource

    @model: () ->
        return Vehicle._model


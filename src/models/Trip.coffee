MojioModel = require('./MojioModel')

module.exports = class Trip extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "MojioId": "String",
                "VehicleId": "String",
                "StartTime": "String",
                "LastUpdatedTime": "String",
                "EndTime": "String",
                "MaxSpeed": "Float",
                "MaxAcceleration": "Float",
                "MaxDeceleration": "Float",
                "MaxRPM": "Integer",
                "FuelLevel": "Float",
                "FuelEfficiency": "Float",
                "Distance": "Float",
                "MovingTime": "Float",
                "IdleTime": "Float",
                "StopTime": "Float",
                "StartLocation": "Object",
                "LastKnownLocation": "Object",
                "EndLocation": "Object",
                "StartAddress": "Object",
                "EndAddress": "Object",
                "ForcefullyEnded": "Boolean",
                "StartMilage": "Float",
                "EndMilage": "Float",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Trips'
    _model: 'Trip'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Trips'
    @_model: 'Trip'

    @resource: () ->
        return Trip._resource

    @model: () ->
        return Trip._model


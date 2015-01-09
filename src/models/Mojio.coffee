MojioModel = require('./MojioModel')

module.exports = class Mojio extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "OwnerId": "String",
                "Name": "String",
                "Imei": "String",
                "LastContactTime": "String",
                "VehicleId": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Mojios'
    _model: 'Mojio'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Mojios'
    @_model: 'Mojio'

    @resource: () ->
        return Mojio._resource

    @model: () ->
        return Mojio._model


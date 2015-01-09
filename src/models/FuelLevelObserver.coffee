MojioModel = require('./MojioModel')

module.exports = class FuelLevelObserver extends MojioModel
    # instance variables
    _schema:             {
                "FuelLow": "Float",
                "FuelHigh": "Float",
                "Timing": "Integer",
                "Type": "Integer",
                "Name": "String",
                "ObserverType": "Integer",
                "AppId": "String",
                "OwnerId": "String",
                "Parent": "String",
                "ParentId": "String",
                "Subject": "String",
                "SubjectId": "String",
                "Transports": "Integer",
                "Status": "Integer",
                "Tokens": "Array",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'FuelLevelObservers'
    _model: 'FuelLevelObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'FuelLevelObservers'
    @_model: 'FuelLevelObserver'

    @resource: () ->
        return FuelLevelObserver._resource

    @model: () ->
        return FuelLevelObserver._model


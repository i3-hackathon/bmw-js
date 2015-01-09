MojioModel = require('./MojioModel')

module.exports = class SpeedObserver extends MojioModel
    # instance variables
    _schema:             {
                "SpeedLow": "Float",
                "SpeedHigh": "Float",
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


    _resource: 'SpeedObservers'
    _model: 'SpeedObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'SpeedObservers'
    @_model: 'SpeedObserver'

    @resource: () ->
        return SpeedObserver._resource

    @model: () ->
        return SpeedObserver._model


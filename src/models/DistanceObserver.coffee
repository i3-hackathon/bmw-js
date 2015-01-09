MojioModel = require('./MojioModel')

module.exports = class DistanceObserver extends MojioModel
    # instance variables
    _schema:             {
                "DistanceLow": "Float",
                "DistanceHigh": "Float",
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


    _resource: 'DistanceObservers'
    _model: 'DistanceObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'DistanceObservers'
    @_model: 'DistanceObserver'

    @resource: () ->
        return DistanceObserver._resource

    @model: () ->
        return DistanceObserver._model


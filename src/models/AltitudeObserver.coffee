MojioModel = require('./MojioModel')

module.exports = class AltitudeObserver extends MojioModel
    # instance variables
    _schema:             {
                "AltitudeLow": "Float",
                "AltitudeHigh": "Float",
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


    _resource: 'AltitudeObservers'
    _model: 'AltitudeObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'AltitudeObservers'
    @_model: 'AltitudeObserver'

    @resource: () ->
        return AltitudeObserver._resource

    @model: () ->
        return AltitudeObserver._model


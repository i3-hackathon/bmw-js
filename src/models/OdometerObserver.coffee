MojioModel = require('./MojioModel')

module.exports = class OdometerObserver extends MojioModel
    # instance variables
    _schema:             {
                "OdometerLow": "Float",
                "OdometerHigh": "Float",
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


    _resource: 'OdometerObservers'
    _model: 'OdometerObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'OdometerObservers'
    @_model: 'OdometerObserver'

    @resource: () ->
        return OdometerObserver._resource

    @model: () ->
        return OdometerObserver._model


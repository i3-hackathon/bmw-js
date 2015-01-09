MojioModel = require('./MojioModel')

module.exports = class AccelerationObserver extends MojioModel
    # instance variables
    _schema:             {
                "AccelerationLow": "Float",
                "AccelerationHigh": "Float",
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


    _resource: 'AccelerationObservers'
    _model: 'AccelerationObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'AccelerationObservers'
    @_model: 'AccelerationObserver'

    @resource: () ->
        return AccelerationObserver._resource

    @model: () ->
        return AccelerationObserver._model


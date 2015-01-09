MojioModel = require('./MojioModel')

module.exports = class BatteryVoltageObserver extends MojioModel
    # instance variables
    _schema:             {
                "BatteryVoltageLow": "Float",
                "BatteryVoltageHigh": "Float",
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


    _resource: 'BatteryVoltageObservers'
    _model: 'BatteryVoltageObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'BatteryVoltageObservers'
    @_model: 'BatteryVoltageObserver'

    @resource: () ->
        return BatteryVoltageObserver._resource

    @model: () ->
        return BatteryVoltageObserver._model


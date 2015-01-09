MojioModel = require('./MojioModel')

module.exports = class RPMObserver extends MojioModel
    # instance variables
    _schema:             {
                "RpmLow": "Float",
                "RpmHigh": "Float",
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


    _resource: 'RPMObservers'
    _model: 'RPMObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'RPMObservers'
    @_model: 'RPMObserver'

    @resource: () ->
        return RPMObserver._resource

    @model: () ->
        return RPMObserver._model


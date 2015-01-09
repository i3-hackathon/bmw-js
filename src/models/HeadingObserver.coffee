MojioModel = require('./MojioModel')

module.exports = class HeadingObserver extends MojioModel
    # instance variables
    _schema:             {
                "HeadingLow": "Float",
                "HeadingHigh": "Float",
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


    _resource: 'HeadingObservers'
    _model: 'HeadingObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'HeadingObservers'
    @_model: 'HeadingObserver'

    @resource: () ->
        return HeadingObserver._resource

    @model: () ->
        return HeadingObserver._model


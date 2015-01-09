MojioModel = require('./MojioModel')

module.exports = class EventObserver extends MojioModel
    # instance variables
    _schema:             {
                "EventTypes": "Array",
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


    _resource: 'EventObservers'
    _model: 'EventObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'EventObservers'
    @_model: 'EventObserver'

    @resource: () ->
        return EventObserver._resource

    @model: () ->
        return EventObserver._model


MojioModel = require('./MojioModel')

module.exports = class ScriptObserver extends MojioModel
    # instance variables
    _schema:             {
                "Script": "String",
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


    _resource: 'ScriptObservers'
    _model: 'ScriptObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'ScriptObservers'
    @_model: 'ScriptObserver'

    @resource: () ->
        return ScriptObserver._resource

    @model: () ->
        return ScriptObserver._model


MojioModel = require('./MojioModel')

module.exports = class Observer extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "Name": "String",
                "ObserverType": "String",
                "EventTypes": "Array",
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


    _resource: 'Observers'
    _model: 'Observer'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Observers'
    @_model: 'Observer'

    @resource: () ->
        return Observer._resource

    @model: () ->
        return Observer._model


MojioModel = require('./MojioModel')

module.exports = class DiagnosticCodeObserver extends MojioModel
    # instance variables
    _schema:             {
                "DiagnosticCodes": "Array",
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


    _resource: 'DiagnosticCodeObservers'
    _model: 'DiagnosticCodeObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'DiagnosticCodeObservers'
    @_model: 'DiagnosticCodeObserver'

    @resource: () ->
        return DiagnosticCodeObserver._resource

    @model: () ->
        return DiagnosticCodeObserver._model


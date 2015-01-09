MojioModel = require('./MojioModel')

module.exports = class ConditionalObserver extends MojioModel
    # instance variables
    _schema:             {
                "Field": "String",
                "Threshold1": "Float",
                "Threshold2": "Float",
                "Operator1": "String",
                "Operator2": "String",
                "Conjunction": "String",
                "ConditionValue": "Boolean",
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


    _resource: 'ConditionalObservers'
    _model: 'ConditionalObserver'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'ConditionalObservers'
    @_model: 'ConditionalObserver'

    @resource: () ->
        return ConditionalObserver._resource

    @model: () ->
        return ConditionalObserver._model


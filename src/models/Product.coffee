MojioModel = require('./MojioModel')

module.exports = class Product extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "AppId": "String",
                "Name": "String",
                "Description": "String",
                "Shipping": "Boolean",
                "Taxable": "Boolean",
                "Price": "Float",
                "Discontinued": "Boolean",
                "OwnerId": "String",
                "CreationDate": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Products'
    _model: 'Product'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Products'
    @_model: 'Product'

    @resource: () ->
        return Product._resource

    @model: () ->
        return Product._model


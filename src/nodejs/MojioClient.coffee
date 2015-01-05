Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'

module.exports = class MojioClient

    defaults = { hostname: 'bmw.api.moj.io', port: '443', version: 'v1', scheme: 'https', signalr_scheme: 'http', signalr_port: '80', signalr_hub: 'ObserverHub' }

    constructor: (@options) ->
        @options ?= { hostname: defaults.hostname, port: @defaults.port, version: @defaults.version, scheme: @defaults.scheme }
        @options.hostname ?= defaults.hostname
        @options.port ?= defaults.port
        @options.version ?= defaults.version
        @options.scheme ?= defaults.scheme
        @options.signalr_port ?= defaults.signalr_port
        @options.signalr_scheme ?= defaults.signalr_scheme
        @options.signalr_hub ?= defaults.signalr_hub
        @options.application = @options.application
        @options.secret = @options.secret
        @options.observerTransport = 'SingalR'
        @conn = null
        @hub = null
        @connStatus = null
        @auth_token = null

        @signalr = new SignalR(@options.signalr_scheme+"://"+@options.hostname+":"+@options.signalr_port+"/v1/signalr",[@options.signalr_hub])

    ###
        Helpers
    ###
    getResults: (type, results) ->
        objects = []
        if (results instanceof Array)
            arrlength = results.length;
            objects.push(new type(result)) for result in results
        else if (results.Data instanceof Array)
            arrlength = results.Data.length;
            objects.push(new type(result)) for result in results.Data
        else if ((result.Data != null))
            objects.push(new type(result.Data))
        else
            objects.push(new type(result))

        return objects


    @_makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{property}=#{value}&"
        return query.slice(0,-1)

    getPath: (resource, id, action, key) ->
        if (key && id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
        else if (id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
        else if (id && id != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
        else if (action && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);

        return "/" + encodeURIComponent(resource);

    dataByMethod: (data, method) ->
        switch (method.toUpperCase())
            when 'POST' or 'PUT' then return @stringify(data)
            else return data

    stringify: (data) ->
        return JSON.stringify(data)

    request: (request, callback) ->
        parts = {
            hostname: @options.hostname
            host: @options.hostname
            port: @options.port
            scheme: @options.scheme
            path: '/'+@options.version
            method: request.method,
            withCredentials: false
        }
        parts.path = '/'+@options.version + @getPath(request.resource, request.id, request.action, request.key)

        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.path += MojioClient._makeParameters(request.parameters)

        parts.headers = {}
        parts.headers["ApiToken"] = @getTokenId() if @getTokenId()?
        parts.headers += request.headers if (request.headers?)
        #parts.headers["Access-Control-Allow-Credentials"] = 'true'
        parts.headers["Content-Type"] = 'application/json'

        parts.body = request.body if request.body?

        http = new Http()
        http.request(parts, callback)

    ###
        Authorize and Login
    ###
    login_resource: 'Login'

    authorize: (redirect_url, scope='full') ->
        parts = {
            hostname: @options.hostname
            host: @options.hostname
            port: @options.port
            scheme: @options.scheme
            path: '/OAuth2/authorize'
            method: 'Get'
            withCredentials: false
        }
        parts.path += "?response_type=token"
        parts.path += "&client_id=" + @options.application
        parts.path += "&redirect_uri="+redirect_url
        parts.path += "&scope="+scope
        parts.headers = {}
        parts.headers["ApiToken"] = @getTokenId() if @getTokenId()?
        parts.headers["Content-Type"] = 'application/json'

        url = parts.scheme+"://"+parts.host+":"+parts.port+parts.path
        window.location = url

    token: (callback) ->
        @user = null

        match = document.location.hash.match(/access_token=([0-9a-f-]{36})/)
        token = !!match && match[1]
        if (!token)
            callback("token for authorization not found.", null)
        else
            # get the user id by requesting login information, then set the auth_token:
            @request(
                {
                    method: 'GET', resource: @login_resource, id: @options.application,
                    parameters:
                        {
                            id: token
                        }
                },
            (error, result) =>
                if error
                    callback(error, null)
                else
                    # set the @auth_token
                    @auth_token = result
                    callback(null, @auth_token)
            )

    unauthorize: (redirect_url) ->
        parts = {
            hostname: @options.hostname
            host: @options.hostname
            port: @options.port
            scheme: @options.scheme
            path: '/account/logout'
            method: 'Get'
            withCredentials: false
        }
        parts.path += "?Guid=" + @getTokenId()
        parts.path += "&client_id=" + @options.application
        parts.path += "&redirect_uri="+redirect_url
        parts.headers = {}
        parts.headers["ApiToken"] = @getTokenId() if @getTokenId()?
        parts.headers["Content-Type"] = 'application/json'

        url = parts.scheme+"://"+parts.host+":"+parts.port+parts.path
        window.location = url

    _login: (username, password, callback) -> # Use if you want the raw result of the call.
        @request(
            {
                method: 'POST', resource: @login_resource, id: @options.application,
                parameters:
                    {
                        userOrEmail: username
                        password: password
                        secretKey: @options.secret
                    }
            }, callback
        )

    # Login
    login: (username, password, callback) ->
        @_login(username, password, (error, result) =>
            if (result?)
                @auth_token = result
            callback(error, result)
        )

    _logout: (callback) ->
        @request(
            {
                method: 'DELETE', resource: @login_resource,
                id: if mojio_token? then mojio_token else @getTokenId()
            }, callback
        )

    # Logout
    logout: (callback) ->
        @_logout((error, result) =>
            @auth_token = null
            callback(error, result)
        )

    mojio_models = {}  # this is so model can use a string to constuct the model.


    App = require('../models/App');
    mojio_models['App'] = App

    Mojio = require('../models/Mojio');
    mojio_models['Mojio'] = Mojio

    Trip = require('../models/Trip');
    mojio_models['Trip'] = Trip

    User = require('../models/User');
    mojio_models['User'] = User

    Vehicle = require('../models/Vehicle');
    mojio_models['Vehicle'] = Vehicle

    Product = require('../models/Product');
    mojio_models['Product'] = Product

    Subscription = require('../models/Subscription');
    mojio_models['Subscription'] = Subscription

    Event = require('../models/Event');
    mojio_models['Event'] = Event


    Observer = require('../models/Observer');
    mojio_models['Observer'] = Observer

    # Make an app from a result
    model: (type, json=null) ->
        if (json == null)
            return mojio_models[type]
        else if (json.Data? and json.Data instanceof Array)
            object = json
            object.Objects = new Array()
            object.Objects.push(new mojio_models[type](data)) for data in json.Data
        else if (json.Data?)
            object = new mojio_models[type](json.Data)
        else
            object = new mojio_models[type](json)
        object._client = @
        return object

    # Model CRUD
    # query(model, { criteria={ }, limit=10, offset=0, sortby="name", desc=false }, callback) # take parameters as parameters.
    # query(model, { criteria={ name="blah", field="blah" }, limit=10, offset=0, sortby="name", desc=false }, callback) # take parameters as parameters.
    # query(model, { criteria="name=blah; field=blah", limit=10, offset=0, sortby="name", desc=false }, callback)
    # query(model, { limit=10, offset=0, sortby="name", desc=false }, callback)
    query: (model, parameters, callback) ->
        if (parameters instanceof Object)
            # convert criteria to a semicolon separated list of property values if it's an object.
            if (parameters.criteria instanceof Object) # if the list contain "Criteria" as an object
                # convert to semicolon separated list.
                query_criteria = ""
                for property, value of parameters.criteria
                    query_criteria += "#{property}=#{value};"
                parameters.criteria = query_criteria;

            @request({ method: 'GET',  resource: model.resource(), parameters: parameters}, (error, result) =>
                callback(error, @model(model.model(), result))
            )
        else if (typeof parameters == "string") # instanceof only works for coffeescript classes.

            @request({ method: 'GET',  resource: model.resource(), parameters: {id: parameters} }, (error, result) =>
                callback(error, @model(model.model(), result))
            )
        else
            callback("criteria given is not in understood format, string or object.",null)


    get: (model, criteria, callback) ->
        @query(model, criteria, callback)

    save: (model, callback) ->
        @request({ method: 'PUT', resource: model.resource(), body: model.stringify(), parameters: {id: model._id} }, callback)

    put: (model, callback) ->
        @save(model, callback)

    create: (model, callback) ->
        @request({ method: 'POST', resource: model.resource(), body: model.stringify() }, callback)

    post: (model, callback) ->
        @create(model, callback)

    delete: (model, callback) ->
        @request({ method: 'DELETE',  resource: model.resource(), parameters: {id: model._id} }, callback)

    ###
            Schema
    ###
    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: 'Schema'}, callback)

    schema: (callback) ->
        @_schema((error, result) => callback(error, result))

    ###
            Observers
    ###

    watch: (observer, observer_callback, callback) ->
        @request({ method: 'POST', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
            if error
                callback(error, null)
            else
                observer = new Observer(result)
                @signalr.subscribe(@options.signalr_hub, 'Subscribe', observer.id(), observer.Subject, observer_callback, (error, result) ->
                    callback(null, observer)
                )
                return observer
        )

    ignore: (observer, observer_callback, callback) ->
        if !observer
            callback("Observer required.")
        if (observer['subject']?)
            if (observer.parent == null)
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.subject.id(), observer_callback, callback)
            else
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.subject.model(), observer_callback, callback)
        else
            if (observer.parent == null)
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.SubjectId, observer_callback, callback)
            else
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.Subject, observer_callback, callback)

    observe: (subject, parent=null, observer_callback, callback) ->
        # subject is { model: type, _id: id }
        if (parent == null)
            observer = new Observer(
                {
                    ObserverType: "Generic", Status: "Approved", Name: "Test"+Math.random(),
                    Subject: subject.model(), SubjectId: subject.id(), "Transports": "SignalR"
                }
            )
            @request({ method: 'PUT', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
                if error
                    callback(error, null)
                else
                    observer = new Observer(result)
                    @signalr.subscribe(@options.signalr_hub, 'Subscribe', observer.id(), observer.SubjectId, observer_callback, (error, result) ->
                        callback(null, observer)
                    )
            )

        else
            observer = new Observer(
                {
                    ObserverType: "Generic", Status: null, Name: "Test"+Math.random(),
                    Subject: subject.model(),
                    Parent: parent.model(), ParentId: parent.id(), "Transports": "SignalR"
                }
            )
            @request({ method: 'PUT', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
                if error
                    callback(error, null)
                else
                    observer = new Observer(result)
                    @signalr.subscribe(@options.signalr_hub, 'Subscribe', observer.id(), subject.model(), observer_callback, (error, result) ->
                        callback(null, observer)
                    )
            )

    unobserve: (observer, subject, parent, observer_callback, callback) ->
        if !observer || !subject?
            callback("Observer and subject required.")
        else if (parent == null)
            @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), subject.id(), observer_callback, callback)
        else
            @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), subject.model(), observer_callback, callback)

    ###
        Storage
    ###

    store: (model, key, value, callback) ->
        if !model || !model._id
            callback("Storage requires an object with a valid id.")
        else
            @request({ method: 'PUT', resource: model.resource(), id: model.id(), action: 'store', key: key, body: JSON.stringify(value) }, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )
    storage: (model, key, callback) ->
        if !model || !model._id
            callback("Get of storage requires an object with a valid id.")
        else
            @request({ method: 'GET', resource: model.resource(), id: model.id(), action: 'store', key: key}, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )

    unstore: (model, key, callback) ->
        if !model || !model._id
            callback("Storage requires an object with a valid id.")
        else
            @request({ method: 'DELETE', resource: model.resource(), id: model.id(), action: 'store', key: key}, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )

    ###
        Token/User
    ###

    getTokenId:  () ->
        return @auth_token._id if @auth_token?
        return null;

    getUserId:  () ->
        return @auth_token.UserId if @auth_token?
        return null

    isLoggedIn: () ->
        return @getUserId() != null

    getCurrentUser: (callback) ->
        if (@user?)
            callback(@user)
        else if (@isLoggedIn())
            get('users', @getUserId())
            .done( (user) ->
                    return unless (user?)
                    @user = user if (@getUserId() == @user._id)
                    callback(@user)
                )
        else
            return false
        return true

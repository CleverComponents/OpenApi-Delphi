{
  Copyright (C) 2022 by Clever Components

  Author: Sergey Shirokov <admin@clevercomponents.com>

  Website: www.CleverComponents.com

  This file is part of Google API Client Library for Delphi.

  Google API Client Library for Delphi is free software:
  you can redistribute it and/or modify it under the terms of
  the GNU Lesser General Public License version 3
  as published by the Free Software Foundation and appearing in the
  included file COPYING.LESSER.

  Google API Client Library for Delphi is distributed in the hope
  that it will be useful, but WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with Json Serializer. If not, see <http://www.gnu.org/licenses/>.

  The current version of Google API Client Library for Delphi needs for
  the non-free library Clever Internet Suite. This is a drawback,
  and we suggest the task of changing
  the program so that it does the same job without the non-free library.
  Anyone who thinks of doing substantial further work on the program,
  first may free it from dependence on the non-free library.
}

unit OpenApi.Model;

interface

uses
  System.Classes, System.Generics.Collections, System.SysUtils, Winapi.Windows,
  clJsonSerializerBase;

//https://github.com/OAI/OpenAPI-Specification

type
  TReferenceObject = class
  private
    FRef: string;
  public
    [TclJsonRequired]
    [TclJsonString('$ref')]
    property Ref: string read FRef write FRef;
  end;

  TContactObject = class
  private
    FName: string;
    FUrl: string;
    FEmail: string;
  public
    [TclJsonString('name')]
    property Name: string read FName write FName;

    [TclJsonString('url')]
    property Url: string read FUrl write FUrl;

    [TclJsonString('email')]
    property Email: string read FEmail write FEmail;
  end;

  TLicenseObject = class
  private
    FName: string;
    FUrl: string;
  public
    [TclJsonString('name')]
    property Name: string read FName write FName;

    [TclJsonString('url')]
    property Url: string read FUrl write FUrl;
  end;

  TInfoObject = class
  private
    FTitle: string;
    FDescription: string;
    FTermsOfService: string;
    FContact: TContactObject;
    FLicense: TLicenseObject;
    FVersion: string;

    procedure SetContact(const Value: TContactObject);
    procedure SetLicense(const Value: TLicenseObject);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonRequired]
    [TclJsonString('title')]
    property Title: string read FTitle write FTitle;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonString('termsOfService')]
    property TermsOfService: string read FTermsOfService write FTermsOfService;

    [TclJsonProperty('contact')]
    property Contact: TContactObject read FContact write SetContact;

    [TclJsonProperty('license')]
    property License: TLicenseObject read FLicense write SetLicense;

    [TclJsonRequired]
    [TclJsonString('version')]
    property Version: string read FVersion write FVersion;
  end;

  TServerVariableObject = class
  private
    FDescription: string;
    FDefault_: string;
    FEnum: TArray<string>;
  public
    [TclJsonString('enum')]
    property Enum: TArray<string> read FEnum write FEnum;

    [TclJsonRequired]
    [TclJsonString('default')]
    property Default_: string read FDefault_ write FDefault_;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;
  end;

  TServerVariablesMap = class(TObjectDictionary<string, TServerVariableObject>);

  TServerObject = class
  private
    FDescription: string;
    FUrl: string;
    FVariables: TServerVariablesMap;

    procedure SetVariables(const Value: TServerVariablesMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonRequired]
    [TclJsonString('url')]
    property Url: string read FUrl write FUrl;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonMap('variables')]
    property Variables: TServerVariablesMap read FVariables write SetVariables;
  end;

  TSecurityRequirementObject = class
    //TODO {name}	[string] - array map in dictionary
  end;

  TExternalDocumentationObject = class
  private
    FDescription: string;
    FUrl: string;
  public
    [TclJsonRequired]
    [TclJsonString('url')]
    property Url: string read FUrl write FUrl;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;
  end;

  TParameterObject = class;
  THeaderMap = class;
  TMediaTypeMap = class;

  TRequestBodyObject = class(TReferenceObject)
  private
    FRequired: Boolean;
    FDescription: string;
    FContent: TMediaTypeMap;

    procedure SetContent(const Value: TMediaTypeMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonRequired]
    [TclJsonMap('content')]
    property Content: TMediaTypeMap read FContent write SetContent;

    [TclJsonProperty('required')]
    property Required: Boolean read FRequired write FRequired;
  end;

  TRequestBodyMap = class(TObjectDictionary<string, TRequestBodyObject>);

  TLinkObject = class(TReferenceObject)
  private
    FOperationRef: string;
    FOperationId: string;
    FDescription: string;
    FServer: TServerObject;

    procedure SetServer(const Value: TServerObject);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('operationRef')]
    property OperationRef: string read FOperationRef write FOperationRef;

    [TclJsonString('operationId')]
    property OperationId: string read FOperationId write FOperationId;

    //TODO parameters	Map[string, Any | {expression}]
    //requestBody	Any | {expression}

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonProperty('server')]
    property Server: TServerObject read FServer write SetServer;
  end;

  TLinkMap = class(TObjectDictionary<string, TLinkObject>);

  TResponseObject = class(TReferenceObject)
  private
    FDescription: string;
    FHeaders: THeaderMap;
    FContent: TMediaTypeMap;
    FLinks: TLinkMap;

    procedure SetHeaders(const Value: THeaderMap);
    procedure SetContent(const Value: TMediaTypeMap);
    procedure SetLinks(const Value: TLinkMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonRequired]
    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonMap('headers')]
    property Headers: THeaderMap read FHeaders write SetHeaders;

    [TclJsonMap('content')]
    property Content: TMediaTypeMap read FContent write SetContent;

    [TclJsonMap('links')]
    property Links: TLinkMap read FLinks write SetLinks;
  end;

  TResponseMap = class(TObjectDictionary<string, TResponseObject>);

  TResponsesObject = class(TResponseMap)
  private
    FDefault_: TResponseObject;
    procedure SetDefault_(const Value: TResponseObject);
  public
    constructor Create(Ownerships: TDictionaryOwnerships; ACapacity: Integer = 0);
    destructor Destroy; override;

    [TclJsonProperty('default')]
    property Default_: TResponseObject read FDefault_ write SetDefault_;
  end;

  TCallbackObject = class(TReferenceObject)
    //TODO {expression}	Path Item Object
  end;

  TCallbackMap = class(TObjectDictionary<string, TCallbackObject>);

  TOperationObject = class
  private
    FTags: TArray<string>;
    FDescription: string;
    FSummary: string;
    FExternalDocs: TExternalDocumentationObject;
    FOperationId: string;
    FParameters: TArray<TParameterObject>;
    FRequestBody: TRequestBodyObject;
    FResponses: TResponsesObject;
    FServers: TArray<TServerObject>;
    FSecurity: TArray<TSecurityRequirementObject>;
    FDeprecated_: Boolean;
    FCallbacks: TCallbackMap;

    procedure SetExternalDocs(const Value: TExternalDocumentationObject);
    procedure SetParameters(const Value: TArray<TParameterObject>);
    procedure SetRequestBody(const Value: TRequestBodyObject);
    procedure SetResponses(const Value: TResponsesObject);
    procedure SetServers(const Value: TArray<TServerObject>);
    procedure SetSecurity(const Value: TArray<TSecurityRequirementObject>);
    procedure SetCallbacks(const Value: TCallbackMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('tags')]
    property Tags: TArray<string> read FTags write FTags;

    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonProperty('externalDocs')]
    property ExternalDocs: TExternalDocumentationObject read FExternalDocs write SetExternalDocs;

    [TclJsonString('operationId')]
    property OperationId: string read FOperationId write FOperationId;

    [TclJsonProperty('parameters')]
    property Parameters: TArray<TParameterObject> read FParameters write SetParameters;

    [TclJsonProperty('requestBody')]
    property RequestBody: TRequestBodyObject read FRequestBody write SetRequestBody;

    [TclJsonRequired]
    [TclJsonMap('responses')]
    property Responses: TResponsesObject read FResponses write SetResponses;

    [TclJsonMap('callbacks')]
    property Callbacks: TCallbackMap read FCallbacks write SetCallbacks;

    [TclJsonProperty('deprecated')]
    property Deprecated_: Boolean read FDeprecated_ write FDeprecated_;

    [TclJsonProperty('security')]
    property Security: TArray<TSecurityRequirementObject> read FSecurity write SetSecurity;

    [TclJsonProperty('servers')]
    property Servers: TArray<TServerObject> read FServers write SetServers;
  end;

  TSchemaObject = class(TReferenceObject)
  private
    FType_: string;
  public
    [TclJsonString('type')]
    property Type_: string read FType_ write FType_;

    //TODO JSON Schema definition
  end;

  TSchemaMap = class(TObjectDictionary<string, TSchemaObject>);

  TEncodingObject = class
  private
    FContentType: string;
    FStyle: string;
    FAllowReserved: Boolean;
    FExplode: Boolean;
    FHeaders: THeaderMap;

    procedure SetHeaders(const Value: THeaderMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('contentType')]
    property ContentType: string read FContentType write FContentType;

    [TclJsonMap('headers')]
    property Headers: THeaderMap read FHeaders write SetHeaders;

    [TclJsonString('style')]
    property Style: string read FStyle write FStyle;

    [TclJsonProperty('explode')]
    property Explode: Boolean read FExplode write FExplode;

    [TclJsonProperty('allowReserved')]
    property AllowReserved: Boolean read FAllowReserved write FAllowReserved;
  end;

  TEncodingMap = class(TObjectDictionary<string, TEncodingObject>);

  TExampleObject = class(TReferenceObject)
  private
    FExternalValue: string;
    FDescription: string;
    FSummary: string;
  public
    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    //TODO value	Any

    [TclJsonString('externalValue')]
    property ExternalValue: string read FExternalValue write FExternalValue;
  end;

  TExampleMap = class(TObjectDictionary<string, TExampleObject>);

  TMediaTypeObject = class
  private
    FSchema: TSchemaObject;
    FEncoding: TEncodingMap;
    FExamples: TExampleMap;

    procedure SetSchema(const Value: TSchemaObject);
    procedure SetEncoding(const Value: TEncodingMap);
    procedure SetExamples(const Value: TExampleMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonProperty('schema')]
    property Schema: TSchemaObject read FSchema write SetSchema;

    //TODO example	Any

    [TclJsonMap('examples')]
    property Examples: TExampleMap read FExamples write SetExamples;

    [TclJsonMap('encoding')]
    property Encoding: TEncodingMap read FEncoding write SetEncoding;
  end;

  TMediaTypeMap = class(TObjectDictionary<string, TMediaTypeObject>);

  THeaderObject = class(TReferenceObject)
  private
    FDescription: string;
    FRequired: Boolean;
    FDeprecated: Boolean;
    FAllowEmptyValue: Boolean;
    FStyle: string;
    FExplode: Boolean;
    FAllowReserved: Boolean;
    FSchema: TSchemaObject;
    FContent: TMediaTypeMap;
    FExamples: TExampleMap;

    procedure SetSchema(const Value: TSchemaObject);
    procedure SetContent(const Value: TMediaTypeMap);
    procedure SetExamples(const Value: TExampleMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonProperty('required')]
    property Required: Boolean read FRequired write FRequired;

    [TclJsonProperty('deprecated')]
    property Deprecated: Boolean read FDeprecated write FDeprecated;

    [TclJsonProperty('allowEmptyValue')]
    property AllowEmptyValue: Boolean read FAllowEmptyValue write FAllowEmptyValue;

    [TclJsonString('style')]
    property Style: string read FStyle write FStyle;

    [TclJsonProperty('explode')]
    property Explode: Boolean read FExplode write FExplode;

    [TclJsonProperty('allowReserved')]
    property AllowReserved: Boolean read FAllowReserved write FAllowReserved;

    [TclJsonProperty('schema')]
    property Schema: TSchemaObject read FSchema write SetSchema;

    //TODO example	Any

    [TclJsonMap('examples')]
    property Examples: TExampleMap read FExamples write SetExamples;

    [TclJsonMap('content')]
    property Content: TMediaTypeMap read FContent write SetContent;
  end;

  THeaderMap = class(TObjectDictionary<string, THeaderObject>);

  TParameterObject = class(THeaderObject)
  private
    FName: string;
    FIn_: string;
  public
    [TclJsonRequired]
    [TclJsonString('name')]
    property Name: string read FName write FName;

    [TclJsonRequired]
    [TclJsonString('in')]
    property In_: string read FIn_ write FIn_;
  end;

  TParameterMap = class(TObjectDictionary<string, TParameterObject>);

  TPathItemObject = class
  private
    FRef: string;
    FSummary: string;
    FDescription: string;
    FGet: TOperationObject;
    FPut: TOperationObject;
    FPost: TOperationObject;
    FDelete: TOperationObject;
    FOptions: TOperationObject;
    FHead: TOperationObject;
    FPatch: TOperationObject;
    FTrace: TOperationObject;
    FServers: TArray<TServerObject>;
    FParameters: TArray<TParameterObject>;

    procedure SetGet(const Value: TOperationObject);
    procedure SetPut(const Value: TOperationObject);
    procedure SetPost(const Value: TOperationObject);
    procedure SetDelete(const Value: TOperationObject);
    procedure SetOptions(const Value: TOperationObject);
    procedure SetHead(const Value: TOperationObject);
    procedure SetPatch(const Value: TOperationObject);
    procedure SetTrace(const Value: TOperationObject);
    procedure SetServers(const Value: TArray<TServerObject>);
    procedure SetParameters(const Value: TArray<TParameterObject>);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('$ref')]
    property Ref: string read FRef write FRef;

    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonProperty('get')]
    property Get: TOperationObject read FGet write SetGet;

    [TclJsonProperty('put')]
    property Put: TOperationObject read FPut write SetPut;

    [TclJsonProperty('post')]
    property Post: TOperationObject read FPost write SetPost;

    [TclJsonProperty('delete')]
    property Delete: TOperationObject read FDelete write SetDelete;

    [TclJsonProperty('options')]
    property Options: TOperationObject read FOptions write SetOptions;

    [TclJsonProperty('head')]
    property Head: TOperationObject read FHead write SetHead;

    [TclJsonProperty('patch')]
    property Patch: TOperationObject read FPatch write SetPatch;

    [TclJsonProperty('trace')]
    property Trace: TOperationObject read FTrace write SetTrace;

    [TclJsonProperty('servers')]
    property Servers: TArray<TServerObject> read FServers write SetServers;

    [TclJsonProperty('parameters')]
    property Parameters: TArray<TParameterObject> read FParameters write SetParameters;
  end;

  TPathsObject = class(TObjectDictionary<string, TPathItemObject>);

  TOAuthFlowObject = class
  private
    FAuthorizationUrl: string;
    FTokenUrl: string;
    FRefreshUrl: string;
  public
    [TclJsonRequired]
    [TclJsonString('authorizationUrl')]
    property AuthorizationUrl: string read FAuthorizationUrl write FAuthorizationUrl;

    [TclJsonRequired]
    [TclJsonString('tokenUrl')]
    property TokenUrl: string read FTokenUrl write FTokenUrl;

    [TclJsonRequired]
    [TclJsonString('refreshUrl')]
    property RefreshUrl: string read FRefreshUrl write FRefreshUrl;

    //TODO scopes	Map[string, string] REQUIRED - string map
  end;

  TOAuthFlowsObject = class
  private
    FImplicit: TOAuthFlowObject;
    FPassword: TOAuthFlowObject;
    FClientCredentials: TOAuthFlowObject;
    FAuthorizationCode: TOAuthFlowObject;

    procedure SetImplicit(const Value: TOAuthFlowObject);
    procedure SetPassword(const Value: TOAuthFlowObject);
    procedure SetClientCredentials(const Value: TOAuthFlowObject);
    procedure SetAuthorizationCode(const Value: TOAuthFlowObject);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonProperty('implicit')]
    property Implicit: TOAuthFlowObject read FImplicit write SetImplicit;

    [TclJsonProperty('password')]
    property Password: TOAuthFlowObject read FPassword write SetPassword;

    [TclJsonProperty('clientCredentials')]
    property ClientCredentials: TOAuthFlowObject read FClientCredentials write SetClientCredentials;

    [TclJsonProperty('authorizationCode')]
    property AuthorizationCode: TOAuthFlowObject read FAuthorizationCode write SetAuthorizationCode;
  end;

  TSecuritySchemeObject = class(TReferenceObject)
  private
    FType_: string;
    FDescription: string;
    FName: string;
    FIn_: string;
    FScheme: string;
    FBearerFormat: string;
    FOpenIdConnectUrl: string;
    FFlows: TOAuthFlowsObject;

    procedure SetFlows(const Value: TOAuthFlowsObject);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonRequired]
    [TclJsonString('type')]
    property Type_: string read FType_ write FType_;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonString('name')]
    property Name: string read FName write FName;

    [TclJsonString('in')]
    property In_: string read FIn_ write FIn_;

    [TclJsonString('scheme')]
    property Scheme: string read FScheme write FScheme;

    [TclJsonString('bearerFormat')]
    property BearerFormat: string read FBearerFormat write FBearerFormat;

    [TclJsonProperty('flows')]
    property Flows: TOAuthFlowsObject read FFlows write SetFlows;

    [TclJsonString('openIdConnectUrl')]
    property OpenIdConnectUrl: string read FOpenIdConnectUrl write FOpenIdConnectUrl;
  end;

  TSecuritySchemeMap = class(TObjectDictionary<string, TSecuritySchemeObject>);

  TComponentsObject = class
  private
    FSchemas: TSchemaMap;
    FResponses: TResponseMap;
    FParameters: TParameterMap;
    FRequestBodies: TRequestBodyMap;
    FHeaders: THeaderMap;
    FLinks: TLinkMap;
    FCallbacks: TCallbackMap;
    FSecuritySchemes: TSecuritySchemeMap;
    FExamples: TExampleMap;

    procedure SetSchemas(const Value: TSchemaMap);
    procedure SetResponses(const Value: TResponseMap);
    procedure SetParameters(const Value: TParameterMap);
    procedure SetRequestBodies(const Value: TRequestBodyMap);
    procedure SetHeaders(const Value: THeaderMap);
    procedure SetCallbacks(const Value: TCallbackMap);
    procedure SetLinks(const Value: TLinkMap);
    procedure SetSecuritySchemes(const Value: TSecuritySchemeMap);
    procedure SetExamples(const Value: TExampleMap);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonMap('schemas')]
    property Schemas: TSchemaMap read FSchemas write SetSchemas;

    [TclJsonMap('responses')]
    property Responses: TResponseMap read FResponses write SetResponses;

    [TclJsonMap('parameters')]
    property Parameters: TParameterMap read FParameters write SetParameters;

    [TclJsonMap('examples')]
    property Examples: TExampleMap read FExamples write SetExamples;

    [TclJsonMap('requestBodies')]
    property RequestBodies: TRequestBodyMap read FRequestBodies write SetRequestBodies;

    [TclJsonMap('headers')]
    property Headers: THeaderMap read FHeaders write SetHeaders;

    [TclJsonMap('securitySchemes')]
    property SecuritySchemes: TSecuritySchemeMap read FSecuritySchemes write SetSecuritySchemes;

    [TclJsonMap('links')]
    property Links: TLinkMap read FLinks write SetLinks;

    [TclJsonMap('callbacks')]
    property Callbacks: TCallbackMap read FCallbacks write SetCallbacks;
  end;

  TTagObject = class
  private
    FName: string;
    FDescription: string;
    FExternalDocs: TExternalDocumentationObject;

    procedure SetExternalDocs(const Value: TExternalDocumentationObject);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonRequired]
    [TclJsonString('name')]
    property Name: string read FName write FName;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonProperty('externalDocs')]
    property ExternalDocs: TExternalDocumentationObject read FExternalDocs write SetExternalDocs;
  end;

  TOpenApiObject = class
  private
    FOpenApi: string;
    FInfo: TInfoObject;
    FServers: TArray<TServerObject>;
    FPaths: TPathsObject;
    FComponents: TComponentsObject;
    FSecurity: TArray<TSecurityRequirementObject>;
    FTags: TArray<TTagObject>;
    FExternalDocs: TExternalDocumentationObject;

    procedure SetInfo(const Value: TInfoObject);
    procedure SetServers(const Value: TArray<TServerObject>);
    procedure SetPaths(const Value: TPathsObject);
    procedure SetComponents(const Value: TComponentsObject);
    procedure SetSecurity(const Value: TArray<TSecurityRequirementObject>);
    procedure SetTags(const Value: TArray<TTagObject>);
    procedure SetExternalDocs(const Value: TExternalDocumentationObject);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonRequired]
    [TclJsonString('openapi')]
    property OpenApi: string read FOpenApi write FOpenApi;

    [TclJsonRequired]
    [TclJsonProperty('info')]
    property Info: TInfoObject read FInfo write SetInfo;

    [TclJsonProperty('servers')]
    property Servers: TArray<TServerObject> read FServers write SetServers;

    [TclJsonRequired]
    [TclJsonMap('paths')]
    property Paths: TPathsObject read FPaths write SetPaths;

    [TclJsonProperty('components')]
    property Components: TComponentsObject read FComponents write SetComponents;

    [TclJsonProperty('security')]
    property Security: TArray<TSecurityRequirementObject> read FSecurity write SetSecurity;

    [TclJsonProperty('tags')]
    property Tags: TArray<TTagObject> read FTags write SetTags;

    [TclJsonProperty('externalDocs')]
    property ExternalDocs: TExternalDocumentationObject read FExternalDocs write SetExternalDocs;
  end;

implementation

{ TOpenApiObject }

constructor TOpenApiObject.Create;
begin
  inherited Create();

  FInfo := nil;
  FServers := nil;
  FPaths := nil;
  FComponents := nil;
  FSecurity := nil;
  FTags := nil;
  FExternalDocs := nil;
end;

destructor TOpenApiObject.Destroy;
begin
  ExternalDocs := nil;
  Tags := nil;
  Security := nil;
  Components := nil;
  Paths := nil;
  Servers := nil;
  Info := nil;

  inherited Destroy();
end;

procedure TOpenApiObject.SetComponents(const Value: TComponentsObject);
begin
  FComponents.Free();
  FComponents := Value;
end;

procedure TOpenApiObject.SetExternalDocs(const Value: TExternalDocumentationObject);
begin
  FExternalDocs.Free();
  FExternalDocs := Value;
end;

procedure TOpenApiObject.SetInfo(const Value: TInfoObject);
begin
  FInfo.Free();
  FInfo := Value;
end;

procedure TOpenApiObject.SetPaths(const Value: TPathsObject);
begin
  FPaths.Free();
  FPaths := Value;
end;

procedure TOpenApiObject.SetSecurity(const Value: TArray<TSecurityRequirementObject>);
var
  obj: TObject;
begin
  if (FSecurity <> nil) then
  begin
    for obj in FSecurity do
    begin
      obj.Free();
    end;
  end;
  FSecurity := Value;
end;

procedure TOpenApiObject.SetServers(const Value: TArray<TServerObject>);
var
  obj: TObject;
begin
  if (FServers <> nil) then
  begin
    for obj in FServers do
    begin
      obj.Free();
    end;
  end;
  FServers := Value;
end;

procedure TOpenApiObject.SetTags(const Value: TArray<TTagObject>);
var
  obj: TObject;
begin
  if (FTags <> nil) then
  begin
    for obj in FTags do
    begin
      obj.Free();
    end;
  end;
  FTags := Value;
end;

{ TInfoObject }

constructor TInfoObject.Create;
begin
  inherited Create();

  FContact := nil;
  FLicense := nil;
end;

destructor TInfoObject.Destroy;
begin
  License := nil;
  Contact := nil;

  inherited Destroy();
end;

procedure TInfoObject.SetContact(const Value: TContactObject);
begin
  FContact.Free();
  FContact := Value;
end;

procedure TInfoObject.SetLicense(const Value: TLicenseObject);
begin
  FLicense.Free();
  FLicense := Value;
end;

{ TTagObject }

constructor TTagObject.Create;
begin
  inherited Create();
  FExternalDocs := nil;
end;

destructor TTagObject.Destroy;
begin
  ExternalDocs := nil;
  inherited Destroy();
end;

procedure TTagObject.SetExternalDocs(const Value: TExternalDocumentationObject);
begin
  FExternalDocs.Free();
  FExternalDocs := Value;
end;

{ TPathItemObject }

constructor TPathItemObject.Create;
begin
  inherited Create();

  FGet := nil;
  FPut := nil;
  FPost := nil;
  FDelete := nil;
  FOptions := nil;
  FHead := nil;
  FPatch := nil;
  FTrace := nil;
  FServers := nil;
  FParameters := nil;
end;

destructor TPathItemObject.Destroy;
begin
  Parameters := nil;
  Servers := nil;
  Trace := nil;
  Patch := nil;
  Head := nil;
  Options := nil;
  Delete := nil;
  Post := nil;
  Put := nil;
  Get := nil;

  inherited Destroy();
end;

procedure TPathItemObject.SetDelete(const Value: TOperationObject);
begin
  FDelete.Free();
  FDelete := Value;
end;

procedure TPathItemObject.SetGet(const Value: TOperationObject);
begin
  FGet.Free();
  FGet := Value;
end;

procedure TPathItemObject.SetHead(const Value: TOperationObject);
begin
  FHead.Free();
  FHead := Value;
end;

procedure TPathItemObject.SetOptions(const Value: TOperationObject);
begin
  FOptions.Free();
  FOptions := Value;
end;

procedure TPathItemObject.SetParameters(const Value: TArray<TParameterObject>);
var
  obj: TObject;
begin
  if (FParameters <> nil) then
  begin
    for obj in FParameters do
    begin
      obj.Free();
    end;
  end;
  FParameters := Value;
end;

procedure TPathItemObject.SetPatch(const Value: TOperationObject);
begin
  FPatch.Free();
  FPatch := Value;
end;

procedure TPathItemObject.SetPost(const Value: TOperationObject);
begin
  FPost.Free();
  FPost := Value;
end;

procedure TPathItemObject.SetPut(const Value: TOperationObject);
begin
  FPut.Free();
  FPut := Value;
end;

procedure TPathItemObject.SetServers(const Value: TArray<TServerObject>);
var
  obj: TObject;
begin
  if (FServers <> nil) then
  begin
    for obj in FServers do
    begin
      obj.Free();
    end;
  end;
  FServers := Value;
end;

procedure TPathItemObject.SetTrace(const Value: TOperationObject);
begin
  FTrace.Free();
  FTrace := Value;
end;

{ TServerObject }

constructor TServerObject.Create;
begin
  inherited Create();
  FVariables := nil;
end;

destructor TServerObject.Destroy;
begin
  Variables := nil;
  inherited Destroy();
end;

procedure TServerObject.SetVariables(const Value: TServerVariablesMap);
begin
  FVariables.Free();
  FVariables := Value;
end;

{ THeaderObject }

constructor THeaderObject.Create;
begin
  inherited Create();

  FSchema := nil;
  FContent := nil;
  FExamples := nil;
end;

destructor THeaderObject.Destroy;
begin
  Examples := nil;
  Content := nil;
  Schema := nil;

  inherited Destroy();
end;

procedure THeaderObject.SetContent(const Value: TMediaTypeMap);
begin
  FContent.Free();
  FContent := Value;
end;

procedure THeaderObject.SetExamples(const Value: TExampleMap);
begin
  FExamples.Free();
  FExamples := Value;
end;

procedure THeaderObject.SetSchema(const Value: TSchemaObject);
begin
  FSchema.Free();
  FSchema := Value;
end;

{ TMediaTypeObject }

constructor TMediaTypeObject.Create;
begin
  inherited Create();

  FSchema := nil;
  FEncoding := nil;
  FExamples := nil;
end;

destructor TMediaTypeObject.Destroy;
begin
  Examples := nil;
  Encoding := nil;
  Schema := nil;

  inherited Destroy();
end;

procedure TMediaTypeObject.SetEncoding(const Value: TEncodingMap);
begin
  FEncoding.Free();
  FEncoding := Value;
end;

procedure TMediaTypeObject.SetExamples(const Value: TExampleMap);
begin
  FExamples.Free();
  FExamples := Value;
end;

procedure TMediaTypeObject.SetSchema(const Value: TSchemaObject);
begin
  FSchema.Free();
  FSchema := Value;
end;

{ TEncodingObject }

constructor TEncodingObject.Create;
begin
  inherited Create();
  FHeaders := nil;
end;

destructor TEncodingObject.Destroy;
begin
  Headers := nil;
  inherited Destroy();
end;

procedure TEncodingObject.SetHeaders(const Value: THeaderMap);
begin
  FHeaders.Free();
  FHeaders := Value;
end;

{ TOperationObject }

constructor TOperationObject.Create;
begin
  inherited Create();

  FExternalDocs := nil;
  FParameters := nil;
  FRequestBody := nil;
  FResponses := nil;
  FServers := nil;
  FCallbacks := nil;
end;

destructor TOperationObject.Destroy;
begin
  Callbacks := nil;
  Servers := nil;
  Responses := nil;
  RequestBody := nil;
  Parameters := nil;
  ExternalDocs := nil;

  inherited Destroy();
end;

procedure TOperationObject.SetCallbacks(const Value: TCallbackMap);
begin
  FCallbacks.Free();
  FCallbacks := Value;
end;

procedure TOperationObject.SetExternalDocs(const Value: TExternalDocumentationObject);
begin
  FExternalDocs.Free();
  FExternalDocs := Value;
end;

procedure TOperationObject.SetParameters(const Value: TArray<TParameterObject>);
var
  obj: TObject;
begin
  if (FParameters <> nil) then
  begin
    for obj in FParameters do
    begin
      obj.Free();
    end;
  end;
  FParameters := Value;
end;

procedure TOperationObject.SetRequestBody(const Value: TRequestBodyObject);
begin
  FRequestBody.Free();
  FRequestBody := Value;
end;

procedure TOperationObject.SetResponses(const Value: TResponsesObject);
begin
  FResponses.Free();
  FResponses := Value;
end;

procedure TOperationObject.SetSecurity(const Value: TArray<TSecurityRequirementObject>);
var
  obj: TObject;
begin
  if (FSecurity <> nil) then
  begin
    for obj in FSecurity do
    begin
      obj.Free();
    end;
  end;
  FSecurity := Value;
end;

procedure TOperationObject.SetServers(const Value: TArray<TServerObject>);
var
  obj: TObject;
begin
  if (FServers <> nil) then
  begin
    for obj in FServers do
    begin
      obj.Free();
    end;
  end;
  FServers := Value;
end;

{ TResponsesObject }

constructor TResponsesObject.Create(Ownerships: TDictionaryOwnerships; ACapacity: Integer);
begin
  inherited Create(Ownerships, ACapacity);
  FDefault_ := nil;
end;

destructor TResponsesObject.Destroy;
begin
  Default_ := nil;
  inherited Destroy();
end;

procedure TResponsesObject.SetDefault_(const Value: TResponseObject);
begin
  FDefault_.Free();
  FDefault_ := Value;
end;

{ TResponseObject }

constructor TResponseObject.Create;
begin
  inherited Create();

  FHeaders := nil;
  FContent := nil;
  FLinks := nil;
end;

destructor TResponseObject.Destroy;
begin
  Links := nil;
  Content := nil;
  Headers := nil;

  inherited Destroy();
end;

procedure TResponseObject.SetContent(const Value: TMediaTypeMap);
begin
  FContent.Free();
  FContent := Value;
end;

procedure TResponseObject.SetHeaders(const Value: THeaderMap);
begin
  FHeaders.Free();
  FHeaders := Value;
end;

procedure TResponseObject.SetLinks(const Value: TLinkMap);
begin
  FLinks.Free();
  FLinks := Value;
end;

{ TLinkObject }

constructor TLinkObject.Create;
begin
  inherited Create();
  FServer := nil;
end;

destructor TLinkObject.Destroy;
begin
  Server := nil;
  inherited Destroy();
end;

procedure TLinkObject.SetServer(const Value: TServerObject);
begin
  FServer.Free();
  FServer := Value;
end;

{ TRequestBodyObject }

constructor TRequestBodyObject.Create;
begin
  inherited Create();
  FContent := nil;
end;

destructor TRequestBodyObject.Destroy;
begin
  Content := nil;
  inherited Destroy();
end;

procedure TRequestBodyObject.SetContent(const Value: TMediaTypeMap);
begin
  FContent.Free();
  FContent := Value;
end;

{ TComponentsObject }

constructor TComponentsObject.Create;
begin
  inherited Create();

  FSchemas := nil;
  FResponses := nil;
  FParameters := nil;
  FRequestBodies := nil;
  FHeaders := nil;
  FCallbacks := nil;
  FLinks := nil;
  FSecuritySchemes := nil;
  FExamples := nil;
end;

destructor TComponentsObject.Destroy;
begin
  Examples := nil;
  SecuritySchemes := nil;
  Links := nil;
  Callbacks := nil;
  Headers := nil;
  RequestBodies := nil;
  Parameters := nil;
  Responses := nil;
  Schemas := nil;

  inherited Destroy();
end;

procedure TComponentsObject.SetCallbacks(const Value: TCallbackMap);
begin
  FCallbacks.Free();
  FCallbacks := Value;
end;

procedure TComponentsObject.SetExamples(const Value: TExampleMap);
begin
  FExamples.Free();
  FExamples := Value;
end;

procedure TComponentsObject.SetHeaders(const Value: THeaderMap);
begin
  FHeaders.Free();
  FHeaders := Value;
end;

procedure TComponentsObject.SetLinks(const Value: TLinkMap);
begin
  FLinks.Free();
  FLinks := Value;
end;

procedure TComponentsObject.SetParameters(const Value: TParameterMap);
begin
  FParameters.Free();
  FParameters := Value;
end;

procedure TComponentsObject.SetRequestBodies(const Value: TRequestBodyMap);
begin
  FRequestBodies.Free();
  FRequestBodies := Value;
end;

procedure TComponentsObject.SetResponses(const Value: TResponseMap);
begin
  FResponses.Free();
  FResponses := Value;
end;

procedure TComponentsObject.SetSchemas(const Value: TSchemaMap);
begin
  FSchemas.Free();
  FSchemas := Value;
end;

procedure TComponentsObject.SetSecuritySchemes(const Value: TSecuritySchemeMap);
begin
  FSecuritySchemes.Free();
  FSecuritySchemes := Value;
end;

{ TSecuritySchemeObject }

constructor TSecuritySchemeObject.Create;
begin
  inherited Create();
  FFlows := nil;
end;

destructor TSecuritySchemeObject.Destroy;
begin
  Flows := nil;
  inherited Destroy();
end;

procedure TSecuritySchemeObject.SetFlows(const Value: TOAuthFlowsObject);
begin
  FFlows.Free();
  FFlows := Value;
end;

{ TOAuthFlowsObject }

constructor TOAuthFlowsObject.Create;
begin
  inherited Create();

  FImplicit := nil;
  FPassword := nil;
  FClientCredentials := nil;
  FAuthorizationCode := nil;
end;

destructor TOAuthFlowsObject.Destroy;
begin
  AuthorizationCode := nil;
  ClientCredentials := nil;
  Password := nil;
  Implicit := nil;

  inherited Destroy();
end;

procedure TOAuthFlowsObject.SetAuthorizationCode(const Value: TOAuthFlowObject);
begin
  FAuthorizationCode.Free();
  FAuthorizationCode := Value;
end;

procedure TOAuthFlowsObject.SetClientCredentials(const Value: TOAuthFlowObject);
begin
  FClientCredentials.Free();
  FClientCredentials := Value;
end;

procedure TOAuthFlowsObject.SetImplicit(const Value: TOAuthFlowObject);
begin
  FImplicit.Free();
  FImplicit := Value;
end;

procedure TOAuthFlowsObject.SetPassword(const Value: TOAuthFlowObject);
begin
  FPassword.Free();
  FPassword := Value;
end;

end.

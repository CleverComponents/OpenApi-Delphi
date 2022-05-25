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
  System.Classes, System.Contnrs, System.SysUtils, Winapi.Windows, clJsonSerializerBase;

//https://github.com/OAI/OpenAPI-Specification

type
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

  TServerObject = class
  private
    FDescription: string;
    FUrl: string;
  public
    [TclJsonRequired]
    [TclJsonString('url')]
    property Url: string read FUrl write FUrl;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    //variables
  end;

  TPathsObject = class
    //TODO
  end;

  TComponentsObject = class
    //TODO
  end;

  TSecurityRequirementObject = class
    //TODO
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

//    [TclJsonRequired]
//    [TclJsonProperty('paths')]
    property Paths: TPathsObject read FPaths write SetPaths;

//    [TclJsonProperty('components')]
    property Components: TComponentsObject read FComponents write SetComponents;

//    [TclJsonProperty('security')]
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
  FExternalDocs.Free();
  SetTags(nil);
  SetSecurity(nil);
  FComponents.Free();
  FPaths.Free();
  SetServers(nil);
  FInfo.Free();

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
  FLicense.Free();
  FContact.Free();

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
  FExternalDocs.Free();
  inherited Destroy();
end;

procedure TTagObject.SetExternalDocs(const Value: TExternalDocumentationObject);
begin
  FExternalDocs.Free();
  FExternalDocs := Value;
end;

end.

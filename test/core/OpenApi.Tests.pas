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

unit OpenApi.Tests;

interface

uses
  System.Classes, System.SysUtils, TestFramework, OpenApi, OpenApi.Model,
  clJsonSerializer;

type
  TModelSerializerTests = class(TTestCase)
  private
    procedure CheckInfo(AInfo: TInfoObject);
    procedure CheckServers(AServers: TArray<TServerObject>);
    procedure CheckExternalDocs(AExternalDocs: TExternalDocumentationObject);
    procedure CheckTags(ATags: TArray<TTagObject>);
  published
    procedure TestDeserialize;
  end;

implementation

{ TModelSerializerTests }

procedure TModelSerializerTests.CheckInfo(AInfo: TInfoObject);
begin
  CheckTrue(nil <> AInfo);
  CheckEquals('Drive API', AInfo.Title);
  CheckEquals('v3', AInfo.Version);

  CheckTrue(nil <> AInfo.Contact);
  CheckEquals('Google', AInfo.Contact.Name);
  CheckEquals('https://google.com', AInfo.Contact.Url);

  CheckTrue(nil <> AInfo.License);
  CheckEquals('Creative Commons Attribution 3.0', AInfo.License.Name);
end;

procedure TModelSerializerTests.CheckServers(AServers: TArray<TServerObject>);
begin
  CheckTrue(nil <> AServers);
  CheckEquals(1, Length(AServers));
  CheckEquals('https://www.googleapis.com/drive/v3', AServers[0].Url);
end;

procedure TModelSerializerTests.CheckExternalDocs(AExternalDocs: TExternalDocumentationObject);
begin
  CheckTrue(nil <> AExternalDocs);
  CheckEquals('https://developers.google.com/drive/', AExternalDocs.Url);
end;

procedure TModelSerializerTests.CheckTags(ATags: TArray<TTagObject>);
begin
  CheckTrue(nil <> ATags);
  CheckTrue(0 < Length(ATags));
  CheckEquals('about', ATags[0].Name);
end;

procedure TModelSerializerTests.TestDeserialize;
var
  json: TStrings;
  serializer: TclJsonSerializer;
  obj: TOpenApiObject;
begin
  json := nil;
  serializer := nil;
  obj := nil;
  try
    json := TStringList.Create();

    json.LoadFromFile('..\..\data\openapi-google-drive.json', TEncoding.UTF8);
    serializer := TclJsonSerializer.Create();
    obj := serializer.JsonToObject<TOpenApiObject>(json.Text);
    CheckEquals('3.0.0', obj.OpenApi);
    CheckInfo(obj.Info);
    CheckServers(obj.Servers);
    CheckExternalDocs(obj.ExternalDocs);
    CheckTags(obj.Tags);
  finally
    obj.Free();
    serializer.Free();
    json.Free();
  end;
end;

initialization
  TestFramework.RegisterTest(TModelSerializerTests.Suite);

end.

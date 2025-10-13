unit UnitDocId;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DateUtils;

type
  InformationObjectType = (Document, Folder);

  TDocumentId = class
    private
      FId: string;
      FDatabaseName: string;
      FUuid: string;
      FDocumentDate: TDateTime;
      FVersion: integer;
      FInformationObjectType: InformationObjectType;
      procedure Parse;
    public
      constructor Create; overload;
      constructor Create(DocumentId: string); overload;
      procedure SetDocumentId(value: string);
      function GetDocumentId: string;
    published
      property FullDocumentId: string read GetDocumentId write SetDocumentId;
      property DatabaseName: string read FDatabaseName;
      property Uuid: string read FUuid;
      property DocumentDate: TDateTime read FDocumentDate;
      property InformationObjectType: InformationObjectType read FInformationObjectType;
      property Version: integer read FVersion;
  end;

implementation

  constructor TDocumentId.Create;
  begin
    inherited;
  end;

  constructor TDocumentId.Create(DocumentId: string);
  begin
    inherited;
    FId:=DocumentId;
    Parse;
  end;

  procedure TDocumentId.Parse;
  var
    DbLen, UuidLen, DateLen, DateStr, VersionLen: string;
    i, DbLenInt, UuidLenInt, DateLenInt, VersionLenInt: integer;
  begin
    if FId.Length < 4 then exit;
    if FId[1] = 'D' then
      FInformationObjectType:=Document
    else
      FInformationObjectType:=Folder;
    DbLen:=FId.Substring(2, 2);
    DbLenInt:=StrToInt('$' + DbLen);
    FDatabaseName:=FId.Substring(4, DbLenInt);
    i:=4 + DbLenInt;
    UuidLen:=FId.Substring(i, 2);
    i+=2;
    UuidLenInt:=StrToInt('$' + UuidLen);
    FUuid:=FId.Substring(i, UuidLenInt);
    i+=UuidLenInt;
    DateLen:=FId.Substring(i, 2);
    i+=2;
    DateLenInt:=StrToInt('$' + DateLen);
    DateStr:=FId.Substring(i, DateLenInt);
    i+=DateLenInt;
    VersionLen:=FId.Substring(i, 2);
    i+=2;
    VersionLenInt:=StrToInt('$' + VersionLen);
    FVersion:=StrToInt(FId.Substring(i, VersionLenInt));
    FDocumentDate:=ISO8601ToDate(DateStr, true);
  end;

  procedure TDocumentId.SetDocumentId(value: string);
  begin
    if FId <> value then
    begin
      FId:=value;
      Parse;
    end;
  end;

  function TDocumentId.GetDocumentId: string;
  begin
    Result:=FId;
  end;

end.


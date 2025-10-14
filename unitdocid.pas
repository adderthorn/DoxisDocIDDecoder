unit UnitDocId;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DateUtils;

type
  InformationObjectType = (None, Document, Folder, Task);

  TDocumentId = class
    private
      FId: string;
      FDatabaseName: string;
      FUuid: string;
      FDocumentDate: TDateTime;
      FVersion: integer;
      FInformationObjectType: InformationObjectType;
      FErrorMessage: string;
      FErrorPosition: integer;
      procedure Parse;
      procedure RaiseError(Pos: integer; Field: string);
    public
      constructor Create; overload;
      constructor Create(DocumentId: string); overload;
      destructor Destroy; override;
      procedure SetDocumentId(value: string);
      function GetDocumentId: string;
      function GetHasError: boolean;
    published
      property FullDocumentId: string read GetDocumentId write SetDocumentId;
      property DatabaseName: string read FDatabaseName;
      property Uuid: string read FUuid;
      property DocumentDate: TDateTime read FDocumentDate;
      property InformationObjectType: InformationObjectType read FInformationObjectType;
      property Version: integer read FVersion;
      property HasError: boolean read GetHasError;
      property ErrorMessage: string read FErrorMessage;
      property ErrorPosition: integer read FErrorPosition;
  end;

implementation

  constructor TDocumentId.Create;
  begin
    inherited;
  end;

  constructor TDocumentId.Create(DocumentId: string);
  begin
    FId:=DocumentId;
    Parse;
  end;

  destructor TDocumentId.Destroy;
  begin
    inherited;
  end;

  procedure TDocumentId.Parse;
  var
    DbLen, UuidLen, DateLen, DateStr, VersionLen: string;
    i, DbLenInt, UuidLenInt, DateLenInt, VersionLenInt: integer;
  begin
    if FId.Length < 4 then
    begin
      FErrorMessage:='Document ID is too short to be valid';
      FErrorPosition:=1;
      exit;
    end;
      FErrorMessage:='';
      FErrorPosition:=0;

    case FId[2] of
      'D': FInformationObjectType:=Document;
      'F','R': FInformationObjectType:=Folder;
      'T': FInformationObjectType:=Task;
    else
      FInformationObjectType:=None;
    end;
    i:=2;

    if (FInformationObjectType = None) then
    begin
      RaiseError(i, 'Information Object Type');
      exit;
    end;

    try
      DbLen:=FId.Substring(i, 2);
      DbLenInt:=StrToInt('$' + DbLen);
      FDatabaseName:=FId.Substring(4, DbLenInt);
    except
      RaiseError(i, 'Database Name');
      exit;
    end;

    try
      i:=4 + DbLenInt;
      UuidLen:=FId.Substring(i, 2);
      i+=2;
      UuidLenInt:=StrToInt('$' + UuidLen);
      FUuid:=FId.Substring(i, UuidLenInt);
    except
      RaiseError(i, 'UUID');
      exit;
    end;

    try
      i+=UuidLenInt;
      DateLen:=FId.Substring(i, 2);
      i+=2;
      DateLenInt:=StrToInt('$' + DateLen);
      DateStr:=FId.Substring(i, DateLenInt);
      FDocumentDate:=ISO8601ToDate(DateStr, true);
    except
      RaiseError(i, 'Document Date');
      exit;
    end;

    try
      i+=DateLenInt;
      VersionLen:=FId.Substring(i, 2);
      i+=2;
      VersionLenInt:=StrToInt('$' + VersionLen);
      FVersion:=StrToInt(FId.Substring(i, VersionLenInt));
    except
      RaiseError(i, 'Version');
      exit;
    end;
  end;

  procedure TDocumentId.RaiseError(Pos: integer; Field: string);
  var
    Msg: string;
  begin
    Msg:='Error parsing field `' + Field + '` at position ' + IntToStr(Pos);
    FErrorMessage:=Msg;
    FErrorPosition:=Pos;
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

  function TDocumentId.GetHasError: boolean;
  begin
    if FErrorPosition > 0 then
      Result:=true
    else
      Result:=false;
  end;

end.


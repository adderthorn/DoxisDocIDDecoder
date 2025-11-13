unit UnitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdActns,
  Menus, ExtCtrls, ComCtrls, StdCtrls, Buttons, SpinEx, DateTimePicker,
  UnitDocId, Clipbrd, DateUtils;

type

  { TFormMain }

  TFormMain = class(TForm)
    ActionDateCopyISO: TAction;
    ActionDateCopyYYYMMDD: TAction;
    FileParse: TAction;
    ActionList: TActionList;
    ButtonParse: TButton;
    DocumentDatePicker: TDateTimePicker;
    EditCopy: TEditCopy;
    EditCut: TEditCut;
    EditDelete: TEditDelete;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    FileExit: TFileExit;
    DocumentIdEdit: TLabeledEdit;
    DatabaseEdit: TLabeledEdit;
    LabelDocumentDate: TLabel;
    LabelVersion: TLabel;
    MenuItemDateCopyYYYYMMDD: TMenuItem;
    MenuItemDateCopyISO: TMenuItem;
    PopupMenuDateCopy: TPopupMenu;
    StatusBar: TStatusBar;
    UUIDEdit: TLabeledEdit;
    MainMenu: TMainMenu;
    MenuItemFileParse: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    MenuItemEditDel: TMenuItem;
    MenuItemEditPaste: TMenuItem;
    MenuItemEditCopy: TMenuItem;
    MenuItemEditCut: TMenuItem;
    MenuItemEditUndo: TMenuItem;
    MenuItemEdit: TMenuItem;
    MenuItemFileExit: TMenuItem;
    MenuItemFile: TMenuItem;
    RadioGroupObjectType: TRadioGroup;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    VersionSpin: TSpinEditEx;
    StaticTextError: TStaticText;
    procedure ActionDateCopy(Sender: TObject);
    procedure FileParseExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    DocumentId: TDocumentId;
    procedure RaiseStatus(Message: string);
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.RaiseStatus(Message: string);
begin
  StatusBar.Panels[0].Text:=Message;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DocumentId);
end;

procedure TFormMain.FileParseExecute(Sender: TObject);
var
  Sel: integer;
begin
  DocumentIdEdit.Text:=Trim(DocumentIdEdit.Text);
  FreeAndNil(DocumentId);
  DocumentId:=TDocumentId.Create(DocumentIdEdit.Text);
  if DocumentId.HasError then
  begin
    StaticTextError.Caption:=DocumentId.ErrorMessage;
    RaiseStatus('Error.');
    exit;
  end;
  Sel:=-1;
  case DocumentId.InformationObjectType of
    Document: Sel:=0;
    Folder: Sel:=1;
    Task: Sel:=2;
  end;
  RadioGroupObjectType.ItemIndex:=Sel;
  DatabaseEdit.Text:=DocumentId.DatabaseName;
  UUIDEdit.Text:=DocumentId.Uuid;
  DocumentDatePicker.DateTime:=DocumentId.DocumentDate;
  VersionSpin.Value:=DocumentId.Version;
  RaiseStatus('Parsed successfully');
  MainMenu.
end;

procedure TFormMain.ActionDateCopy(Sender: TObject);
var
  DateStr, Status: string;
  AnAction: TAction;
begin
  AnAction:=TAction(Sender);
  case AnAction.Tag of
    0: DateTimeToString(DateStr, 'yyyyMMdd', DocumentId.DocumentDate);
    1: DateStr:=DateToISO8601(DocumentId.DocumentDate, true);
  else
    DateStr:='';
  end;
  Clipboard.AsText:=DateStr;
  Status:=Format('Copied: "%s"', [DateStr]);
  RaiseStatus(Status);
end;

end.


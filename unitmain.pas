unit UnitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdActns,
  Menus, ExtCtrls, ComCtrls, Spin, StdCtrls, SpinEx, DateTimePicker, UnitDocId;

type

  { TFormMain }

  TFormMain = class(TForm)
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
    procedure FileParseExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    DocumentId: TDocumentId;
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

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
end;

end.


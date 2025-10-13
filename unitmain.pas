unit UnitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdActns,
  Menus;

type

  { TFormMain }

  TFormMain = class(TForm)
    ActionList: TActionList;
    FileExit: TFileExit;
    MainMenu: TMainMenu;
    MenuItemFileExit: TMenuItem;
    MenuItemFile: TMenuItem;
  private

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

end.


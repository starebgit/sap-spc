unit Izborsarza;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFIzborSarza = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    Button1: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    function Izbor(listsrz : Tstringlist) : string ;
  end;

var
  FIzborSarza: TFIzborSarza;

implementation

{$R *.dfm}

function TfIzborSarza.Izbor(listsrz : Tstringlist) : string ;
  var ii : integer ;
begin
  listbox1.items := listsrz ;
  ShowModal ;
  ii := listbox1.Itemindex ;
  if ii >= 0 then result := ListBox1.items[ii] else result := '' ;

end;

end.

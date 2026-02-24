unit IzborSrz;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFizborSrz = class(TForm)
    ListBox1: TListBox;
  private
    { Private declarations }
  public
    function izbira(listsrz: TstringList) : string ;
  end;

var
  FizborSrz: TFizborSrz;

implementation

{$R *.dfm}

function TFizborSrz.izbira(listsrz: TstringList) : string ;
  var ii : integer ;
begin
  listbox1.items := listsrz ;
  ShowModal ;
  ii := ListBox1.ItemIndex ;
  result := ListBox1.Items[ii] ;
end;

end.

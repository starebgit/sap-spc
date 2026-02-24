unit pass;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFPassw = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    Function Getpas : boolean ;
  end;

var
    Fpassw: TFpassw;

implementation

{$R *.dfm}

procedure TFPassw.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(13) then close ;

end;

Function TFPassw.Getpas : boolean ;
begin
  edit1.Text := '' ;
  ShowModal ;
  If Uppercase(edit1.text) = 'STROJNAX' then result := true else result := false ;
end ;

end.
